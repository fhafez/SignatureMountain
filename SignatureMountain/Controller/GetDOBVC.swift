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
import ChameleonFramework

class GetDOBVC: UIViewController {
    
    var matchingModels: MatchingModels = MatchingModels()
    var mainViewController: StartVC!
    var delegate: SigninVC!
    var operation: String = ""
    var appointments: JSON = JSON.null
    var _pageTitle: String?

    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var dob: UIDatePicker!
    @IBOutlet weak var continueBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let pageTitle = _pageTitle {
            self.title = pageTitle
        }
        
        dob.backgroundColor = UIColor.white
        dob.setValue(0.9, forKeyPath: "alpha")
        dob.layer.cornerRadius = 20
        
    }
    
    @IBAction func continueBtnPressed(_ sender: Any) {
        
        prepareHUD(lightness: .light)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        debugPrint(matchingModels)
        let matchingPatients = matchingModels.findPatientByDOB(DoB: dateFormatter.string(from: dob.date))
        
        if matchingPatients != JSON.null {
            debugPrint(matchingPatients)
            
            if operation == "signin" {
                SVProgressHUD.show(withStatus: "Signing in")
                self.performSegue(withIdentifier: "SignatureVC", sender: matchingPatients)
                SVProgressHUD.dismiss()
            } else if operation == "signout" {
                SVProgressHUD.show(withStatus: "Signing out")
                commitSignout(matchingPatients)
            }
        } else {

            if let failImage = UIImage(named: "failed") {
                SVProgressHUD.show(failImage, status: "Patient with that name and date of birth not found.  Perhaps you need to register first.")
            }
        }
        
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    func setPageTitle(pageTitle: String?) {
        _pageTitle = pageTitle
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SignatureVC" {
            if let getSignatureVC = segue.destination as? SignatureVC, let signinModel = sender as? JSON {
                getSignatureVC.signinModel = signinModel
                getSignatureVC.mainViewController = self.mainViewController
                getSignatureVC.delegate = delegate
            }
        }
    }

    func commitSignout(_ patientModel: JSON) {
        
        debugPrint(appointments)
        
        // filter all of today's appointments for the client attempting to sign in
        let patientAppts = appointments.filter { $0.1["client_id"].intValue == patientModel["id"].intValue }
        debugPrint("patientAppts \(patientAppts)")
        if patientAppts.count == 0 {
            // no appointments found for this patient for today
            if let failImage = UIImage(named: "failed") {
                SVProgressHUD.show(failImage, status: "You are not signed in at the moment")
            }
            return
        }
        
        let firstname = patientModel["firstname"].stringValue
        let lastname = patientModel["lastname"].stringValue
        let dob = patientModel["dob"].stringValue
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: dob) {
            
            let patient = Patient(firstname: firstname, lastname: lastname, dob: date)
            debugPrint(appointments)
            let lastAppt = patientAppts[patientAppts.count-1].1
            patient.signout(appointment_id: lastAppt["id"].intValue, completed: {
                print("done")
                if let successImage = UIImage(named: "successIndicator") {
                    SVProgressHUD.show(successImage, status: "Signout Successful.  Thank you")
                    self.navigationController?.popToRootViewController(animated: true)
                }
            })
        }

    }

    
}
