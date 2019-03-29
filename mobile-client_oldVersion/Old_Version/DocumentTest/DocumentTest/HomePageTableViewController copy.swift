import UIKit

class TableShowPageViewController: UITableViewController {
    
    @IBAction func unwindToDownload(_ segue: UIStoryboardSegue) {
        
    }
    
    
    var mainNameLable = [String]()
    var mainDateLable = [String]()
    var webAddress = [URL]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK : - GEtTdata set from Sever API & Store
        for i in user.files
        {
            mainNameLable.append(i.file_name)
            webAddress.append(i.url)
            mainDateLable.append(i.file_id)
            tableView.estimatedRowHeight = 50
            
        }
        print(mainNameLable) // For check array
        
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainNameLable.count
    }
    
    // MARK : - aligned row & column
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainCell", for: indexPath) as? MainViewCell
        
        let row = indexPath.row
        cell?.mainLable.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline)
        cell?.mainLable.text = mainNameLable[row]
        
        cell?.mainDate.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline)
        cell?.mainDate.text = mainDateLable[row]
        
        
        return cell!
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowFileDetails"{
            let detailViewController = segue.destination as? FileViewController
            let myIndexPath = self.tableView.indexPathForSelectedRow
            let row = myIndexPath?.row
            detailViewController?.webSite = webAddress[row!]
        }
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
