import UIKit

class ProfileViewController: BaseViewController {
    
    @IBOutlet weak var UserNameLabel: UILabel!
    @IBOutlet weak var AccountLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        if GlobalToken.count == 0 {
            UserNameLabel.text = "No user"
            AccountLabel.text = "No account"
        }
        else{
            UserNameLabel.text = String(format: "%@ %@", GlobalLoginUser.firstname,GlobalLoginUser.lastname)
            AccountLabel.text = GlobalLoginUser.username
        }
    }
    
}
