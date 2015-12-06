//
//  RekamTransaksiController.swift
//  BayarBerapa
//
//  Created by hadi on 12/6/15.
//  Copyright © 2015 Akhmad Syaikhul Hadi. All rights reserved.
//

import UIKit
import SWRevealViewController
import Alamofire
import SwiftyJSON

class RekamTransaksiController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var provincePicker: UIPickerView!
    @IBOutlet weak var pemdaPicker: UIPickerView!
    @IBOutlet weak var servicePicker: UIPickerView!
    
    var provinceList: [JSON] = []
    var pemdaList: [JSON] = []
    var serviceList: [JSON] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        provincePicker.delegate = self
        provincePicker.dataSource = self
        pemdaPicker.delegate = self
        pemdaPicker.dataSource = self
        servicePicker.delegate = self
        servicePicker.dataSource = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // The number of columns of data
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == provincePicker {

            return AppManager.sharedInstance.provinceList.count
        }
        else if pickerView == pemdaPicker {
            return pemdaList.count
        }
        return serviceList.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == provincePicker {
            let json = AppManager.sharedInstance.provinceList[row]
            return  json["NamaProvinsi"].stringValue
        }
        else if pickerView == pemdaPicker {
            
        }
        return "" //serviceList[row]
    }
    
}
