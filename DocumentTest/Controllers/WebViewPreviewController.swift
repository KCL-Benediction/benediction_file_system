//
//  WebViewPreviewController.swift
//  TestSample
//
//  Created by perrion huds on 07/03/2019.
//  Copyright © 2019 perrion huds. All rights reserved.
// https://github.com/marmelroy/FileBrowser/tree/master/FileBrowser

import UIKit
import WebKit

// Webview for rendering items QuickLook will struggle with.
class WebviewPreviewViewContoller: UIViewController
{
    
    var webView = WKWebView()
    
    var file: TranslateFiles? {
        didSet {
            self.title = file?.displayName
            self.processForDisplay()
        }
    }
    
    var newFile: FileObj? {
        didSet {
            self.title = newFile?.file_name
            file = TranslateFiles.init(filePath: URL.init(string: newFile?.url ?? "") as! URL)
            self.processForDisplay()
        }
    }
    
    //Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(webView)
        
        // Add share button
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(WebviewPreviewViewContoller.shareFile(_:)))
        self.navigationItem.rightBarButtonItem = shareButton
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        webView.frame = self.view.bounds
    }
    
    //Share
    
    @objc func shareFile(_ sender: UIBarButtonItem) {
        guard let file = file else {
            return
        }
        let activityViewController = UIActivityViewController(activityItems: [file.filePath], applicationActivities: nil)
        
        if UIDevice.current.userInterfaceIdiom == .pad &&
            activityViewController.responds(to: #selector(getter: popoverPresentationController)) {
            activityViewController.popoverPresentationController?.barButtonItem = sender
        }
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    //Processing
    
    func processForDisplay() {
        guard let file = file, let data = try? Data(contentsOf: file.filePath as URL) else {
            return
        }
        var rawString: String?
        
        // Prepare plist for display
        if file.type == .PLIST {
            do {
                if let plistDescription = try (PropertyListSerialization.propertyList(from: data, options: [], format: nil) as AnyObject).description {
                    rawString = plistDescription
                }
            } catch {}
        }
            
            // Prepare json file for display
        else if file.type == .JSON {
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                if JSONSerialization.isValidJSONObject(jsonObject) {
                    let prettyJSON = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
                    var jsonString = String(data: prettyJSON, encoding: String.Encoding.utf8)
                    // Unescape forward slashes
                    jsonString = jsonString?.replacingOccurrences(of: "\\/", with: "/")
                    rawString = jsonString
                }
            } catch {}
        }
        else{
            //need todo
            return
        }
        
        // Default prepare for display
        if rawString == nil {
            rawString = String(data: data, encoding: String.Encoding.utf8)
        }
        
        // Convert and display string
        if let convertedString = convertSpecialCharacters(rawString) {
            let htmlString = "<html><head><meta name='viewport' content='initial-scale=1.0, user-scalable=no'></head><body><pre>\(convertedString)</pre></body></html>"
            webView.loadHTMLString(htmlString, baseURL: nil)
        }
    }
    
    
    // Make sure we convert HTML special characters
    func convertSpecialCharacters(_ string: String?) -> String? {
        guard let string = string else {
            return nil
        }
        var newString = string
        let char_dictionary = [
            "&amp;": "&",
            "&lt;": "<",
            "&gt;": ">",
            "&quot;": "\"",
            "&apos;": "'"
        ];
        for (escaped_char, unescaped_char) in char_dictionary {
            newString = newString.replacingOccurrences(of: escaped_char, with: unescaped_char, options: NSString.CompareOptions.regularExpression, range: nil)
        }
        return newString
    }
}

