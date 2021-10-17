//
//  CloudStorage.swift
//  swingwatch
//
//  Created by 小池智哉 on 2021/10/16.
//

/**
    2021/10/16: 一旦swingsでvideoフォルダ一つに対してデータを保存していくが、後でフォルダ構造とコード、このドキュメントを変更する予定。
*/

import Foundation
import FirebaseStorage

enum CloudStorage {
    private static let rootPath = "swings"
    
    static func storageRef() -> StorageReference {
        return Storage.storage().reference().child(rootPath)
    }
    
    static func videoFolderRef() -> StorageReference {
        return CloudStorage.storageRef().child("video")
    }
    
    static func motionFolderRef() -> StorageReference {
        return CloudStorage.storageRef().child("motion")
    }
    
    static func uploadToGCS(_ ref: StorageReference, fileUrl: URL, callback: @escaping (_ error: String?) -> Void) {
        ref.putFile(from: fileUrl, metadata: nil) { metadata, error in
            if let error = error {
                callback(error.localizedDescription)
            } else {
                print(metadata)
                callback(nil)
            }
        }
    }
    
    static func uploadVideoToGCS(_ fileUrl: URL, callback: @escaping (_ error: String?) -> Void) {
        let fileName = Date().toYYYYMMddHHmmssNoDelimiterString() + ".MOV"
        let ref = CloudStorage.videoFolderRef().child(fileName)
        CloudStorage.uploadToGCS(ref, fileUrl: fileUrl, callback: callback)
    }
    
    static func uploadMotionToGCS(_ fileUrl: URL, callback: @escaping (_ error: String?) -> Void) {
        let fileName = Date().toYYYYMMddHHmmssNoDelimiterString() + ".csv"
        let ref = CloudStorage.motionFolderRef().child(fileName)
        CloudStorage.uploadToGCS(ref, fileUrl: fileUrl, callback: callback)
    }
}
