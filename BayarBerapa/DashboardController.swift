//
//  DashboardController.swift
//  BayarBerapa
//
//  Created by hadi on 12/5/15.
//  Copyright © 2015 Akhmad Syaikhul Hadi. All rights reserved.
//

import UIKit
import SWRevealViewController
import Alamofire
import SwiftyJSON

class DashboardController: UITableViewController,UIGestureRecognizerDelegate {
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    let segueIdentifier = "ShowPerDatiDuaSegue"
    
    var items: [JSON] = []
    var formatter = NSNumberFormatter()
    override func viewDidAppear(animated: Bool) {
        self.navigationController!.interactivePopGestureRecognizer!.delegate = self
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "rightRevealToggle:"
        }
        
        let headers = [
            "Ocp-Apim-Subscription-Key": "54ff93009ab8459f88379c0203f1fccd"
        ]
        Alamofire.request(
            .GET,
            "https://program06.azure-api.net/BayarBerapaAPI/SummBayarPerProvinsi",
            headers: headers,
            encoding: .JSON
        ).responseJSON { response in
            debugPrint(response)
            switch response.result {
            case .Success:
                let json = JSON(response.result.value!)
                if json != nil {
                    self.items = json.array!
                    self.tableView.reloadData()
                }
                break
            case .Failure:
                break
            }
        }
        
        formatter.numberStyle = .CurrencyStyle
        formatter.locale = NSLocale.init(localeIdentifier: "id_ID")
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        if self.items.count == 0 {
            return 1
        }
        return self.items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BiayaRataProvinsiCell", forIndexPath: indexPath) as! BiayaCustomCell
        
        if items.count > 0 {
            let data = self.items[indexPath.row]
            cell.titleLabel.text = data["NamaProvinsi"].stringValue
            cell.feeLabel.text = self.formatter.stringFromNumber(data["RataRataBayar"].intValue)
            cell.accessoryType = .DisclosureIndicator
        }
        else {
            cell.titleLabel.text = "No data"
            cell.feeLabel.text = ""
            cell.accessoryType = .None
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Biaya Rata-rata Layanan Publik"
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if self.items.count > 0 {
            let json = self.items[indexPath.row]
            print(json["IDrovinsi"].stringValue)
            self.performSegueWithIdentifier(segueIdentifier, sender: self)
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == segueIdentifier {
            if let destination = segue.destinationViewController as? DashboardPerDatiDuaController {
                if self.items.count > 0 {
                    let data = self.items[(self.tableView.indexPathForSelectedRow?.row)!]
                    destination.provinceCode = data["IDrovinsi"].stringValue
                }
            }
        }
    }

}
