//
//  TableViewController.swift
//  DocumentTest
//
//  Copyright © 2019년. All rights reserved.

import UIKit

class SettingsTableViewController: UITableViewController
{
    
    @IBAction func unwindToSetting(_ segue: UIStoryboardSegue) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print ("loaded")
        // Do any additional setup after loading the view, typically from a nib.
        NotificationCenter.default.addObserver(self, selector: #selector(showappinformation), name: Notification.Name("showappinformation"), object: nil)
        
    }
    
    @objc func showappinformation()
    {
        performSegue(withIdentifier: "showappinformation", sender: nil)
    }
    // connecting setting page with the sub-pages. In fact we don't perform any practicable functions
    // like choosing languages in settings
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        switch indexPath.row
        {
        case 0:
            print ("pressed")
            NotificationCenter.default.post(name: Notification.Name("showappinformation"), object: nil)
        case 1:
            print ("try 1")
        case 2:
            print ("try 2")
        default:
            break
        }
        
    }
    
    
}
