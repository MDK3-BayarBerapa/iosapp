//
//  DashboardHistoryPembayaranController.swift
//  BayarBerapa
//
//  Created by hadi on 12/6/15.
//  Copyright © 2015 Akhmad Syaikhul Hadi. All rights reserved.
//

import UIKit
import SWRevealViewController
import Alamofire
import SwiftyJSON

class DashboardHistoryPembayaranController: UITableViewController {
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBAction func backToPrev(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    var idDatiDua: String!
    
    var items: [JSON] = []
    var formatter = NSNumberFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        if idDatiDua == nil || idDatiDua == "" {
            return
        }
        
        print(idDatiDua)
        
        let headers = [
            "Ocp-Apim-Subscription-Key": "54ff93009ab8459f88379c0203f1fccd"
        ]
        Alamofire.request(
            .GET,
            "https://program06.azure-api.net/BayarBerapaAPI/DataBayarDetil/" + self.idDatiDua.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()),
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
        let cell = tableView.dequeueReusableCellWithIdentifier("HistoryTransaksiCell", forIndexPath: indexPath) as! TransaksiCustomCell
        
        if items.count > 0 {
            let data = self.items[indexPath.row]
            cell.datetime.text = data["TglTransaksi"].stringValue
            cell.officeName.text = data["NamaKantor"].stringValue
            cell.serviceName.text = data["Layanan"].stringValue
            cell.feeLabel.text = formatter.stringFromNumber(data["Bayar"].intValue)
//            cell.accessoryType = .DisclosureIndicator
        }
        else {
            cell.datetime.text = "No data"
            cell.officeName.text = ""
            cell.serviceName.text = ""
            cell.feeLabel.text = ""
//            cell.accessoryType = .None
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "History Transaksi Layanan Publik"
    }
}