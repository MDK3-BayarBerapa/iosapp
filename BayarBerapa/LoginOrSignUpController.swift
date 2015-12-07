//
//  LoginOrSignUpController.swift
//  BayarBerapa
//
//  Created by hadi on 12/5/15.
//  Copyright © 2015 Akhmad Syaikhul Hadi. All rights reserved.
//

import UIKit
import SWRevealViewController
import Alamofire
import SwiftyJSON

class LoginOrSignUpController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    let accountSegue = "ShowAccountSegue"
    
    @IBAction func login() {
        let uname = self.usernameField.text
        let pwd = self.passwordField.text
        
        if uname != "" && pwd != "" {
            let headers = [
                "Ocp-Apim-Subscription-Key": "54ff93009ab8459f88379c0203f1fccd"
            ]
            Alamofire.request(
                .GET,
                "https://program06.azure-api.net/BayarBerapaAPI/DoLogin/" + uname! + "/" + pwd!,
                headers: headers,
                encoding: .JSON
                ).responseJSON { response in
                    debugPrint(response)
                    switch response.result {
                    case .Success:
                        let msg = response.result.value! as! String
                        print("RESPONS: ", msg)
                        
                        if msg != "Belum Login" {
                            let prefs: NSUserDefaults = NSUserDefaults.standardUserDefaults()
                            let isLoggedIn: Int = prefs.integerForKey("ISLOGGEDIN") as Int
                            
                            if isLoggedIn != 1 {
                                prefs.setInteger(1, forKey: "ISLOGGEDIN")
                                prefs.synchronize()
                                print("Loggedin successfully")
                                
                                self.performSegueWithIdentifier(self.accountSegue, sender: self)
                            }
                            else {
                                print("Already loggedin")
                            }
                        }
                        
                        break
                    case .Failure:
                        break
                    }
            }
        }
    }
    
    override func loadView() {
        super.loadView()
    
        // check is already loggedin
        let prefs: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        if prefs.integerForKey("ISLOGGEDIN") == 1 {
            self.performSegueWithIdentifier(accountSegue, sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "rightRevealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        self.usernameField.delegate = self
        self.passwordField.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool { // called when 'return' key pressed. return NO to ignore.
        self.view.endEditing(true)
        return false;
    }

}
