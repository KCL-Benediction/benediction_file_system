

import UIKit

class HomeTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(showprofile), name: NSNotification.Name("showprofile"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showupload), name: NSNotification.Name("showupload"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showdownload), name: NSNotification.Name("showdownload"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showtrash), name: NSNotification.Name("showtrash"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showsettings), name: NSNotification.Name("showsettings"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showlogout), name: NSNotification.Name("showlogout"), object: nil)
    }
    
    /*start from this part for page seque to connected each page naturally and each arrow have a name then we linked to find the next page or back.*/
    @objc func showprofile ()
    {
        performSegue(withIdentifier: "showprofile", sender: nil)
    }
    
    @objc func showupload ()
    {
        performSegue(withIdentifier: "showupload", sender: nil)
    }
    
    @objc func showdownload ()
    {
        performSegue(withIdentifier: "showdownload", sender: nil)
    }
    
    @objc func showtrash ()
    {
        performSegue(withIdentifier: "showtrash", sender: nil)
    }
    
    @objc func showsettings ()
    {
        performSegue(withIdentifier: "showsettings", sender: nil)
    }
    
    @objc func showlogout()
    {
        performSegue(withIdentifier: "showlogout", sender: nil)
    }
    
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
}

extension HomeViewController: UIViewControllerTransitioningDelegate
{
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.presents = true
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.presents = false
        return transition
    }
}

    


