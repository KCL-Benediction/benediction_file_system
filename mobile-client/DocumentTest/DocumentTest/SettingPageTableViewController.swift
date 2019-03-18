// This Code for setting menu in the navigation bar

import UIKit

class SettingPageTableViewController: UITableViewController
{
    
    // page seque to back setting page
    @IBAction func unwindToSetting(_ segue: UIStoryboardSegue) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print ("loaded")
        // Do any additional setup after loading the view, typically from a nib.
        NotificationCenter.default.addObserver(self, selector: #selector(showappinformation), name: Notification.Name("showappinformation"), object: nil)
        
    }
    
    @objc func showappinformation()
    {
        performSegue(withIdentifier: "showappinformation", sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        switch indexPath.row
        {
        case 0:
            print ("pressed")
            NotificationCenter.default.post(name: Notification.Name("showappinformation"), object: nil)
        case 1:
            print ("try 1")
        case 2:
            print ("try 2")
        default:
            break
        }
        
    }
    
    
}