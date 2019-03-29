//
//  TrashNaviViewController.swift
//  DocumentTest
//
//  Created by ph on 2019/3/15.
//  Copyright © 2019 ph. All rights reserved.
// https://developer.apple.com/documentation/uikit/uitableview
//https://github.com/onmyway133/Dropdowns/blob/master/Sources/TableController.swift
//https://github.com/marmelroy/FileBrowser/tree/master/FileBrowser
//https://github.com/smileyborg/TableViewCellWithAutoLayoutiOS8

import UIKit

public class TrashNaviViewController: UINavigationController {

    @IBOutlet weak var tableView: UITableView!
    
    
    let parser = FileParser.sharedInstance
    
    var fileList: TrashViewController?
    
    // File types to exclude from the file browser.
    open var excludesFileExtensions: [String]?
        {
        didSet
        {
            parser.excludesFileExtensions = excludesFileExtensions
        }
    }
    
    // File paths to exclude from the file browser.
    open var excludesFilepaths: [URL]? {
        didSet {
            parser.excludesFilepaths = excludesFilepaths
        }
    }
    
    // Override default preview and actionsheet behaviour in favour of custom file handling.
    open var didSelectFile: ((TranslateFiles) -> ())? {
        didSet {
            fileList?.didSelectFile = didSelectFile
        }
    }
    
    //create the folder for trash
    public convenience init()
    {
        let parser = FileParser.sharedInstance
        let path = parser.documentsURL().appendingPathComponent("Trash", isDirectory: true)
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: path.relativePath) {
            do{
                try fileManager.createDirectory(atPath: path.relativePath, withIntermediateDirectories: true, attributes: nil)
                print("Succes to create folder")
            }
            catch{
                print("Error to create folder")
            }
        }
        self.init(initialPath: path, allowEditing: true)
    }
    
    // Initialise file browser, using NSURL filepath to containing directory.
    public convenience init(initialPath: URL? = nil, allowEditing: Bool = false, showCancelButton: Bool = true) {
        
        let validInitialPath = initialPath ?? FileParser.sharedInstance.documentsURL()
        
        let fileListViewController = TrashViewController(initialPath: validInitialPath, showCancelButton: showCancelButton)
        fileListViewController.Edfunction = allowEditing
        self.init(rootViewController: fileListViewController)
        self.view.backgroundColor = UIColor.white
        self.fileList = fileListViewController
    }
    
}
