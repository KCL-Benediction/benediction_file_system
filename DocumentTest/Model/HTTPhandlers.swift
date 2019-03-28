//  HTTPhandlers.swift
//  DocumentTest
//  Created by perrion huds on 11/03/2019.
//  Copyright © 2019 ph. All rights reserved.
// Reference URL
// https://mobikul.com/download-data-url-header-body-parameter-swift-4/
// https://github.com/daltoniam/SwiftHTTP
// https://stackoverflow.com/questions/24016142/how-to-make-an-http-request-in-swift
// https://stackoverflow.com/questions/27540068/download-file-from-server-using-swift

import UIKit
import SwiftHTTP

//login struct
// we have to define a struct to decode the JSON message sent back from server
public struct LoginRet: Decodable
{
    var result: Bool
    var token: String
    var user : Login_User
}

public struct Login_User :Decodable
{
    var username:String
    var firstname:String
    var lastname:String
}

//getallfile
public class GetAllFileRet:Decodable{
    var result:Bool
    var files:[FileObj]
}

// all the file information
@objc public class FileObj:NSObject,Decodable
{
    @objc public var file_name:String
    var version:NSInteger
    var locked:Bool
    var file_id:String
    var url:String
}

//update
public class UploadRet:Decodable{
    var result:Bool
    var reason:String
}

//upload
public class UploadNewRet:Decodable
{
    var result:Bool
    var file:UploadFileInfo
}

public class UploadFileInfo:Decodable
{
    @objc public var file_name:String
    var version:NSInteger
    var locked:Bool
    var file_id:String
    var download:String
}

//changeFileNAME
public class ChangeName:Decodable{
    var result:Bool
}

//deleteFile
public class DeleteFileRet:Decodable{
    var result:Bool
}


public extension UIWindow// specify UIView controller for HTTP handler
{
    
    public func topMostWindowController()->UIViewController?
    {
        
        var topController = rootViewController
        
        while let presentedController = topController?.presentedViewController
        {
            topController = presentedController
        }
        
        return topController
    }
    
    public func currentViewController()->UIViewController?
    {
        
        var currentViewController = topMostWindowController()
        if currentViewController is UITabBarController
        {
            currentViewController = (currentViewController as! UITabBarController).selectedViewController
        }
        while currentViewController != nil && currentViewController is UINavigationController && (currentViewController as! UINavigationController).topViewController != nil
        {
            currentViewController = (currentViewController as! UINavigationController).topViewController
        }
        
        return currentViewController
    }
}

let decoder = JSONDecoder()
var GlobalToken:String = String.init()
var GlobalLoginUser:Login_User = Login_User.init(username: "", firstname: "", lastname: "")
var FilesFromCloud:[FileObj] = []

class HTTPhandlers: NSObject {
    
    static let instance: HTTPhandlers = HTTPhandlers()
    
    class func SharedInstnce() -> HTTPhandlers {
        return instance
    }
    
    func CheckLogin() -> Bool {
        if GlobalToken.count <= 0
        {
            let alert = UIAlertController.init(title: "Warning", message: "Please login first!", preferredStyle: UIAlertController.Style.alert)
            let OKAction = UIAlertAction.init(title: "Ok", style: UIAlertAction.Style.default, handler: { (action) in
                
            })
            alert.addAction(OKAction)
            UIApplication.shared.keyWindow?.currentViewController()?.present(alert, animated: true, completion: nil)
            return false
        }
        else{
            return true
        }
    }
    
    // ===UserRegister===
    func UserRegister(username:String,password:String,firstname:String, lastname:String, callBack:@escaping (Any,Bool) ->()){
        HTTP.POST("http://34.73.231.127/users/register",
                  parameters: ["username": username,
                               "password": password,
                               "firstname":firstname,
                               "lastname":lastname])
        {
            Response in
            print("respons: \(Response.description)")
            
            if let error = Response.error {
                callBack(error,true)
                print("got an error: \(error)")
                return
            }
            do {
                let resp = try decoder.decode(LoginRet.self, from: Response.data)
                callBack(resp as LoginRet,resp.result)
                print("completed: \(resp.result)")
            } catch let error {
                callBack(error,true)
                print("decode json error: \(error)")
            }
        }
    }
    
