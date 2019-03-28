//
//  NaviMainController.swift
//  TestSample
//
//  Created by perrion huds on 06/03/2019.
//  Copyright © 2019 ph. All rights reserved.
// https://developer.apple.com/documentation/uikit/uitableview
// https://github.com/onmyway133/Dropdowns/blob/master/Sources/TableController.swift
// https://github.com/marmelroy/FileBrowser/tree/master/FileBrowser
// https://github.com/smileyborg/TableViewCellWithAutoLayoutiOS8

import UIKit
import Foundation
import QuickLook

open class NaviMainController: UINavigationController {
    @IBOutlet weak var tableView: UITableView!
    
    let parser = FileParser.sharedInstance
    
    var fileList: FilesViewController?
    
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
    
    public convenience init()
    {
        let parser = FileParser.sharedInstance
        let path = parser.documentsURL()
        self.init(initialPath: path, allowEditing: true)
    }
    
    // Initialise file browser.
    //
    // - Parameters:
    //   - initialPath: NSURL filepath to containing directory.
    //   - allowEditing: Whether to allow editing.
    //   - showCancelButton: Whether to show the cancel button.
    public convenience init(initialPath: URL? = nil, allowEditing: Bool = false, showCancelButton: Bool = true) {
        
        let validInitialPath = initialPath ?? FileParser.sharedInstance.documentsURL()
        
        let fileListViewController = FilesViewController(initialPath: validInitialPath, showCancelButton: showCancelButton)
        fileListViewController.Edfunction = allowEditing
        self.init(rootViewController: fileListViewController)
        self.view.backgroundColor = UIColor.white
        self.fileList = fileListViewController
    }
    
}
