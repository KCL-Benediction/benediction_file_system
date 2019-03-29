//
//  MenuViewController.swift
//  DocumentTest
//
//  Created by perrion huds on 29/01/2019.
//  Copyright © 2019. All rights reserved.
// reference link
// https://github.com/gtokman/Slide-In-Transition

import UIKit

enum MenuType: Int
{
    case Home
    case Profile
    case LocalFiles
    case MyAlbums
    case CloudFiles
    case Trash
    case Settings
    case Logout
}

class MenuViewController: UITableViewController
{
    
    @IBOutlet weak var LoginState: UILabel!
    
    override func  viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    // check the login status
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if GlobalToken.count == 0 {
            LoginState.text = "Login"
        }
        else{
            LoginState.text = "Logout"
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        print (indexPath.row)
        guard MenuType(rawValue: indexPath.row) != nil else {return }
        dismiss(animated: true )
        
        switch indexPath.row
        {
        case 1:
            NotificationCenter.default.post(name: NSNotification.Name("showprofile"), object: nil)
        case 2:
            NotificationCenter.default.post(name: NSNotification.Name("showupload"), object: nil)
        case 3:
            NotificationCenter.default.post(name: NSNotification.Name("showPhoto"), object: nil)
        case 4:
            NotificationCenter.default.post(name: NSNotification.Name("showdownload"), object: nil)
        case 5:
            NotificationCenter.default.post(name: NSNotification.Name("showtrash"), object: nil)
        case 6:
            NotificationCenter.default.post(name: NSNotification.Name("showsettings"), object: nil)
        case 7:
            NotificationCenter.default.post(name: NSNotification.Name("showlogout"), object: nil)
        default:
            break
        }
        
    }
}
