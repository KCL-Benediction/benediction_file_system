import UIKit

class Login: UIViewController {
    
    @IBOutlet weak var LoginName: UITextField!
    @IBOutlet weak var Password: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func CanceBtnClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    // MARK: - Navigation
    
    @IBAction func OKBtnClicked(_ sender: UIButton) {
        if LoginName.text?.count ?? 0 <= 0 {
            let alert = UIAlertController.init(title: "Warning", message: "Invalid User Name!", preferredStyle: UIAlertController.Style.alert)
            let OKAction = UIAlertAction.init(title: "Ok", style: UIAlertAction.Style.default, handler: { (action) in
                
            })
            alert.addAction(OKAction)
            return
        }
        
        if Password.text?.count ?? 0 <= 0  {
            let alert = UIAlertController.init(title: "Warning", message: "Invalid Password!", preferredStyle: UIAlertController.Style.alert)
            let OKAction = UIAlertAction.init(title: "Ok", style: UIAlertAction.Style.default, handler: { (action) in
                
            })
            alert.addAction(OKAction)
            return
        }
        
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
    
    @IBAction func RegisterBtnClicked(_ sender: UIButton) {
        let sb = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let register:RegisterViewController = sb.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        register.hidesBottomBarWhenPushed = true
        present(register, animated: true, completion: nil)
    }
    
}
