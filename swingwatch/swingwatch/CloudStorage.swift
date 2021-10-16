//
//  CloudStorage.swift
//  swingwatch
//
//  Created by 小池智哉 on 2021/10/16.
//

/**
    2021/10/16: 一旦swingsでフォルダ一つに対してデータを保存していくが、後でフォルダ構造とコード、このドキュメントを変更する予定。
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
}
