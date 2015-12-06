//
//  UIKitProtocolExtensions.swift
//  BayarBerapa
//
//  Created by syahRiza on 12/6/15.
//  Copyright © 2015 Akhmad Syaikhul Hadi. All rights reserved.
//

import UIKit

protocol MenuDash {
    func backToPrev(sender: AnyObject)
}

extension  UIViewController : MenuDash{
    @IBAction func backToPrev(sender: AnyObject){
        self.navigationController?.popViewControllerAnimated(true)
    }
}