//  FilsViewController.swift
//  TestSample
//  Created by perrion huds on 02/03/2019.
//  Copyright © 2019 ph. All rights reserved.
// refrence link
// https://developer.apple.com/documentation/uikit/uitableview
// https://developer.apple.com/documentation/foundation/filemanager
// https://github.com/onmyway133/Dropdowns/blob/master/Sources/TableController.swift
// https://github.com/marmelroy/FileBrowser/tree/master/FileBrowser
// https://github.com/smileyborg/TableViewCellWithAutoLayoutiOS8
// https://stackoverflow.com/questions/25183718/issue-with-selecting-a-row-in-a-tableview-in-swift
// https://stackoverflow.com/questions/44646186/save-file-in-document-directory-in-swift-3
// https://stackoverflow.com/questions/15017902/delete-specified-file-from-document-directory
// https://stackoverflow.com/questions/6398937/getting-a-list-of-files-in-the-resources-folder-ios

import UIKit
import Foundation

class FilesViewController: UIViewController
{
    
    // TableView
    @IBOutlet weak var tableView: UITableView!
    
    let collation = UILocalizedIndexedCollation.current()
    
    // Data
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
    
    
    // Lifecycle
    convenience init (initialPath: URL) {
        self.init(initialPath: initialPath, showCancelButton: true)
    }
    
    convenience init (initialPath: URL, showCancelButton: Bool)
    {
        self.init(nibName: "NaviMainController", bundle: Bundle(for: FilesViewController.self))
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
            let dismissButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(FilesViewController.dismiss(button:)))
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
    
    //Data
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
    
    func fileForIndexPath(_ indexPath: IndexPath) -> TranslateFiles {
        var file:TranslateFiles
        if searchController.isActive//if it is the result of search bar
        {
            
            file = filteredFiles[(indexPath as NSIndexPath).row]// choose the file with fixed index
        }
        else {
            file = sections[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]// choose a file in table cells
        }
        return file
    }
    
    func filterContentForSearchText(_ searchText: String)
    {
        filteredFiles = files.filter({ (file: TranslateFiles) -> Bool in
            return file.displayName.lowercased().contains(searchText.lowercased())// search a file and ignore upper/lower charactors
        })
        tableView.reloadData()
    }
    
}

extension FilesViewController: UIViewControllerPreviewingDelegate {
    
    //UIViewControllerPreviewingDelegate
    
    func registerFor3DTouch() {
        if #available(iOS 9.0, *) {
            if self.traitCollection.forceTouchCapability == UIForceTouchCapability.available {
                registerForPreviewing(with: self, sourceView: tableView)
            }
        }
    }
    
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

extension FilesViewController: UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating {
    
    // UISearchControllerDelegate
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

extension FilesViewController: UITableViewDataSource, UITableViewDelegate {
    
    //UITableViewDataSource, UITableViewDelegate
    
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
            let fileListViewController = FilesViewController(initialPath: selectedFile.filePath)
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
    
