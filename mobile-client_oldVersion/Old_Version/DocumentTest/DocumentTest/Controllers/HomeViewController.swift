//
//  ViewController.swift
//  DocumentTest
//
//  Created by perrion huds on 28/01/2019.
//  Copyright © 2019. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var FileTable: UITableView!
    
   
     
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
