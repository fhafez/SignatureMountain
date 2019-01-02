//
//  InterfaceMessages.swift
//  SignatureMountain
//
//  Created by Fadi Hafez on 2019-01-01.
//  Copyright © 2019 Fadi Hafez. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD

class InterfaceMessages: UIViewController {
   
    func displayErrorMessageDialog(current: UIViewController, title: String, msg: String) {
        let alert: UIAlertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let retryAction: UIAlertAction = UIAlertAction(title: "OK", style: .default)
        
        let messageFont = [kCTFontAttributeName: UIFont(name: "Roboto", size: 16.0)!]
        let messageAttrString = NSMutableAttributedString(string: msg, attributes: messageFont as [NSAttributedString.Key : Any])
        let titleFont = [kCTFontAttributeName: UIFont.boldSystemFont(ofSize: 18.0)]
        let messageAttrTitle = NSMutableAttributedString(string: title, attributes: titleFont as [NSAttributedString.Key : Any])
        
        alert.setValue(messageAttrString, forKey: "attributedMessage")
        alert.setValue(messageAttrTitle, forKey: "attributedTitle")
        
        alert.addAction(retryAction)
        current.present(alert, animated: true, completion: nil)
    }
    
    func prepareHUD(lightness: SVProgressHUDStyle) {
        SVProgressHUD.setMaximumDismissTimeInterval(4)
        SVProgressHUD.setMaximumDismissTimeInterval(4)
        SVProgressHUD.setDefaultStyle(lightness)
        SVProgressHUD.setShouldTintImages(false)
        SVProgressHUD.setFont(UIFont(name: "Avenir Book", size: 24.0)!)
        SVProgressHUD.setImageViewSize(CGSize(width: 400, height: 400))
    }


}
