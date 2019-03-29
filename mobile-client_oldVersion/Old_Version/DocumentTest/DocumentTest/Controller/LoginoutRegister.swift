import UIKit

class RegisterViewController: UIViewController {
    @IBOutlet weak var LoginNameTF: UITextField!
    @IBOutlet weak var PasswordTF: UITextField!
    
    @IBOutlet weak var LastNameTF: UITextField!
    @IBOutlet weak var FirstNameTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
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
        
        HTTPhandlers.SharedInstnce().UserRegister(username: LoginNameTF.text ?? "", password: PasswordTF.text ?? "", firstname: FirstNameTF.text ?? "", lastname: LastNameTF.text ?? "") { (data, ret) in
            if ret{
                let alert = UIAlertController.init(title: "Tip", message: "Login success!", preferredStyle: UIAlertController.Style.alert)
                let OKAction = UIAlertAction.init(title: "Ok", style: UIAlertAction.Style.default, handler: { (action) in
                    
                })
                alert.addAction(OKAction)
                self.present(alert, animated: true, completion: nil)
                self.dismiss(animated: true, completion: nil)
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
    
    @IBAction func CancelBtnClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
