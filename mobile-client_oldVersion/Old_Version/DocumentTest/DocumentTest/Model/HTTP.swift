//
//  HTTP.swift


import Foundation
import UIKit
import SwiftHTTP

public struct OurResponse: Codable
{
    var result: Bool
    var fileName: String
    var version: String
}

extension OurResponse
{
    init()
    {
        result = false
        fileName = "None"
        version = "0"
    }
}

public struct GetInitialState : Codable
{
    var result: Bool
    var files: [filessss]
    
}

extension GetInitialState
{
    init()
    {
        self.result = false
        self.files = [filessss.init()]
    }
}

public struct filessss: Codable
{
    var file_name: String
    var version: Int
    var locked: Bool
    var file_id: String
    var url: URL
    //  let url: Foundation.URL = URL()
    
}

extension filessss
{
    init()
    {
        self.file_name = ""
        self.version = 0
        self.locked = false
        self.file_id = ""
        let temp = "https://www.apple.com"
        self.url = URL(string: temp)!
    }
}
// MARK :- This function is used for finding the file_id (String) for related file_name
func findrelatedfileID (FileName: String, withCompletion completion: @escaping (String?, Error?) -> Void)
{
    let url = "http://52.151.113.157/get_all_file_details"
    let urlObj = URL(string: url)
    let task = URLSession.shared.dataTask(with: urlObj!)
    { (data: Data?, response: URLResponse?, error: Error?) in
        if error != nil {
            completion(nil, error)
            return
        }
        else if let data = data {
            do {
                let user = try JSONDecoder().decode(GetInitialState.self, from: data)
                for i in user.files
                {
                    // print (i.file_name)
                    let isEqual = (i.file_name == FileName)
                    if isEqual
                    {
                        let update_file_id = i.file_id
                        completion(update_file_id, nil)
                        break;
                    }
                    // self.labels.text=i.file_name
                }
            }
            catch
            {
                completion(nil, error)
            }
        }
    }
    task.resume()
}

// MARK :- This function is used for upload a file to server by HTTP.


func uploadfile(path: String, type: Bool )
{
    let fileurl = URL(fileURLWithPath: path)
    let urlpath = URL(string: path)
    let FileName = urlpath!.lastPathComponent
    
    // According to api document, if the type is ‘new’ then you don’t need to specify the file id
    if type == true
    {
        HTTP.POST("http://52.151.113.157/upload_a_file", parameters: ["file_id": "1", "file_name":  FileName, "type": "new", "file": Upload(fileUrl: fileurl)])
        {
            Response in
            print("respons: \(Response.description)");
        }
    }
    
    // If the type is ‘update’ then you don’t need to specify file_name
    if type == false
    {
        //let update_file_id = findrelatedID(FileName: FileName)
        findrelatedfileID(FileName: FileName, withCompletion:
            { detail, error in
                if error != nil
                {
                    print("error!")
                }
                else
                {
                    let fixedID = detail!
                    print ("this is our ID: \(fixedID)")
                    HTTP.POST("http://52.151.113.157/upload_a_file", parameters: ["file_id": fixedID, "file_name":  FileName, "type": "update", "file": Upload(fileUrl: fileurl)])
                    {
                        Response in
                        print("respons: \(Response.description)");
                    }
                }
        })
        
    }
    
}

// MARK :- This function is used for deleting a file to server by HTTP.

func deletefile(OurFileName: String)
{
    //let update_file_id = findrelatedID(FileName: FileName)
    findrelatedfileID(FileName: OurFileName, withCompletion:
        { detail, error in
            if error != nil
            {
                print("error!")
            }
            else
            {
                let fixedID = detail!
                HTTP.POST("http://52.151.113.157/delete_a_file", parameters: ["file_id": fixedID])
                {
                    Response in
                    print("respons: \(Response.description)");
                }
            }
    })
}

// This function is used for changing file name by HTTP.

func change_name(OurFileName: String, newname: String)
{
    findrelatedfileID(FileName: OurFileName, withCompletion:
        { detail, error in
            if error != nil
            {
                print("error!")
            }
            else
            {
                let fixedID = detail!
                HTTP.POST("http://52.151.113.157/change_file_name", parameters: ["file_id": fixedID, "file_new_name": newname])
                {
                    Response in
                    print("respons: \(Response.description)");
                }
            }
    })
}

class  HTTPhandlers: UIViewController {
    override func viewDidLoad()
    {
        super.viewDidLoad()
        for(i, for count){
            let filePath;.count = ""
            uploadfile(path: filePath.count, type: false)
        }
        
    }
}
