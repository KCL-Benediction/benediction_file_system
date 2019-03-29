//
//  PreviewManager.swift
//  TestSample
//
//  Created by perrion huds on 07/03/2019.
//  Copyright © 2019 perrion huds. All rights reserved.

import Foundation
import QuickLook
import WebKit

class PreviewManager: NSObject, QLPreviewControllerDataSource {
    
    var filePath: URL?
    
    func previewViewControllerForFile(_ file:TranslateFiles, fromNavigation: Bool) -> UIViewController {
        
        if file.type == .PLIST || file.type == .JSON{
            let webviewPreviewViewContoller = WebviewPreviewViewContoller(nibName: "WebviewPreviewViewContoller", bundle: Bundle(for: WebviewPreviewViewContoller.self))
            webviewPreviewViewContoller.file = file
            return webviewPreviewViewContoller
        }
        else {
            let previewTransitionViewController = PreviewTransitionViewController(nibName: "PreviewTransitionViewController", bundle: Bundle(for: PreviewTransitionViewController.self))
            previewTransitionViewController.quickLookPreviewController.dataSource = self
            
            self.filePath = file.filePath as URL
            if fromNavigation == true {
                return previewTransitionViewController.quickLookPreviewController
            }
            return previewTransitionViewController
        }
    }
    
    func previewViewControllerForFile(_ file:FileObj, fromNavigation: Bool) -> UIViewController {
        let webviewPreviewViewContoller = WebviewPreviewViewContoller(nibName: "WebviewPreviewViewContoller", bundle: Bundle(for: WebviewPreviewViewContoller.self))
        webviewPreviewViewContoller.newFile = file
        return webviewPreviewViewContoller
    }
    
    
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        let item = PreviewItem()
        if let filePath = filePath {
            item.filePath = filePath
        }
        return item
    }
    
}

class PreviewItem: NSObject, QLPreviewItem
{
    
    var filePath: URL?
    public var previewItemURL: URL? {
        if let filePath = filePath {
            return filePath
        }
        return nil
    }
    
}

