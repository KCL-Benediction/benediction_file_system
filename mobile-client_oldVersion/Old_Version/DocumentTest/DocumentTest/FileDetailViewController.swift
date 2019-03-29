import UIKit
import WebKit

public class FileDetailViewController: UIViewController {
    
    @IBOutlet weak var wv: WKWebView!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    
    var webSite: URL?
    /*    let address = "https://www.apple.com"
     // self.url = URL(string: temp
     */
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        if let address = webSite
        {
            let webURL = address
            let urlRequest = URLRequest(url: webURL)
            wv.load(urlRequest)
        }
        
        
    }
    
}
//MARK : - Indicator action
extension FileDetailViewController : WKNavigationDelegate
{
    //Two option...
    /* private func webViewDidStartLoad(_ webView: WKWebView){
     self.spinner.isHidden = false
     self.spinner.startAnimating()
     }
     private func webViewDidFinishLoad(_webView: WKWebView){
     spinner.stopAnimating()
     spinner.isHidden = true
     }
     */
    
    //indicator animation start
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        self.spinner.startAnimating()
    }
    //indicator animation stop
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.spinner.stopAnimating()
    }
}

