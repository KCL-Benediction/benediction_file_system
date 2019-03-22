import UIKit

class LoginOut: UIViewController {
    
    @IBOutlet weak var StateLabel: UILabel!
    @IBOutlet weak var Logbutton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if GlobalToken.count == 0{
            StateLabel.text = "Current State: Logout"
            Logbutton.setTitle("Login", for: UIControl.State.normal)
        }
        else{
            StateLabel.text = "Current State: Login"
            Logbutton.setTitle("Logout", for: UIControl.State.normal)
        }
    }
    
    @IBAction func LogBtnClicked(_ sender: UIButton) {
        if Logbutton.titleLabel?.text == "Login" {
            let sb = UIStoryboard.init(name: "Main", bundle: Bundle.main)
            let login:LoginViewController = sb.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            login.hidesBottomBarWhenPushed = true
            present(login, animated: true, completion: nil)
        }
        else{
            GlobalToken = ""
            StateLabel.text = "Current State: Logout"
            Logbutton.setTitle("Login", for: UIControl.State.normal)
        }
    }
    

    
}
