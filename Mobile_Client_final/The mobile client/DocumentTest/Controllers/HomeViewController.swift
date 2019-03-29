//
//  ViewController.swift
//  DocumentTest
//  Created by perrion huds on 28/01/2019.
//  Copyright © 2019. All rights reserved.
// reference link
// https://stackoverflow.com/questions/32752437/swift-select-all-photos-from-specific-photos-album
// https://developer.apple.com/documentation/uikit/uiimagepickercontroller
// https://github.com/gtokman/Slide-In-Transition
// https://developer.apple.com/documentation/foundation/nsnotificationcenter

import UIKit

// public controller which will be called for opening the new page
// they have to be public variables. If we use them as private ones, conflicts will appear

//public
public let file3 = TrashNaviViewController()

class HomeViewController: UIViewController, UINavigationControllerDelegate,UIImagePickerControllerDelegate
{
    @IBOutlet weak var FileTable: UITableView!
    
    @IBAction func unwindToMain(_ segue: UIStoryboardSegue) {
        
    }
     
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //let L1=file1 //this step is necessary. cause our tableviews are XIB and we use convenience init() to create new folders.
        //let L2=file2 //Those L1, L2, L3 help us to create the initial class. Without them, some operations liking downloading from server to local directory, or deleting a file from local files directory to local traash directory will have conflicts
        let L3=file3 //We use each of those file with table menu notification in the following section
        
        //Notification for linking the navigation menu and the main page
        NotificationCenter.default.addObserver(self, selector: #selector(showprofile), name: NSNotification.Name("showprofile"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showupload), name: NSNotification.Name("showupload"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showdownload), name: NSNotification.Name("showdownload"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showtrash), name: NSNotification.Name("showtrash"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showsettings), name: NSNotification.Name("showsettings"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showlogout), name: NSNotification.Name("showlogout"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showPhoto), name: NSNotification.Name("showPhoto"), object: nil)
        
//        Checklogin()
    }
    
    //check the login status
    func Checklogin() -> Void {
        if GlobalToken.count == 0{
            let sb = UIStoryboard.init(name: "Main", bundle: Bundle.main)
            let login:LoginViewController = sb.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            login.hidesBottomBarWhenPushed = true
            present(login, animated: true, completion: nil)
        }
    }
    
    // connecting each function with the navigation menu
    @objc func showPhoto()
    {
        imagePickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
        // open the photo
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc func showcloudfile()
    {
        performSegue(withIdentifier: "showprofile", sender: nil)
    }
    
    @objc func showprofile ()
    {
        performSegue(withIdentifier: "showprofile", sender: nil)
    }
    
    @objc func showupload ()
    {
        let file1 = NaviMainController()
        present(file1, animated: true, completion: nil)
    }
    
    @objc func showdownload ()
    {
        let file2 = CloudFileNaviViewController()
        present(file2, animated: true, completion: nil)
    }
    
    @objc func showtrash ()
    {
        present(file3, animated: true, completion: nil)
    }
    
    @objc func showsettings ()
    {
        performSegue(withIdentifier: "showsettings", sender: nil)
    }
    
    @objc func showlogout()
    {
         performSegue(withIdentifier: "showlogout", sender: nil)
    }
    
     let slidemenu=SettingSlideInMenu()
     let transition = SlideInTransition ()
    
    @IBAction func TapMenu(_ sender: UIBarButtonItem)
    {
        guard let MenuViewController = storyboard?.instantiateViewController(withIdentifier: "MenuViewController")
            else
        {return}
        MenuViewController.modalPresentationStyle = .overCurrentContext
        MenuViewController.transitioningDelegate = self
        present(MenuViewController, animated: true)
        
    }
}
//showing the navigation menu
extension HomeViewController: UIViewControllerTransitioningDelegate
{
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.presents = true
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.presents = false
        return transition
    }
}

//Selecting photos and return results
extension HomeViewController {
    // Open the interface of selecting a photo
    var imagePickerController: UIImagePickerController {
        get {
            let imagePicket = UIImagePickerController()
            imagePicket.delegate = self
            imagePicket.sourceType = .photoLibrary
            return imagePicket
        }// return an interface
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute:
            {
                self.dismiss(animated: true, completion: nil)
        })
        //  picker.dismiss(animated: true, completion: nil)
        let infoo:NSDictionary? = NSDictionary(dictionary: info)
        let imageUrl:URL = infoo!.object(forKey: UIImagePickerController.InfoKey.imageURL) as! URL
        // uploading the file and call for HTTP function
        HTTPhandlers.SharedInstnce().UploadNewFile(fileUrl: imageUrl, filename: imageUrl.lastPathComponent) { (data, ret) in
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
    
    // Return main page when clicking on "Cancle"
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute:
            {
                self.dismiss(animated: true, completion: nil)
        })
        picker.dismiss(animated: true, completion: nil)
    }
}

