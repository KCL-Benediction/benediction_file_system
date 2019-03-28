//
//  TableServerFilesViewController.swift
//  DocumentTest
//
//  Created by perrion huds on 14/02/2019.
//  Copyright © 2019 perrion huds. All rights reserved.
// https://developer.apple.com/documentation/uikit/uitableview
//https://github.com/onmyway133/Dropdowns/blob/master/Sources/TableController.swift
//https://github.com/marmelroy/FileBrowser/tree/master/FileBrowser
//https://github.com/smileyborg/TableViewCellWithAutoLayoutiOS8

import UIKit
import Foundation
import QuickLook

open class TableServerFilesViewController: UINavigationController {

    @IBOutlet weak var tableView: UITableView!
    
    let parser = FileParser.sharedInstance
    
    var Serverfilelist: CloudFilesViewController?

        // Do any additional setup after loading the view.
    open var cloudfilesExtensions: [String]?
    {
        didSet
        {
            parser.excludesFileExtensions =  cloudfilesExtensions
        }
    }
    
    open var cloudFilepaths: [URL]?
    {
        didSet
        {
            parser.excludesFilepaths = cloudFilepaths
        }
    }
    
    open var didweSelectFile: ((FileObj)->())?
    {
        didSet
        {
            Serverfilelist?.didSelectFile = didweSelectFile
        }
    }
    
    public convenience init()
    {
        let parser = FileParser.sharedInstance
        let path = parser.documentsURL()//this URL shouled contain Web URLs
        self.init(initialPath: path, allowEditing: true)
    }
    
    public convenience init(initialPath: URL? = nil, allowEditing: Bool = false, showCancelButton: Bool = true) {
        
        let validInitialPath = initialPath ?? FileParser.sharedInstance.documentsURL()
        
        let fileListViewController = CloudFilesViewController(initialPath: validInitialPath, showCancelButton: showCancelButton)
        
        fileListViewController.Edfunction = allowEditing
        self.init(rootViewController: fileListViewController)
        self.view.backgroundColor = UIColor.white
        self.Serverfilelist = fileListViewController
    }

}
