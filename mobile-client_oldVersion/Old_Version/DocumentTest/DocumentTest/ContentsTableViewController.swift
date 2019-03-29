//
//  ContentsTableViewController.swift
//  pratic
//
//  Created by Jihye Hwang on 16/03/2019.
//  Copyright © 2019 황지혜. All rights reserved.
//

import UIKit

class ContentsTableViewController: UITableViewController {
    
    
    
    
    func fetch(keyword text: String? = nil) -> [FileData] {
        
        ...
        
        // range with date
        let regdateDesc = NSSortDescriptor(key: "regdate", ascending: false)
        fetchRequest.sortDescriptors = [regdateDesc]
        
        //Keyword exist
        if let t = text, t.isEmpty == false {
            fetchRequest.predicate = NSPredicate(format: "contents CONTAINS[c] %@", t)
        }
        
        ...
        
    } catch let e as NSError {
    NSLog("An error has occurred: %s", e.localizedDescription)
    }
    return file_list
}

}
