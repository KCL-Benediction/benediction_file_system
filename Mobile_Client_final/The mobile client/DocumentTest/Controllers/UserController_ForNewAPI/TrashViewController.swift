//
//  TrashViewController.swift
//  DocumentTest
//  Created by pd on 2019/3/16.
//  Copyright © 2019 perrion huds. All rights reserved.
//  Reference link
// https://developer.apple.com/documentation/uikit/uitableview
//https://github.com/onmyway133/Dropdowns/blob/master/Sources/TableController.swift
//https://github.com/marmelroy/FileBrowser/tree/master/FileBrowser
//https://github.com/smileyborg/TableViewCellWithAutoLayoutiOS8

import UIKit

class TrashViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    // TableView
    
    
    let collation = UILocalizedIndexedCollation.current()
    /// Data
    var didSelectFile: ((TranslateFiles) -> ())?
    var files = [TranslateFiles]()
    var initialPath: URL?
    let parser = FileParser.sharedInstance
    let previewManager = PreviewManager()
    var sections: [[TranslateFiles]] = []
    var Edfunction: Bool = false
    
    // Search controller
    var filteredFiles = [TranslateFiles]()
    let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.backgroundColor = UIColor.white
        searchController.dimsBackgroundDuringPresentation = false
        return searchController
    }()
    
    
    // initial class
    convenience init (initialPath: URL) {
        self.init(initialPath: initialPath, showCancelButton: true)
    }
    
    convenience init (initialPath: URL, showCancelButton: Bool)
    {
        self.init(nibName: "Trash", bundle: Bundle(for: TrashViewController.self))
        self.edgesForExtendedLayout = UIRectEdge()
        
        // Set initial path
        self.initialPath = initialPath
        self.title = initialPath.lastPathComponent
        
        // Set search controller delegates
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.delegate = self
        
        if showCancelButton {
            // Add dismiss button
            let dismissButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(TrashViewController.dismiss(button:)))
            self.navigationItem.rightBarButtonItem = dismissButton
        }
    }
    
    deinit
    {
        if #available(iOS 9.0, *)
        {
            searchController.loadViewIfNeeded()
        } else
        {
            searchController.loadView()
        }
    }
    
    func prepareData() {
        // Prepare data
        if let initialPath = initialPath {
            files = parser.filesForDirectory(initialPath)
            indexFiles()
        }
    }
    
    //Loading the View Controller
    override func viewDidLoad() {
        
        prepareData()
        
        // Set search bar
        tableView.tableHeaderView = searchController.searchBar
        
        // Register for 3D touch
        self.registerFor3DTouch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Scroll to hide search bar
        self.tableView.contentOffset = CGPoint(x: 0, y: searchController.searchBar.frame.size.height)
        
        // Make sure navigation bar is visible
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @objc func dismiss(button: UIBarButtonItem = UIBarButtonItem()) {
        self.dismiss(animated: true, completion: nil)
    }
    

  // show data
    func indexFiles() {
        let selector: Selector = #selector(getter: TranslateFiles.displayName)
        sections = Array(repeating: [], count: collation.sectionTitles.count)
        if let sortedObjects = collation.sortedArray(from: files, collationStringSelector: selector) as? [TranslateFiles]{
            for object in sortedObjects {
                let sectionNumber = collation.section(for: object, collationStringSelector: selector)
                sections[sectionNumber].append(object)
            }
        }
    }
    
    // locate the file in table
    func fileForIndexPath(_ indexPath: IndexPath) -> TranslateFiles {
        var file:TranslateFiles
        if searchController.isActive {
            file = filteredFiles[(indexPath as NSIndexPath).row]
        }
        else {
            file = sections[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]
        }
        return file
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredFiles = files.filter({ (file: TranslateFiles) -> Bool in
            return file.displayName.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
    
}

extension TrashViewController: UIViewControllerPreviewingDelegate {
    
    //UIViewControllerPreviewingDelegate
    
    func registerFor3DTouch() {
        if #available(iOS 9.0, *) {
            if self.traitCollection.forceTouchCapability == UIForceTouchCapability.available {
                registerForPreviewing(with: self, sourceView: tableView)
            }
        }
    }
    
    // give a preview to the selected file
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        if #available(iOS 9.0, *) {
            if let indexPath = tableView.indexPathForRow(at: location) {
                let selectedFile = fileForIndexPath(indexPath)
                previewingContext.sourceRect = tableView.rectForRow(at: indexPath)
                if selectedFile.isDirectory == false {
                    return previewManager.previewViewControllerForFile(selectedFile, fromNavigation: false)
                }
            }
        }
        return nil
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        if let previewTransitionViewController = viewControllerToCommit as? PreviewTransitionViewController {
            self.navigationController?.pushViewController(previewTransitionViewController.quickLookPreviewController, animated: true)
        }
        else {
            self.navigationController?.pushViewController(viewControllerToCommit, animated: true)
        }
        
    }
    
}