    // ===UserLogin===
    func UserLogin(username:String, password:String,callBack:@escaping (Any,Bool) ->()) -> Void {
        HTTP.POST("http://34.73.231.127/users/login",
                  parameters: ["username": username,
                               "password": password])
        {
            Response in
            print("respons: \(Response.description)")
            
            if let error = Response.error {
                callBack(error,false)
                print("got an error: \(error)")
                return
            }
            do {
                let resp = try decoder.decode(LoginRet.self, from: Response.data)
                GlobalToken = resp.token
                GlobalLoginUser = resp.user
                callBack(resp as LoginRet,true)
                //get all file first
                self.GetAllCloudFile(callBack: { (data, ret) in
                    
                })
                
                print("completed: \(resp.result)")
            } catch let error {
                callBack(error.localizedDescription,false)
                print("decode json error: \(error)")
            }
        }
    }
    
    // ===GetAllCloudFile===
    func GetAllCloudFile(callBack:@escaping (Any,Bool) ->()) ->Void
    {
        if !CheckLogin()
        {
            return
        }
        
        HTTP.GET("http://34.73.231.127/get_all_file_details",headers:["Authorization":String(format:"Bearer %@",GlobalToken)])
        {
            Response in
            print("respons: \(Response.description)")
            
            if let error = Response.error {
                print("got an error: \(error)")
                callBack(error,false)
                return
            }
            do {
                let resp = try decoder.decode(GetAllFileRet.self, from: Response.data)
                print("completed: \(resp.result)")
                
                if resp.result {
                    FilesFromCloud.removeAll()
                    FilesFromCloud = resp.files
                }
                
                callBack(resp,true)
            } catch let error {
                callBack(error.localizedDescription,false)
                print("decode json error: \(error)")
            }
        }
    }
    
    // update a file in server
    func UpDateFile(fileID:String, fileUrl:URL, type:String,lastversion:String, callBack:@escaping (Any,Bool) ->()) -> Void
    {
        if !CheckLogin()
        {
            return
        }
        
        HTTP.POST("http://34.73.231.127/upload_a_file", parameters: ["type": "update","file_id":fileID,"last_version":lastversion,"file": Upload(fileUrl: fileUrl)], headers:["Authorization":String(format:"Bearer %@",GlobalToken)]) {
            Response in
            //do things...
            
            print("respons: \(Response.description)")
            
            if let error = Response.error {
                print("got an error: \(error)")
                callBack(error,false)
                return
            }
            do {
                let resp = try decoder.decode(UploadRet.self, from: Response.data)
                print("completed: \(resp.result)")
                callBack(resp.reason,resp.result)
            } catch let error {
                callBack(error.localizedDescription,false)
                print("decode json error: \(error)")
            }
        }
    }
    
    // upload a new file to server
    func UploadNewFile(fileUrl:URL, filename:String, callBack:@escaping (Any,Bool) ->()) -> Void {
        if !CheckLogin() {
            return
        }
        
        HTTP.POST("http://34.73.231.127/upload_a_file", parameters: ["type": "new", "file_name":filename,"file": Upload(fileUrl: fileUrl)], headers:["Authorization":String(format:"Bearer %@",GlobalToken)]) {
            Response in
            //do things...
            
            print("respons: \(Response.description)")
            
            if let error = Response.error {
                print("got an error: \(error)")
                callBack(error.localizedDescription,false)
                return
            }
            do {
                let resp = try decoder.decode(UploadNewRet.self, from: Response.data)
                print("completed: \(resp.result)")
                callBack(resp,resp.result)
            } catch let error {
                callBack(error.localizedDescription,false)
                print("decode json error: \(error)")
            }
        }
    }
    
