//
//  RegisterViewController.swift
//  DocumentTest
//
//  Created by ph on 2019/3/17.
//  Copyright © 2019 ph. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController
{
    @IBOutlet weak var LoginNameTF: UITextField! // login name input text
    @IBOutlet weak var PasswordTF: UITextField! // password input text
    @IBOutlet weak var LastNameTF: UITextField! // lastname input text
    @IBOutlet weak var FirstNameTF: UITextField! // firstname input text
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // Register a new account
    @IBAction func RegisterBtnClicked(_ sender: UIButton) {
        if LoginNameTF.text?.count ?? 0 <= 0 {
            let alert = UIAlertController.init(title: "Warning", message: "Invalid User Name!", preferredStyle: UIAlertController.Style.alert)
            let OKAction = UIAlertAction.init(title: "Ok", style: UIAlertAction.Style.default, handler: { (action) in
                
            })
            alert.addAction(OKAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if PasswordTF.text?.count ?? 0 <= 0  {
            let alert = UIAlertController.init(title: "Warning", message: "Invalid Password!", preferredStyle: UIAlertController.Style.alert)
            let OKAction = UIAlertAction.init(title: "Ok", style: UIAlertAction.Style.default, handler: { (action) in
                
            })
            alert.addAction(OKAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if LastNameTF.text?.count ?? 0 <= 0 {
            let alert = UIAlertController.init(title: "Warning", message: "Invalid Last Name!", preferredStyle: UIAlertController.Style.alert)
            let OKAction = UIAlertAction.init(title: "Ok", style: UIAlertAction.Style.default, handler: { (action) in
                
            })
            alert.addAction(OKAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if FirstNameTF.text?.count ?? 0 <= 0  {
            let alert = UIAlertController.init(title: "Warning", message: "Invalid First Name!", preferredStyle: UIAlertController.Style.alert)
            let OKAction = UIAlertAction.init(title: "Ok", style: UIAlertAction.Style.default, handler: { (action) in
                
            })
            alert.addAction(OKAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        // Call for HTTP request and return the messages of status
        HTTPhandlers.SharedInstnce().UserRegister(username: LoginNameTF.text ?? "", password: PasswordTF.text ?? "", firstname: FirstNameTF.text ?? "", lastname: LastNameTF.text ?? "") { (data, ret) in
            if ret{
                let alert = UIAlertController.init(title: "Tip", message: "Regitser success!", preferredStyle: UIAlertController.Style.alert)
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil)
                }
                DispatchQueue.main.asyncAfter(deadline: .now()+1.5, execute: {
                    alert.dismiss(animated: true, completion: nil)
                })
            }
            else{
                let alert = UIAlertController.init(title: "Tip", message: "Regitser fail!", preferredStyle: UIAlertController.Style.alert)
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil)
                }
                DispatchQueue.main.asyncAfter(deadline: .now()+1.5, execute: {
                    alert.dismiss(animated: true, completion: nil)
                })
            }
        }
    }
    
    @IBAction func CancelBtnClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }


}
