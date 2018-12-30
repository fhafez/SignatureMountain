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

func prepareHUD() {
    SVProgressHUD.setMaximumDismissTimeInterval(4)
    SVProgressHUD.setMaximumDismissTimeInterval(4)
    SVProgressHUD.setDefaultStyle(.light)
    SVProgressHUD.setShouldTintImages(false)
    SVProgressHUD.setFont(UIFont(name: "Avenir Book", size: 24.0)!)
    SVProgressHUD.setImageViewSize(CGSize(width: 400, height: 400))
}

func prepareHUD(lightness: SVProgressHUDStyle) {
    SVProgressHUD.setMaximumDismissTimeInterval(4)
    SVProgressHUD.setMaximumDismissTimeInterval(4)
    SVProgressHUD.setDefaultStyle(lightness)
    SVProgressHUD.setShouldTintImages(false)
    SVProgressHUD.setFont(UIFont(name: "Avenir Book", size: 24.0)!)
    SVProgressHUD.setImageViewSize(CGSize(width: 400, height: 400))
}