    // ===DownloadFile===
    func DownloadFile(urlStr:String,filename:String, callBack:@escaping (Any,Bool) ->()) ->Void{
        if !CheckLogin() {
            return
        }
        let url = URL(string: urlStr)
        // can't download directly, there must be a HERDER
        var request = URLRequest(url: url!)
        let para = String(format:"Bearer %@",GlobalToken)
        request.addValue(para, forHTTPHeaderField: "Authorization")
         
        
        let session = URLSession.shared
        
        let downloadTask = session.downloadTask(with: request,
                                                completionHandler: { (location:URL?, response:URLResponse?, error:Error?)
                                                    -> Void in
                                                    
                                                    if error != nil{
                                                        print(error as Any)
                                                        callBack(error as Any,false)
                                                    }else{
                                                        //print("temp location:\(location)")
                                                        let locationPath = location!.path
                                                        let documnets:String = NSHomeDirectory() + "/Documents/" + filename
                                                        let fileManager = FileManager.default
                                                        
                                                        // if file exists locally, just delete it
                                                        if(fileManager.fileExists(atPath: documnets)){
                                                            try! fileManager.removeItem(atPath: documnets)
                                                        }
                                                        
                                                        try! fileManager.moveItem(atPath: locationPath, toPath: documnets)
                                                        print("target location:\(documnets)")
                                                        callBack(response,true)
                                                    }
        })
        downloadTask.resume()
    }
    
    
    //===ChangeFileName===
    func ChangeFileName(file_id:String, newName:String, callBack:@escaping (Any,Bool) ->()) ->Void{
        if !CheckLogin()// check login status
        {
            return
        }
        var flag = false// set bool value for marking the conflict
        for tmpf in FilesFromCloud // making use of global list which saving all the information (with websock
        // delegate updates)
        {
            if tmpf.file_id == file_id{flag=true}
        }
        if flag == false
        {
            print("not allowed") 
            return
        }
        HTTP.POST("http://34.73.231.127/change_file_name",
                  parameters: ["file_id": file_id,
                               "file_new_name": newName], headers: ["Authorization":String(format:"Bearer %@",GlobalToken)])
        {
            Response in
            print("respons: \(Response.description)")
            
            if let error = Response.error {
                callBack(error,false)
                print("got an error: \(error)")
                return
            }
            do {
                let resp = try decoder.decode(ChangeName.self, from: Response.data)
                callBack(resp,resp.result)
                print("completed: \(resp.result)")
            } catch let error {
                callBack(error.localizedDescription,false)
                print("decode json error: \(error)")
            }
        }
    }
    
    //===delete===
    func DeleteFile(file_id:String, callBack:@escaping (Any,Bool) ->()) ->Void{
        if !CheckLogin() {
            return
        }
        
        HTTP.POST("http://34.73.231.127/delete_a_file",
                  parameters: ["file_id": file_id], headers: ["Authorization":String(format:"Bearer %@",GlobalToken)])
        {
            Response in
            print("respons: \(Response.description)")
            
            if let error = Response.error {
                callBack(error,false)
                print("got an error: \(error)")
                return
            }
            do {
                let resp = try decoder.decode(DeleteFileRet.self, from: Response.data)
                callBack(resp,resp.result)
                print("completed: \(resp.result)")
            } catch let error {
                callBack(error.localizedDescription,false)
                print("decode json error: \(error)")
            }
        }
    }
    
//     first testing
//     func viewDidLoad()
//    {
//        super.viewDidLoad()
//        let file_path1 = "/Users/perrionhuds/Desktop/w2.mp3"
//        let file_path2 = "/Users/perrionhuds/Desktop/xyy.rtf"
//        let file_path3 = "/Users/perrionhuds/Desktop/roof.png"
//        //uploadfile(path: file_path, type: false)
//        //var fixedID = ""
//
//        //deletefile(OurFileName: "thisfilesnamehasbeenchangedtoo")
//
//        uploadfile(path: file_path1, type: false)
//
//        // change_name(OurFileName: "xyz.rtf", newname: "thisfilesnamehasbeenchangedtoo")
//    }
}

