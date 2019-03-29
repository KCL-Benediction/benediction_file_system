//
//  PreviewTransitionViewController.swift
//  TestSample
//
//  Created by perrion huds on 07/02/2019.
//  Copyright © 2019 perrion huds. All rights reserved.
// https://github.com/marmelroy/FileBrowser/tree/master/FileBrowser

import UIKit
import QuickLook

class PreviewTransitionViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    
    let quickLookPreviewController = QLPreviewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addChild(quickLookPreviewController)
        containerView.addSubview(quickLookPreviewController.view)
        quickLookPreviewController.view.frame = containerView.bounds
        quickLookPreviewController.didMove(toParent: self)
    }
    
}
