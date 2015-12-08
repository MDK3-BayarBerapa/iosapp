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

class RekamTransaksiController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var kantorText: UITextField!
    @IBOutlet weak var provincePicker: UIPickerView!
    @IBOutlet weak var pemdaPicker: UIPickerView!
    @IBOutlet weak var servicePicker: UIPickerView!
    
    @IBOutlet weak var amountText: UITextField!
    var provinceList: [JSON] = []
    var pemdaList: [JSON] = []
    var serviceList: [JSON] = []
    
    @IBAction func sliderChanged(sender: UISlider) {
        let amount = Int(sender.value * 100) * 1000
        self.amountText.text = "\(amount)"
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "rightRevealToggle:"
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
            let json = AppManager.sharedInstance.provinceList[provincePicker.selectedRowInComponent(0)]
            return json["DaftarPemda"].array!.count
        }else if pickerView == servicePicker {
            
            return  AppManager.sharedInstance.serviceList.count
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
            let json = AppManager.sharedInstance.provinceList[provincePicker.selectedRowInComponent(0)]
            return json["DaftarPemda"].array![row]["NamaPemda"].stringValue
        }else if pickerView == servicePicker {
            let json = AppManager.sharedInstance.serviceList[row]
            return  json["NamaLayanan"].stringValue
        }
        return "" //serviceList[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == provincePicker{
            pemdaPicker.reloadAllComponents()
        }
    }
    
    @IBAction func daftarkan(sender: UIButton) {
        let amount = Int(self.amountText.text!)
        let namaKantor = self.kantorText.text!
        let provinceList = AppManager.sharedInstance.provinceList
        let provinceId = provinceList[provincePicker.selectedRowInComponent(0)]["IDProv"].stringValue
        let pemdaId = provinceList[provincePicker.selectedRowInComponent(0)]["DaftarPemda"].array![pemdaPicker.selectedRowInComponent(0)]["IDPemda"].stringValue
        let serviceCode = AppManager.sharedInstance.serviceList[servicePicker.selectedRowInComponent(0)]["IDLayanan"].stringValue
        AppManager.sharedInstance.submitTransaction(provinceId, pemdaCode: pemdaId, serviceCode: serviceCode, amount: amount!, kantor: namaKantor) { (response) -> Void in
            let alert : UIAlertController
            switch response.result {
            case .Success:
                alert = UIAlertController(title: "Hasil", message: "Daftar Tansaksi Sukses", preferredStyle: UIAlertControllerStyle.Alert)
                
                
                break
            case .Failure:
                alert = UIAlertController(title: "Hasil", message: "Daftar Tansaksi Sukses", preferredStyle: UIAlertControllerStyle.Alert)
                break
            }
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
    }
    /**
     * Called when 'return' key pressed. return NO to ignore.
     */
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
