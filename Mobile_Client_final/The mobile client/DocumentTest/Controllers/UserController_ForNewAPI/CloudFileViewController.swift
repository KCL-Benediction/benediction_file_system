//
//  CloudFileViewController.swift
//  DocumentTest
//  Copyright © 2019 ph. All rights reserved.

import UIKit

class CloudFileViewController: UIViewController {
    var DocUrl:String = ""
    
    // set webview for files in cloud. this is different from the preview in trash/local files
    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        
        // Images can't be opened just via URL
        // Globaltoken + HTTPheader are both needed
        let url = URL(string: DocUrl)
        var request = URLRequest(url: url!)
        request.setValue(String(format:"Bearer %@",GlobalToken), forHTTPHeaderField: "Authorization")
        webView.loadRequest(request)
    }

}
