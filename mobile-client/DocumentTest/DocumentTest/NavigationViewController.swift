
import UIKit


enum MenuType: Int
{
    case Home
    case Settings
    case Download
    case Upload
    case Trash
    case Logout
    case Profile
}

class NavigationViewController: UITableViewController
{
    
    override func  viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        print (indexPath.row)
        guard let MeType = MenuType(rawValue: indexPath.row) else {return }
        dismiss(animated: true )
        
        switch indexPath.row {
        case 1:
            NotificationCenter.default.post(name: NSNotification.Name("showprofile"), object: nil)
        case 2:
            NotificationCenter.default.post(name: NSNotification.Name("showupload"), object: nil)
        case 3:
            NotificationCenter.default.post(name: NSNotification.Name("showdownload"), object: nil)
        case 4:
            NotificationCenter.default.post(name: NSNotification.Name("showtrash"), object: nil)
        case 5:
            NotificationCenter.default.post(name: NSNotification.Name("showsettings"), object: nil)
        case 6:
            NotificationCenter.default.post(name: NSNotification.Name("showlogout"), object: nil)
        default:
            break
        }
        
    }
}
