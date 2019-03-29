import UIKit

class CloudFileViewController: UIViewController {
    var DocUrl:String = ""
    
    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        if DocUrl == "" {
            let alertController = UIAlertController(title: "Warning",
                                                    message: "No report", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: {
                action in
                self.navigationController?.popViewController(animated: true)
            })
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        let url = URL(string: DocUrl)
        var request = URLRequest(url: url!)
        request.setValue(String(format:"Bearer %@",GlobalToken), forHTTPHeaderField: "Authorization")
        webView.loadRequest(request)
    }
    
    

    
}
