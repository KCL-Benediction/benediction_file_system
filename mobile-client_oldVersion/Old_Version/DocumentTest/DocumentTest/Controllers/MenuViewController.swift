//
//  MenuViewController.swift
//  DocumentTest
//
//  Created by perrion huds on 29/01/2019.
//  Copyright © 2019. All rights reserved.
//

import UIKit

enum MenuType: Int
{
    case Home
    case Settings
    case Edit
    case Trash
}

class MenuViewController: UITableViewController
{
    
    override func  viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        guard let MeType = MenuType(rawValue: indexPath.row) else {return }
        dismiss(animated: true )
        
    }
}
