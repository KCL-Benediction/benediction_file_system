//
//  BaseViewController.swift
//  DocumentTest
//
//  Created by perrion huds on 25/02/2019.
//  Copyright © 2019 ph. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let menuButton = UIButton(type: UIButton.ButtonType.system)
        menuButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        menuButton.addTarget(self, action: #selector(openSearch), for:    .touchUpInside)
        menuButton.setImage(UIImage(named: "icon_search"), for: UIControl.State())
        let menuBarButtonItem = UIBarButtonItem(customView: menuButton)
        navigationItem.leftBarButtonItems = [menuBarButtonItem]
    }
    
    @objc func openSearch()
    
    {
        
    }
}