    // three actions for button
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if tableView.isEditing {
            return []
        }
        else{
            //delete
            let deleteAction:UITableViewRowAction = UITableViewRowAction.init(style: UITableViewRowAction.Style.destructive, title: "Delete") { (action, indexPath) in
                self.DeleteFile(indexPath: indexPath)
            }
            
            //rename
            let renameAction:UITableViewRowAction = UITableViewRowAction.init(style: UITableViewRowAction.Style.normal, title: "Rename") { (action, indexPath) in
                self.ChangeFileName(newNamd: "123", indexPath: indexPath)
            }
            renameAction.backgroundColor = UIColor(displayP3Red: 0.4, green: 0, blue: 0.8, alpha: 1.0)
            
            //download
            let downloadAction:UITableViewRowAction = UITableViewRowAction.init(style: UITableViewRowAction.Style.normal, title: "Upload") { (action, indexPath) in
                self.UpdateFile(indexPath: indexPath)
            }
            downloadAction.backgroundColor =  UIColor(displayP3Red: 0, green: 0.4, blue: 0.8, alpha: 1.0)
            
            return  [deleteAction,renameAction,downloadAction]
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return Edfunction
    }
}

extension FilesViewController{
    func UpdateFile(indexPath:IndexPath) -> Void {
        let file:TranslateFiles = fileForIndexPath(indexPath)
        var isUpdate:Bool = false
        var file_id:String = ""
        var version:String = ""
        for tmpf in FilesFromCloud
        {
            if tmpf.file_name == file.filePath.lastPathComponent
            {
                isUpdate = true
                file_id = tmpf.file_id
                version = String(format: "%d", tmpf.version)
                break
            }
        }
        
        if isUpdate {
            //update
            HTTPhandlers.SharedInstnce().UpDateFile(fileID: file_id,fileUrl:file.filePath, type: "update", lastversion: version) { (data, ret) in
                if ret{
                    let alert = UIAlertController.init(title: "Tip", message: "Update File Success!", preferredStyle: UIAlertController.Style.alert)
                    let OKAction = UIAlertAction.init(title: "Ok", style: UIAlertAction.Style.default, handler: { (action) in
                        
                    })
                    alert.addAction(OKAction)
                    self.present(alert, animated: true, completion: nil)
                }
                else{
                    let alert = UIAlertController.init(title: "Update File Fail!", message: String(format: "%@", data as! CVarArg), preferredStyle: UIAlertController.Style.alert)
                    let OKAction = UIAlertAction.init(title: "Ok", style: UIAlertAction.Style.default, handler: { (action) in
                        
                    })
                    alert.addAction(OKAction)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        else{
            // upload and call for HTTPRequest
            HTTPhandlers.SharedInstnce().UploadNewFile(fileUrl: file.filePath, filename: file.filePath.lastPathComponent) { (data, ret) in
                if ret{
                    let alert = UIAlertController.init(title: "Tip", message: "Upload File Success!", preferredStyle: UIAlertController.Style.alert)
                    let OKAction = UIAlertAction.init(title: "Ok", style: UIAlertAction.Style.default, handler: { (action) in
                        
                    })
                    alert.addAction(OKAction)
                    self.present(alert, animated: true, completion: nil)
                }
                else{
                    let alert = UIAlertController.init(title: "Upload File Fail!", message: String(format: "%@", data as! CVarArg), preferredStyle: UIAlertController.Style.alert)
                    let OKAction = UIAlertAction.init(title: "Ok", style: UIAlertAction.Style.default, handler: { (action) in
                        
                    })
                    alert.addAction(OKAction)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    func ChangeFileName(newNamd:String, indexPath:IndexPath) -> Void {
        let file:TranslateFiles = fileForIndexPath(indexPath)
        
        let sb = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let newNameController:InputNewNameViewController = sb.instantiateViewController(withIdentifier: "InputNewNameViewController") as! InputNewNameViewController
        newNameController.hidesBottomBarWhenPushed = true
        newNameController.RenameCallBack = {(backName) in
            let fileManager = FileManager.default
            //delete the file
            if(fileManager.fileExists(atPath: file.filePath.relativePath))
            {
                var toPath = file.filePath.deletingLastPathComponent()
                toPath = toPath.appendingPathComponent(backName)
                toPath = toPath.appendingPathExtension(file.fileExtension!)
                try! fileManager.moveItem(atPath: file.filePath.relativePath, toPath: toPath.relativePath)
            }
            
            self.prepareData()
            self.tableView.reloadData()
        }
        present(newNameController, animated: true, completion: nil)
    }
    // delete functions
    func DeleteFile(indexPath:IndexPath) -> Void {
        let file:TranslateFiles = fileForIndexPath(indexPath)
        
        let fileManager = FileManager.default
        
        // move to trash dir. NOTE that the trash folder MUST be established at first (before performing this delete function) otherwise it will result in error
        if(fileManager.fileExists(atPath: file.filePath.relativePath)){
            var path = parser.documentsURL().appendingPathComponent("Trash", isDirectory: true)
            path = path.appendingPathComponent(file.filePath.lastPathComponent)
            try! fileManager.moveItem(atPath: file.filePath.relativePath, toPath: path.relativePath)
        }
        
        prepareData()
        
        tableView.reloadData()
    }
}

