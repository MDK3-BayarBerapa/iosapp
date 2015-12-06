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
    private(set) var pemdaList: [JSON] = []
    private(set) var serviceList: [JSON] = []
    
    static let sharedInstance = AppManager()
    private init() {}
    
    func fetchBasicData(){
        let headers = [
            "Ocp-Apim-Subscription-Key": "54ff93009ab8459f88379c0203f1fccd"
        ]
        Alamofire.request(
            .GET,
            "https://program06.azure-api.net/BayarBerapaAPI/Provinsi",
            headers: headers,
            encoding: .JSON
            ).responseJSON { response in
                debugPrint(response)
                switch response.result {
                case .Success:
                    let json = JSON(response.result.value!)
                    if json != nil {
                        self.provinceList = json.array!
                    }
                    break
                case .Failure:
                    break
                }
        }
    }
}