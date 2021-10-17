//
//  CSVWriter.swift
//  swingwatch WatchKit Extension
//
//  Created by 小池智哉 on 2021/10/17.
//

import Foundation

class CSVWriter: NSObject {
    var file: FileHandle?
    var filePath: URL?
    
    func open(_ filePath: URL, header: String? = nil) {
        do {
            FileManager.default.createFile(atPath: filePath.path, contents: nil, attributes: nil)
            let file = try FileHandle(forWritingTo: filePath)
            if header != nil {
                file.write((header! + "\n").data(using: .utf8)!)
            }
            self.file = file
            self.filePath = filePath
        } catch let error {
            print(error)
        }
    }
    
    func write(_ rows: [String]) {
        guard let file = self.file else { return }
        file.write((rows.joined(separator: "\n") + "\n").data(using: .utf8)!)
    }
    
    func close() -> URL? {
        guard let file = self.file else { return nil }
        file.closeFile()
        let url = self.filePath
        self.file = nil
        return url
    }
    
    static func makeFilePath(_ fileName: String) -> URL {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileUrl = url.appendingPathComponent("\(fileName).csv")
        return fileUrl
    }
}
