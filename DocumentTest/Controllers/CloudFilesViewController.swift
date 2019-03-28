//
//  CloudFilesViewController.swift
//  DocumentTest
//
//  Created by perrion huds on 11/02/2019.
//  Copyright © 2019 perrion huds. All rights reserved.
//reference:
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

class CloudFilesViewController: UIViewController
{
    
    // TableView
    @IBOutlet weak var tableView: UITableView!
    
    let collation = UILocalizedIndexedCollation.current()
    
    /// Data
    var didSelectFile: ((FileObj) -> ())?
    var selectedFiles:NSMutableArray = NSMutableArray.init()
    var initialPath: URL?
    let parser = FileParser.sharedInstance
    let previewManager = PreviewManager()
    var sections: [[FileObj]] = []
    var Edfunction: Bool = false
    
    var fileObjs:[FileObj] = []
    var selectBtn:UIBarButtonItem = UIBarButtonItem.init()
    
    // Search controller
    var filteredFiles = [FileObj]()
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
        self.init(nibName: "CloudFilesTable", bundle: Bundle(for: CloudFilesViewController.self))
        self.edgesForExtendedLayout = UIRectEdge()
        
        // Set initial path
        self.initialPath = initialPath
        self.title = "Cloud File"
        
        // Set search controller delegates
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.delegate = self
        
        if showCancelButton {
            // Add dismiss button
            let dismissButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(CloudFilesViewController.dismiss(button:)))
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
    
