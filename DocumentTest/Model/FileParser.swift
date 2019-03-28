//
//  FileParser.swift
//  TestSample
//
//  Created by perrion huds on 07/03/2019.
//  Copyright © 2019 perrion huds. All rights reserved.
//  https://github.com/marmelroy/FileBrowser/tree/master/FileBrowser
//

import Foundation

class FileParser {

    static let sharedInstance = FileParser()
    var excludesFilepaths: [URL]?
    var _excludesFileExtensions = [String]()
    let fileManager = FileManager.default
    
    // Mapped for case insensitivity
    var excludesFileExtensions: [String]?
    {
        get
        {
            return _excludesFileExtensions.map({$0.lowercased()})
        }
        set
        {
            if let newValue = newValue {
                _excludesFileExtensions = newValue
            }
        }
    }
    
    func documentsURL() -> URL
    {
        return fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0] as URL
    }
    
    func filesForURL(_ directoryPath: URL)-> [TranslateFiles]
    {
        var files = [TranslateFiles] ()
        var filePaths = [URL] ()
        
        return files
    }
    
    func filesForDirectory(_ directoryPath: URL) -> [TranslateFiles]  {
        var files = [TranslateFiles]()
        var filePaths = [URL]()
        // Get contents from filemanager (local files storing here)
        do
        {
            filePaths = try self.fileManager.contentsOfDirectory(at: directoryPath, includingPropertiesForKeys: [], options: [.skipsHiddenFiles])
        }
        catch {return files}
        // Parse
        for filePath in filePaths
        {
            //process dir
            if filePath.pathExtension == "" {
                continue
            }
            
            let file = TranslateFiles(filePath: filePath)
            if let excludesFileExtensions = excludesFileExtensions, let fileExtensions = file.fileExtension , excludesFileExtensions.contains(fileExtensions) {
                continue
            }
            if let excludesFilepaths = excludesFilepaths , excludesFilepaths.contains(file.filePath) {
                continue
            }
            if file.displayName.isEmpty == false {
                files.append(file)
            }
        }
        // Sort
        files = files.sorted(){$0.displayName < $1.displayName}
        return files
    }
    
}

