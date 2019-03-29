

import UIKit

//MARK :- Setting struct to store data from server

public struct Country : Codable
{
    var result: Bool
    var files: [filedetails]
    
}

extension Country
{
    init()
    {
        self.result = false
        self.files = [filedetails.init()]
    }
}

public struct filedetails: Codable
{
    var file_name: String
    var version: Int
    var locked: Bool
    var file_id: String
    var url: URL
    //  let url: Foundation.URL = URL()
}
extension filedetails
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
public var user=Country.init()

public class HomeTableViewController: UITableViewController {

    // for UIVIEW
    @IBOutlet weak var homeTablecontainer: UIView!
    
    @IBOutlet weak var FileTable: UITableView!
    
    @IBAction func unwindToMain(_ segue: UIStoryboardSegue) {
        
    }

    //MARK :- Table Showing in the Main page
    var snap:MainTableViewController?
    
    //Mark : - Calling Data for Table Showing in the Main page
    override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segueView")
        { snap = (segue.destination as! MainTableViewController) }
    }



}
