//
//  Constants.swift
//  SignatureMountain
//
//  Created by Fadi Hafez on 2018-09-01.
//  Copyright © 2018 Fadi Hafez. All rights reserved.
//

import Foundation
import UIKit

let user = "fadi"
let password = "fadi"
let commitSigninURL = "http://192.168.1.139/~fadihafez/signin-template/php/signinJS.php/"
let matchPatientsURL = "http://192.168.1.139/~fadihafez/signin-template/php/matchPatients.php/"
let registerPatientURL = "http://192.168.1.139/~fadihafez/signin-template/php/registerJS.php/"
let todaysAppointmentsURL = "http://192.168.1.139/~fadihafez/signin-template/php/signinJS.php/appointments/"
let signoutAppointmentURL = "http://192.168.1.139/~fadihafez/signin-template/php/signinJS.php/"

let buttonCornerRadius:CGFloat = 40.0
let buttonBorderWidth:CGFloat = 3.0
let buttonBorderColor = UIColor.white.cgColor

let registerButtonCornerRadius:CGFloat = 20.0
let registerButtonBorderWidth:CGFloat = 2.0

typealias DetailsRetrieved = () -> ()

enum SaveObjectError: Error {
    case mandatoryFieldsNotProvided
}
