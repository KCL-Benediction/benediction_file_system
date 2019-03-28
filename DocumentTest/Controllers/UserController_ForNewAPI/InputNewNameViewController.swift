//
//  InputNewNameViewController.swift
//  DocumentTest
//
//  Created by pd on 2019/3/16.
//  Copyright © 2019 ph. All rights reserved.
//

import UIKit

class InputNewNameViewController: UIViewController
{
    // mark the rename string
    typealias RenameBlock = (_ backName :String) ->()

    @IBOutlet weak var NewNameLabel: UITextField!
    
    var RenameCallBack:RenameBlock!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func CancelBtnClicked(_ sender: UIButton)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func OKBtnClicked(_ sender: UIButton)
    {
        if let _ = RenameCallBack
        {
            if NewNameLabel.text!.count > 0
            {
                RenameCallBack(NewNameLabel.text!)
            }
        }
        self.dismiss(animated: true, completion: nil)
    }


}