    @objc func prepareData() {
        // Prepare data
        fileObjs.removeAll()
        HTTPhandlers.SharedInstnce().GetAllCloudFile { (data, ret) in
            if ret {
                let cloudFileData:GetAllFileRet = data as! GetAllFileRet
                self.fileObjs = cloudFileData.files
                FilesFromCloud = cloudFileData.files
                self.indexFiles()
                DispatchQueue.main.async
                    {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    //Loading the View Controller
    override func viewDidLoad() {
        
        prepareData()
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.allowsSelectionDuringEditing = true
        
        // Set search bar
        tableView.tableHeaderView = searchController.searchBar
        NotificationCenter.default.addObserver(self, selector: #selector(prepareData), name: NSNotification.Name("updatedata"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Scroll to hide search bar
        self.tableView.contentOffset = CGPoint(x: 0, y: searchController.searchBar.frame.size.height)
        
        // Make sure navigation bar is visible
        self.navigationController?.isNavigationBarHidden = false
        
        // Add dismiss button
        let dismissButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(CloudFilesViewController.dismiss(button:)))
        self.navigationItem.leftBarButtonItem = dismissButton
        
        let updateBtn = UIBarButtonItem.init(image: UIImage.init(named: "update-arrows"), style: UIBarButtonItem.Style.done, target: self, action: #selector(CloudFilesViewController.updateData(button:)))
        
        selectBtn = UIBarButtonItem.init(title: "Select", style: UIBarButtonItem.Style.done, target: self, action:#selector(CloudFilesViewController.selectClicked(button:)))
        
        self.navigationItem.rightBarButtonItems = [updateBtn,selectBtn]
    }
    
    @objc func dismiss(button: UIBarButtonItem = UIBarButtonItem()) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func selectClicked(button: UIBarButtonItem = UIBarButtonItem()) {
        if tableView.isEditing {
            tableView.setEditing(false, animated: true)
            DownloadSelectedFiles()
            
            selectedFiles.removeAllObjects()
            selectBtn.title = "Select"//button type
        }
        else{
            tableView.setEditing(true, animated: true)
            selectedFiles.removeAllObjects()
            selectBtn.title = "Done"//button type
        }
    }
    
    func DownloadSelectedFiles() -> Void {
        for element in selectedFiles {
            let tmpf :FileObj = element as! FileObj //using loop to iterate each file and download them
            HTTPhandlers.SharedInstnce().DownloadFile(urlStr: tmpf.url, filename: tmpf.file_name, callBack: { (data, ret) in
                let alert = UIAlertController.init(title: "Tip", message: String(format: "Downlod %@ success!", tmpf.file_name), preferredStyle: UIAlertController.Style.alert)
                let OKAction = UIAlertAction.init(title: "Ok", style: UIAlertAction.Style.default, handler: { (action) in
                    
                })// end of HTTP request
                alert.addAction(OKAction)
                self.present(alert, animated: true, completion: nil)
            })
        }
    }
    
    @objc func updateData(button: UIBarButtonItem = UIBarButtonItem()){
        HTTPhandlers.SharedInstnce().GetAllCloudFile { (data, ret) in
            if ret {
                let cloudFileData:GetAllFileRet = data as! GetAllFileRet
                self.fileObjs = cloudFileData.files
                self.indexFiles()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                let alert = UIAlertController.init(title: "Tip", message: "Update from cloud success!", preferredStyle: UIAlertController.Style.alert)
                let OKAction = UIAlertAction.init(title: "Ok", style: UIAlertAction.Style.default, handler: { (action) in
                    
                })
                alert.addAction(OKAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    // Data
    
    func indexFiles() {
        let selector: Selector = #selector(getter: FileObj.file_name)
        sections = Array(repeating: [], count: collation.sectionTitles.count)
        if let sortedObjects = collation.sortedArray(from: fileObjs, collationStringSelector: selector) as? [FileObj]{
            for object in sortedObjects {
                let sectionNumber = collation.section(for: object, collationStringSelector: selector)
                sections[sectionNumber].append(object)
            }
        }
    }
    
    func fileForIndexPath(_ indexPath: IndexPath) -> FileObj
    {
        var file:FileObj
        if searchController.isActive
        {
            
            file = filteredFiles[(indexPath as NSIndexPath).row]
        }
        else
        {
            
              file = sections[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]
        }
        return file
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredFiles = fileObjs.filter({ (file: FileObj) -> Bool in
            return file.file_name.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
}

extension CloudFilesViewController: UIViewControllerPreviewingDelegate {
    
    //UIViewControllerPreviewingDelegate
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        if #available(iOS 9.0, *) {
//            if let indexPath = tableView.indexPathForRow(at: location) {
//                let selectedFile = fileForIndexPath(indexPath)
//                previewingContext.sourceRect = tableView.rectForRow(at: indexPath)
//                return previewManager.previewViewControllerForFile(selectedFile, fromNavigation: false)
//            }
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

extension CloudFilesViewController: UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating {
    
    // UISearchControllerDelegate
    func willPresentSearchController(_ searchController: UISearchController) {
        self.tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    //  UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterContentForSearchText(searchBar.text!)
    }
    
    // UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

extension CloudFilesViewController: UITableViewDataSource, UITableViewDelegate {
    
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
        cell.textLabel?.text = selectedFile.file_name
        cell.imageView?.image = GlobalHelper.SharedInstnce().GetImageByFileType(type: selectedFile.file_name.pathExtension).image()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            let selectedFile = fileForIndexPath(indexPath)
            selectedFiles.remove(selectedFile)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedFile = fileForIndexPath(indexPath)
        searchController.isActive = false
        if tableView.isEditing {
            let selectedFile = fileForIndexPath(indexPath)
            selectedFiles.add(selectedFile)
        }
        else{
            if let didSelectFile = didSelectFile {
                self.dismiss()
                didSelectFile(selectedFile)
            }
            else {
                let sb = UIStoryboard.init(name: "Main", bundle: Bundle.main)
                let fileView:CloudFileViewController = sb.instantiateViewController(withIdentifier: "CloudFileViewController") as! CloudFileViewController
                fileView.DocUrl = selectedFile.url
                self.navigationController?.pushViewController(fileView, animated: true)
            }
            tableView.deselectRow(at: indexPath, animated: true)
        }
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
            prepareData()
            tableView.reloadSections([indexPath.section], with: UITableView.RowAnimation.automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.none;
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if tableView.isEditing// tableView.isEditing is disabled in our project
        {
            return []
        }
        else{
            //delete button action
            let deleteAction:UITableViewRowAction = UITableViewRowAction.init(style: UITableViewRowAction.Style.destructive, title: "Delete") { (action, indexPath) in
                self.DeleteFile(indexPath: indexPath)
            }
            
            //rename button action
            let renameAction:UITableViewRowAction = UITableViewRowAction.init(style: UITableViewRowAction.Style.normal, title: "Rename")
            { (action, indexPath) in
                //let file:FileObj = self.fileForIndexPath(indexPath)
                // rename page is a component of main storyborad and this table view is XIB. Using newNameController class to open new page
                let sb = UIStoryboard.init(name: "Main", bundle: Bundle.main)// opening rename page
                let newNameController:InputNewNameViewController = sb.instantiateViewController(withIdentifier: "InputNewNameViewController") as! InputNewNameViewController
                newNameController.hidesBottomBarWhenPushed = true
                newNameController.RenameCallBack = {(backName) in
                    self.ChangeFileName(newNamd: backName, indexPath: indexPath)
                    }
                self.present(newNameController, animated: true, completion: nil)// return
            }
            renameAction.backgroundColor = UIColor(displayP3Red: 0.4, green: 0, blue: 0.8, alpha: 1.0)
            //download button action
            let downloadAction:UITableViewRowAction = UITableViewRowAction.init(style: UITableViewRowAction.Style.normal, title: "Download") { (action, indexPath) in
                self.DownloadFile(indexPath: indexPath)
            }
            downloadAction.backgroundColor = UIColor(displayP3Red: 0, green: 0.4, blue: 0.8, alpha: 1.0)
            
            return  [deleteAction,renameAction,downloadAction]
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return Edfunction
    }
}

// now we can perform the operations to files inside the tableview
extension CloudFilesViewController{
    func DownloadFile(indexPath:IndexPath) -> Void {
        
        let file:FileObj = fileForIndexPath(indexPath)
        
        let indicater = UIActivityIndicatorView.init()
        indicater.hidesWhenStopped = true;
        indicater.startAnimating()
        
        self.view.addSubview(indicater)
        
        HTTPhandlers.SharedInstnce().DownloadFile(urlStr: file.url, filename:file.file_name) { (data, ret) in
            indicater.stopAnimating()
            if ret{
                let alert = UIAlertController.init(title: "Tip", message: "Download Success!", preferredStyle: UIAlertController.Style.alert)
                let OKAction = UIAlertAction.init(title: "Ok", style: UIAlertAction.Style.default, handler: { (action) in
                    
                })
                alert.addAction(OKAction)
                self.present(alert, animated: true, completion: nil)
            }
            else{
                let alert = UIAlertController.init(title: "Tip", message: "Download Fail!", preferredStyle: UIAlertController.Style.alert)
                let OKAction = UIAlertAction.init(title: "Ok", style: UIAlertAction.Style.default, handler: { (action) in
                    
                })
                alert.addAction(OKAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: fix the bug of operation conflicts
    func ChangeFileName(newNamd:String, indexPath:IndexPath) -> Void
    {
        //let size_1 =  filteredFiles.count
        let size_2 = sections.count
        var flag = true
        if ((indexPath as NSIndexPath).section>=size_2)
        {
            flag = false
        }
        if (flag == true)
        {
            let size_3 = sections[(indexPath as NSIndexPath).section].count
            if ( (indexPath as NSIndexPath).row>=size_3)
        {
            flag = false
        }
        }
        if (flag==false)
        {
            let alert = UIAlertController.init(title: "Tip", message: "This file has been deleted", preferredStyle: UIAlertController.Style.alert)
            let OKAction = UIAlertAction.init(title: "Ok", style: UIAlertAction.Style.default, handler: { (action) in
            })
            alert.addAction(OKAction)
            //self.present(alert, animated: true, completion: nil)
            print ("testing")
            return;
        }
        
        let file:FileObj = fileForIndexPath(indexPath)
        HTTPhandlers.SharedInstnce().ChangeFileName(file_id: file.file_id, newName: (String(format: "%@.%@", newNamd,file.file_name.pathExtension))) { (data, ret) in
            if ret{
                let alert = UIAlertController.init(title: "Tip", message: "Change File Name Success!", preferredStyle: UIAlertController.Style.alert)
                let OKAction = UIAlertAction.init(title: "Ok", style: UIAlertAction.Style.default, handler: { (action) in
                    
                })
                alert.addAction(OKAction)
                self.present(alert, animated: true, completion: nil)
            }
            else{
                let alert = UIAlertController.init(title: "Tip", message: "Change File Name Fail!", preferredStyle: UIAlertController.Style.alert)
                let OKAction = UIAlertAction.init(title: "Ok", style: UIAlertAction.Style.default, handler: { (action) in
                    
                })
                alert.addAction(OKAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func DeleteFile(indexPath:IndexPath) -> Void {
        let file:FileObj = fileForIndexPath(indexPath)
        HTTPhandlers.SharedInstnce().DeleteFile(file_id: file.file_id) { (data, ret) in
            if ret{
                let alert = UIAlertController.init(title: "Tip", message: "Delete File Success!", preferredStyle: UIAlertController.Style.alert)
                let OKAction = UIAlertAction.init(title: "Ok", style: UIAlertAction.Style.default, handler: { (action) in
                    
                })
                alert.addAction(OKAction)
                self.prepareData()
                self.present(alert, animated: true, completion: nil)
            }
            else{
                let alert = UIAlertController.init(title: "Tip", message: "Delete File Fail!", preferredStyle: UIAlertController.Style.alert)
                let OKAction = UIAlertAction.init(title: "Ok", style: UIAlertAction.Style.default, handler: { (action) in
                    
                })
                alert.addAction(OKAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}

extension Collection where Indices.Iterator.Element == Index {
    subscript (exist index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
