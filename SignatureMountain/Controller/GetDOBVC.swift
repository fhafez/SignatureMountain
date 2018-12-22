//
//  GetDOBVC.swift
//  SignatureMountain
//
//  Created by Fadi Hafez on 2018-09-07.
//  Copyright © 2018 Fadi Hafez. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import SVProgressHUD
import Alamofire

class GetDOBVC: UIViewController {
    
    var matchingModels: MatchingModels = MatchingModels()
    var mainViewController: ViewController!
    var delegate: ViewController!
    var operation: String = ""
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var dob: UIDatePicker!
    @IBOutlet weak var continueBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        continueBtn.layer.cornerRadius = 8.0
        backBtn.layer.cornerRadius = 8.0
        
    }
    
    @IBAction func continueBtnPressed(_ sender: Any) {
        
        SVProgressHUD.setMaximumDismissTimeInterval(3)
        SVProgressHUD.setMaximumDismissTimeInterval(3)
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.setShouldTintImages(false)
        SVProgressHUD.setImageViewSize(CGSize(width: 200, height: 200))

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        debugPrint(matchingModels)
        let matchingPatients = matchingModels.findPatientByDOB(DoB: dateFormatter.string(from: dob.date))
        
        if matchingPatients != JSON.null {
            debugPrint(matchingPatients)
            
            if operation == "signin" {
                SVProgressHUD.show(withStatus: "Signing in")
                self.performSegue(withIdentifier: "SignatureVC", sender: matchingPatients)
            } else if operation == "signout" {
                SVProgressHUD.show(withStatus: "Signing out")
                
                commitSignout()
                // MARK - do the signout here
            }
        } else {
            /*
            let alert: UIAlertController = UIAlertController(title: "Patient not found", message: "Patient with that name and date of birth not found.  Perhaps you need to register first.", preferredStyle: .alert)
            let restartAction: UIAlertAction = UIAlertAction(title: "OK", style: .default) { (UIAlertAction) in
            }
            alert.addAction(restartAction)
            present(alert, animated: true, completion: nil)
            */
            if let failImage = UIImage(named: "failedIndicator") {
                SVProgressHUD.show(failImage, status: "Patient with that name and date of birth not found.  Perhaps you need to register first.")
            }
        }
        
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SignatureVC" {
            if let getSignatureVC = segue.destination as? SignatureVC {
                if let signinModel = sender as? JSON {
                    getSignatureVC.signinModel = signinModel
                    getSignatureVC.mainViewController = self.mainViewController
                    getSignatureVC.delegate = delegate
                }
            }
        }
    }

    func commitSignout() {
        
        let todaysAppointments = MatchingAppointments()
        todaysAppointments.getTodaysAppointments {
            todaysAppointments.matchingAppointments(client_id: 1)
        }

    }

    
}
