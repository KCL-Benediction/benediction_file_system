//
//  AppDelegate.swift
//  DocumentTest
//  Created by ph on 28/01/2019.
//  Copyright © 2019. All rights reserved.

import UIKit
import Starscream
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WebSocketDelegate {
    
    var socket: WebSocket!
    
    func websocketDidConnect(socket: WebSocketClient)
    {
        print("websocket is connected")
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?)
    {
        if let e = error as? WSError
        {
            print("websocket is disconnected: \(e.message)")
        } else if let e = error {
            print("websocket is disconnected: \(e.localizedDescription)")
        } else {
            print("websocket disconnected")
        }
        socket.connect()
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String)
    {
        print("Received text: \(text)")
        print("111")
        NotificationCenter.default.post(name: NSNotification.Name("updatedata"), object: nil)
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data)
    {
        print("Received data: \(data.count)")
         print("222")
    }

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        // Override point for customization after application launch.
        self.populateTableViewWithFiles()
        // push notifications
        /*
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            print("granted: (\(granted)")
        }*/
        var request = URLRequest(url: URL(string: "http://34.73.231.127")!)//prepare the URLRequest
        request.timeoutInterval = 5// set the interval. If it spends more than 5 seconds we know websocket is time out.
        socket = WebSocket(request: request)// set the websocket request
        socket.delegate = self
        socket.connect()// ensure always connecting to socket
        test()//refresh the cloud page
        return true
    }
    
    func test() -> Void {
//        HTTPhandlers.SharedInstnce().UserRegister(username: "test", password: "123", firstname: "te", lastname: "st")
        HTTPhandlers.SharedInstnce().UserLogin(username: "test", password: "123") { (data, ret) in
            if ret
            {
                HTTPhandlers.SharedInstnce().GetAllCloudFile { (data, ret) in
                    
                }
            }
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    fileprivate func populateTableViewWithFiles()
    {
        let defaultsKey = "firstLaunch"
        let userDefaults = UserDefaults.standard
        let fileManager = FileManager.default
        let fileNames = ["roof.jpg","Lana Del Rey-Young and Beautiful.mp3","giphy.gif","How to train your dragon.mp4","rule.docx","numbers.rtf"]
        let documentsUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0] as URL
        // Print("sss:\(documentsUrl)")
        let bundleUrl = Bundle.main.resourceURL
        
        // Copy zip file to an images directory
        let imagesDirectoryURL = documentsUrl.appendingPathComponent("images")
        let zipFileName = "Images.zip"
        let imagesDirectoryPath = imagesDirectoryURL.path
        
        if userDefaults.bool(forKey: defaultsKey) == false {
            userDefaults.set(true, forKey: defaultsKey)
            userDefaults.synchronize()
            
            // Copy images to documents folder
            for file in fileNames {
                if let srcPath = bundleUrl?.appendingPathComponent(file).path {
                    let toPath = documentsUrl.appendingPathComponent(file).path
                    do {
                        try fileManager.copyItem(atPath: srcPath, toPath: toPath)
                    } catch {}
                }
            }
            
            // Copy zip file to an images directory
            do {
                try fileManager.createDirectory(atPath: imagesDirectoryPath, withIntermediateDirectories: false, attributes: nil)
                if let srcPath = bundleUrl?.appendingPathComponent(zipFileName).path {
                    let toPath = imagesDirectoryURL.appendingPathComponent(zipFileName).path
                    do {
                        try fileManager.copyItem(atPath: srcPath, toPath: toPath)
                    } catch {}
                }
            } catch {}
        }
    }


}

