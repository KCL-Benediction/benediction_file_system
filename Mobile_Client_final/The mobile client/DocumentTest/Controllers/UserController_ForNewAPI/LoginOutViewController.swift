//
//  LoginOutViewController.swift
//  DocumentTest
//
//  Created by pd on 2019/3/17.
//  Copyright © 2019 ph. All rights reserved.
//

import UIKit

class LoginOutViewController: UIViewController {

    @IBOutlet weak var StateLabel: UILabel!
    @IBOutlet weak var Logbtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // global token save the value returned by server after a user logged in successfully.
    // check if the length of global token is equal to zero, then the current status should be logout
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if GlobalToken.count == 0{
            StateLabel.text = "Current State: Logout"
            Logbtn.setTitle("Login", for: UIControl.State.normal)
        }
        else{
            StateLabel.text = "Current State: Login"
            Logbtn.setTitle("Logout", for: UIControl.State.normal)
        }
    }
    
    // open the login page
    @IBAction func LogBtnClicked(_ sender: UIButton) {
        if Logbtn.titleLabel?.text == "Login" {
            let sb = UIStoryboard.init(name: "Main", bundle: Bundle.main)
            let login:LoginViewController = sb.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            login.hidesBottomBarWhenPushed = true
            present(login, animated: true, completion: nil)
        }
        else{
            GlobalToken = ""
            StateLabel.text = "Current State: Logout"
            Logbtn.setTitle("Login", for: UIControl.State.normal)
        }
    }


}
