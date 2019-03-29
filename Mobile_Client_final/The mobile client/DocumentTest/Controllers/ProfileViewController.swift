//
//  ProfileViewController.swift
//  DocumentTest
//
//  Created by ph on 13/03/2019.
//  Copyright © 2019 perrion huds. All rights reserved.
//

import UIKit

class ProfileViewController: BaseViewController {

    @IBOutlet weak var UserNameLabel: UILabel!
    @IBOutlet weak var AccountLabel: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        UserNameLabel.isHidden = true
        // Do any additional setup after loading the view.
        if GlobalToken.count == 0//check if the global token is empty or not
        {
            UserNameLabel.text = "No user"
            AccountLabel.text = "No account"
        }
        else
        {
            UserNameLabel.text = String(format: "%@", GlobalLoginUser.firstname, GlobalLoginUser.lastname)
            AccountLabel.text = GlobalLoginUser.username
        }
    }
    
    
    @IBAction func MakeitVisible(_ sender: Any)//show the password or not
    {
        if (UserNameLabel.isHidden == true)
        {UserNameLabel.isHidden = false }
        else
        {UserNameLabel.isHidden = true}
    }
    
    
    // Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
