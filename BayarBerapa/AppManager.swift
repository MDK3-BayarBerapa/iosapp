//
//  AppManager.swift
//  BayarBerapa
//
//  Created by syahRiza on 12/6/15.
//  Copyright © 2015 Akhmad Syaikhul Hadi. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
public class AppManager{
    private(set) var provinceList: [JSON] = []
    private(set) var serviceList: [JSON] = []
    
    static let sharedInstance = AppManager()
    private init() {}
    
    
    func fetchBasicData(){
        if let path = NSBundle.mainBundle().pathForResource("ListProvPemda", ofType: "json")
        {
            if let jsonData = NSData(contentsOfFile: path)
            {
                let json = JSON(data: jsonData)
                
                self.provinceList = json.array!
            }
        }
        
        let headers = [
            "Ocp-Apim-Subscription-Key": "54ff93009ab8459f88379c0203f1fccd"
        ]
        let userDefault = NSUserDefaults.standardUserDefaults()
        
        if let serviceData = userDefault.dataForKey("serviceData"){
            let json = JSON(data: serviceData)
            
            self.serviceList = json.array!
            
        }else{
            Alamofire.request(
                .GET,
                "https://program06.azure-api.net/BayarBerapaAPI/GetJenisLayanan",
                headers: headers,
                encoding: .JSON
                ).responseJSON { response in
                    debugPrint(response)
                    switch response.result {
                    case .Success:
                        let json = JSON(response.result.value!)
                        if json != nil {
                            self.serviceList = json.array!
                            do{
                                try userDefault.setObject(json.rawData(), forKey: "serviceData")
                            }catch{
                                debugPrint("failed")
                            }
                        }
                        break
                    case .Failure:
                        break
                    }
            }
        }

        
        
    }
    
    
}