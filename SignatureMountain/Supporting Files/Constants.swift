//
//  Constants.swift
//  SignatureMountain
//
//  Created by Fadi Hafez on 2018-09-01.
//  Copyright © 2018 Fadi Hafez. All rights reserved.
//

import Foundation
import UIKit

var settings: [String: String] = [:]

let buttonCornerRadius:CGFloat = 40.0
let buttonBorderWidth:CGFloat = 3.0
let buttonBorderColor = UIColor.white.cgColor

let registerButtonCornerRadius:CGFloat = 20.0
let registerButtonBorderWidth:CGFloat = 2.0

typealias DetailsRetrieved = () -> ()

enum SaveObjectError: Error {
    case mandatoryFieldsNotProvided
}

