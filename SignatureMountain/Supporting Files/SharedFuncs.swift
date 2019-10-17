//
//  SharedFuncs.swift
//  SignatureMountain
//
//  Created by Fadi Hafez on 2018-12-28.
//  Copyright © 2018 Fadi Hafez. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD
import SwiftyJSON

func prepareHUD() {
    SVProgressHUD.setMaximumDismissTimeInterval(4)
    SVProgressHUD.setMaximumDismissTimeInterval(4)
    SVProgressHUD.setDefaultStyle(.light)
    SVProgressHUD.setShouldTintImages(false)
//    SVProgressHUD.setFont(UIFont(name: "Avenir Book", size: 24.0)!)
    SVProgressHUD.setFont(UIFont(name: "Roboto", size: 24.0)!)
    SVProgressHUD.setImageViewSize(CGSize(width: 400, height: 400))
}

func prepareHUD(lightness: SVProgressHUDStyle) {
    SVProgressHUD.setMaximumDismissTimeInterval(4)
    SVProgressHUD.setMaximumDismissTimeInterval(4)
    SVProgressHUD.setDefaultStyle(lightness)
    SVProgressHUD.setShouldTintImages(false)
//    SVProgressHUD.setFont(UIFont(name: "Avenir Book", size: 24.0)!)
    SVProgressHUD.setFont(UIFont(name: "Roboto", size: 24.0)!)
    SVProgressHUD.setImageViewSize(CGSize(width: 400, height: 400))
}

func drawLogoInTitleBar(uivc: UIViewController) {
    /* Create an Image View to replace the Title View */
    let uimview = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: 100, height: 40))
    uimview.contentMode = .scaleAspectFit
    
    /* Load an image. Be careful, this image will be cached */
    let image = UIImage(named: "Logo.png")
    
    /* Set the image of the Image View */
    uimview.image = image
    
    /* Set the Title View */
    uivc.navigationItem.titleView = uimview
}

// if you pass the optional thisView parameter then this function will send you back to the root controller after displaying the success dialog
func showSuccessDialog(message: String, thisView: UIViewController?=nil) {
    if let successImage = UIImage(named: "successIndicator") {
        SVProgressHUD.show(successImage, status: message)
        if let view = thisView {
            view.navigationController?.popToRootViewController(animated: true)
        }
    }
}

func showFailedDialog(message: String) {
    if let failImage = UIImage(named: "failed") {
        SVProgressHUD.show(failImage, status: message)
    }
}