//implement serach bar
extension TrashViewController: UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating {
    
    //  UISearchControllerDelegate
    func willPresentSearchController(_ searchController: UISearchController) {
        self.tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    // UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterContentForSearchText(searchBar.text!)
    }
    
    // UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

extension TrashViewController: UITableViewDataSource, UITableViewDelegate {
    
    // UITableViewDataSource, UITableViewDelegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if searchController.isActive {
            return 1
        }
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive
        {
            return filteredFiles.count
        }
        return sections[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "FileCell"
        var cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        if let reuseCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            cell = reuseCell
        }
        cell.selectionStyle = .blue
        let selectedFile = fileForIndexPath(indexPath)
        cell.textLabel?.text = selectedFile.displayName
        cell.imageView?.image = selectedFile.type.image()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedFile = fileForIndexPath(indexPath)
        searchController.isActive = false
        if selectedFile.isDirectory {
            let fileListViewController = TrashViewController(initialPath: selectedFile.filePath)
            fileListViewController.didSelectFile = didSelectFile
            self.navigationController?.pushViewController(fileListViewController, animated: true)
        }
        else {
            if let didSelectFile = didSelectFile {
                self.dismiss()
                didSelectFile(selectedFile)
            }
            else {
                let filePreview = previewManager.previewViewControllerForFile(selectedFile, fromNavigation: true)
                self.navigationController?.pushViewController(filePreview, animated: true)
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if searchController.isActive {
            return nil
        }
        if sections[section].count > 0 {
            return collation.sectionTitles[section]
        }
        else {
            return nil
        }
    }
    
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if searchController.isActive {
            return nil
        }
        return collation.sectionIndexTitles
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        if searchController.isActive {
            return 0
        }
        return collation.section(forSectionIndexTitle: index)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCell.EditingStyle.delete) {
            let selectedFile = fileForIndexPath(indexPath)
            selectedFile.delete()
            
            prepareData()
            tableView.reloadSections([indexPath.section], with: UITableView.RowAnimation.automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if tableView.isEditing {
            return []
        }
        else{
            //delete
            let deleteAction:UITableViewRowAction = UITableViewRowAction.init(style: UITableViewRowAction.Style.destructive, title: "Delete") { (action, indexPath) in
                self.DeleteFile(indexPath: indexPath)
            }
            
            //recover
            let recoverAction:UITableViewRowAction = UITableViewRowAction.init(style: UITableViewRowAction.Style.normal, title: "Recover") { (action, indexPath) in
                self.RecoverFile(indexPath: indexPath)
            }
            recoverAction.backgroundColor = UIColor(displayP3Red: 0, green: 0.4, blue: 0, alpha: 1.0)
            
            return  [deleteAction,recoverAction]
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return Edfunction
    }
}

extension TrashViewController
{
    
    func RecoverFile(indexPath:IndexPath) -> Void {
        let file:TranslateFiles = fileForIndexPath(indexPath)
        
        let fileManager = FileManager.default
        // if the file exists locally, we can recover it
        // in fact, recovering a file here is the same as deleting a file from local memory
        if(fileManager.fileExists(atPath: file.filePath.relativePath)){
            let toPath = parser.documentsURL().appendingPathComponent(file.filePath.lastPathComponent)
            try! fileManager.moveItem(atPath: file.filePath.relativePath, toPath: toPath.relativePath)
        }// moving file to another folder
        self.prepareData()
        self.tableView.reloadData()
    }
    
    func DeleteFile(indexPath:IndexPath) -> Void
    {
        let file:TranslateFiles = fileForIndexPath(indexPath)
        
        let fileManager = FileManager.default
        // if the file exists locally, we need to delete it
        if(fileManager.fileExists(atPath: file.filePath.relativePath)){
            try! fileManager.removeItem(atPath: file.filePath.relativePath)
        }
        
        prepareData()
        tableView.reloadData()
    }
}

