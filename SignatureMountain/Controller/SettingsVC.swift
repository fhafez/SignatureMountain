//
//  Settings.swift
//  SignatureMountain
//
//  Created by Fadi Hafez on 2018-12-27.
//  Copyright © 2018 Fadi Hafez. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class PaddingLabel: UILabel {
    
    @IBInspectable var topInset: CGFloat = 5.0
    @IBInspectable var bottomInset: CGFloat = 5.0
    @IBInspectable var leftInset: CGFloat = 7.0
    @IBInspectable var rightInset: CGFloat = 7.0
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }
}



class SettingsVC: UIViewController {
    
    let defaults = UserDefaults.standard
    @IBOutlet weak var baseURL: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBAction func backBtnPressed(_ sender: Any) {
        
        // save the data to UserDefaults
        if let baseURLValue = self.baseURL.text {
        
            settings["baseURL"] = baseURLValue
            settings["user"] = self.username.text
            settings["password"] = self.password.text
            settings["commitSigninURL"] = "\(baseURLValue)php/signinJS.php/"
            settings["matchPatientsURL"] = "\(baseURLValue)php/matchPatients.php/"
            settings["registerPatientURL"] = "\(baseURLValue)php/registerJS.php/"
            settings["todaysAppointmentsURL"] = "\(baseURLValue)php/signinJS.php/appointments/"
            settings["signoutAppointmentURL"] = "\(baseURLValue)php/signinJS.php/aaa"
            
            defaults.set(settings, forKey: "settings")
        }
        
        //defaults.setValue(settings, forKey: "settings")
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        // nothing yet
        
        if let settingsDict = defaults.dictionary(forKey: "settings") {
            baseURL.text = settingsDict["baseURL"] as? String
            username.text = settingsDict["user"] as? String
            password.text = settingsDict["password"] as? String
        }
        
    }

    
}
