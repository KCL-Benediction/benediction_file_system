//
//  LoginViewController.swift
//  DocumentTest
//
//  Created by ph on 2019/3/18.
//  Copyright © 2019 ph. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var LoginNameTF: UITextField!
    @IBOutlet weak var PasswordTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    // return the previous page
     @IBAction func CanceBtnClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
     }
    
    // check the status
     @IBAction func OKBtnClicked(_ sender: UIButton) {
        if LoginNameTF.text?.count ?? 0 <= 0 {
            let alert = UIAlertController.init(title: "Warning", message: "Invalid User Name!", preferredStyle: UIAlertController.Style.alert)
            let OKAction = UIAlertAction.init(title: "Ok", style: UIAlertAction.Style.default, handler: { (action) in
                
            })
            alert.addAction(OKAction)
            return
        }
        
        //check the input text status
        if PasswordTF.text?.count ?? 0 <= 0  {
            let alert = UIAlertController.init(title: "Warning", message: "Invalid Password!", preferredStyle: UIAlertController.Style.alert)
            let OKAction = UIAlertAction.init(title: "Ok", style: UIAlertAction.Style.default, handler: { (action) in
                
            })
            alert.addAction(OKAction)
            return
        }
        
        // call for HTTP request.
        HTTPhandlers.SharedInstnce().UserLogin(username: LoginNameTF.text ?? "", password: PasswordTF.text ?? "") { (data, ret) in
            if ret{
                let alert = UIAlertController.init(title: "Tip", message: "Login success!", preferredStyle: UIAlertController.Style.alert)
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil)
                }
                DispatchQueue.main.asyncAfter(deadline: .now()+1.5, execute:
                    {
                        alert.dismiss(animated: true, completion: nil)
                        self.dismiss(animated: true, completion: nil)
                })
            }
            else{
                let alert = UIAlertController.init(title: "Tip", message: "Login fail!", preferredStyle: UIAlertController.Style.alert)
                let OKAction = UIAlertAction.init(title: "Ok", style: UIAlertAction.Style.default, handler: { (action) in
                    
                })
                alert.addAction(OKAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
     }
    
    // Link tu register button for users to create a new account
    @IBAction func RegisterBtnClicked(_ sender: UIButton) {
        let sb = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let register:RegisterViewController = sb.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        register.hidesBottomBarWhenPushed = true
        present(register, animated: true, completion: nil)//go to register page
    }

}
