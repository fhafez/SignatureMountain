//
//  Start.swift
//  SignatureMountain
//
//  Created by Fadi Hafez on 2018-12-26.
//  Copyright © 2018 Fadi Hafez. All rights reserved.
//

import Foundation
import UIKit

class StartVC: UIViewController {

    var _direction: String?
    
    let defaults = UserDefaults.standard
    @IBOutlet weak var abc: UIStackView!
    
    @IBAction func gotoSignin(_ sender: Any) {
        _direction = "in"
        self.performSegue(withIdentifier: "gotoSigninout", sender: nil)
    }

    @IBAction func gotoSignout(_ sender: Any) {
        _direction = "out"
        self.performSegue(withIdentifier: "gotoSigninout", sender: nil)
    }

    @IBAction func gotoRegister(_ sender: Any) {
        self.performSegue(withIdentifier: "gotoRegister", sender: nil)
    }

    override func viewDidLoad() {
        // nothing yet
        super.viewDidLoad()
        
        print(NSHomeDirectory())
        drawLogoInTitleBar(uivc: self)
        print(settings)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let settingsDict = defaults.dictionary(forKey: "settings") {
            let signoutDisabled = settingsDict["signoutDisabled"] as? String
            if signoutDisabled == "true" {
                abc.isHidden = true
            } else {
                abc.isHidden = false
            }
        }

        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotoSigninout" {
            if let signinVC = segue.destination as? SigninVC {
                if let direction = _direction {
                    if direction == "in" {
                        signinVC.setDirection(direction: "in")
                        signinVC.setPageTitle(pageTitle: "SIGNING IN")
                        signinVC.delegate = self
                    } else if direction == "out" {
                        signinVC.setDirection(direction: "out")
                        signinVC.setPageTitle(pageTitle: "SIGNING OUT")
                        signinVC.delegate = self
                    }
                }
            }
        } else if segue.identifier == "gotoRegister" {
            if let registerVC = segue.destination as? RegisterVC {
                registerVC.delegate = self
            }
        }

    }
    
    
}
