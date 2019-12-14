//
//  LoggingUtil.swift
//  Cheq
//
//  Created by Xuwei Liang on 3/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import Foundation

/**
 LoggingUtil is a utility class to abstract the logics in logging to console and to file. When we release the app to production, we can disable the logging easily by altering the logic encapsulated inside **LoggingUtil** rather than change the logics everywhere else.
 */
class LoggingUtil {
    
    /// File name to log fcm messages, we can turn this off before releasing to production
    let fcmMsgFile = "cLog.txt"
    
    /// Singleton instance of **LoggingUtil**
    static let shared = LoggingUtil()
    
    /// private init to implement the Singleton pattern
    private init() {
    }
    
    /// Encapsulating print to console logic, we turn off this for prod use
    func cPrint(_ msg: Any...) {
        #if DEV
            print(msg)
        #endif
    }
    
    /**
     Helper method to write a file with new text.
     - parameter file: target file's name to write against
     - parameter newText: text to write onto targeted file
    */
    func cWriteToFile(_ file: String, newText: String) {
        
        /// create file if it doesn't exist
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
    
    /**
     Helper method to create a given file by its name if it's doens't already exist
     - parameter file: filename to check against
    */
    func createFileIfNeeded(_ file: String) {
        let filePath = getDocumentsDirectory().appendingPathComponent(file)
        do {
            let _ = try FileHandle(forWritingTo: filePath)
        } catch {
            try! "".data(using: .utf8)?.write(to: filePath)
        }
    }
    
    /**
     Given a file name, print the app's path prefix to the file. This is a method use for debugging purpose.
     - parameter file: filename
     - Returns: location of file or error message
     */
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
    
    
    /**
     This method encapsulates the logic to find the current documents path of the app
     - Returns: URL of the directory path
    */
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
