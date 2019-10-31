//
//  LoggingUtil.swift
//  Cheq
//
//  Created by Xuwei Liang on 3/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import Foundation

class LoggingUtil {
    
    let fcmMsgFile = "cLog.txt"
    
    static let shared = LoggingUtil()
    private init() {
    }
    
    // we will turn off this for prod use
    func cPrint(_ msg: Any...) {
        print(msg)
    }
    
    func cWriteToFile(_ file: String, newText: String) {
        
        createFileIfNeeded(file)
        let filename = self.getDocumentsDirectory().appendingPathComponent(file)
        do {
            let fileHandle = try FileHandle(forWritingTo: filename)
            fileHandle.seek(toFileOffset: 0)
            let oldData = try String(contentsOf: filename, encoding: .utf8).data(using: .utf8)!
            var data = newText.data(using: .utf8)!
            data.append(oldData)
            fileHandle.write(data)
            fileHandle.closeFile()
        } catch {
            return
        }
    }
    
    func createFileIfNeeded(_ file: String) {
        let filePath = getDocumentsDirectory().appendingPathComponent(file)
        do {
            let _ = try FileHandle(forWritingTo: filePath)
        } catch {
            try! "".data(using: .utf8)?.write(to: filePath)
        }
    }
    
    func printLocationFile(_ file: String)-> String {
        let filePath = getDocumentsDirectory().appendingPathComponent(file)
        do {
            let fileContent = try String(contentsOf: filePath, encoding: .utf8)
            print(fileContent)
            return fileContent
        }
        catch {
            return "error reading file"
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
