//
//  RegisterVC.swift
//  SignatureMountain
//
//  Created by Fadi Hafez on 2018-09-16.
//  Copyright © 2018 Fadi Hafez. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import SVProgressHUD

class RegisterVC: UIViewController {
    
    @IBOutlet weak var FirstName: UITextField!
    @IBOutlet weak var LastName: UITextField!
    
    @IBOutlet weak var DOB: UIDatePicker!
    
    @IBOutlet weak var DOBView: UIView!
    @IBOutlet weak var RegisterBtn: UIButton!
    @IBOutlet weak var ClearBtn: UIButton!
    @IBOutlet weak var CancelBtn: UIButton!
    
    var delegate : StartVC?

    @IBAction func abc(_ sender: Any) {
        view.endEditing(true)
    }
    @IBAction func dobTouched(_ sender: Any) {
        view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !Connectivity.isConnectedToInternet {
            print("not connected to the internet")
            let alert: UIAlertController = UIAlertController(title: "Connection Failed", message: "No Connection to the Internet", preferredStyle: .alert)
            let retryAction: UIAlertAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(retryAction)
            present(alert, animated: true, completion: nil)
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "REGISTERING"
                
        let Tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DismissKeyboard))
        let DOBTap:UITapGestureRecognizer = UITapGestureRecognizer(target: DOB, action: #selector(DismissKeyboard))
        
        view.addGestureRecognizer(Tap)
        DOB.addGestureRecognizer(DOBTap)
    }
    
    @objc func DismissKeyboard() {
        view.endEditing(true)
    }

    @IBAction func registerBtnPressed(_ sender: Any) {

        SVProgressHUD.setMaximumDismissTimeInterval(5)
        SVProgressHUD.setMaximumDismissTimeInterval(5)
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.setShouldTintImages(false)
        SVProgressHUD.setFont(UIFont(name: "Avenir", size: 24.0)!)
        SVProgressHUD.setImageViewSize(CGSize(width: 400, height: 400))

        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.show(withStatus: "Registering")
        UIApplication.shared.beginIgnoringInteractionEvents()

        if let firstname = FirstName.text {
            if let lastname = LastName.text {
                let patient = Patient(firstname: firstname, lastname: lastname, dob: DOB.date)
                SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.light)
                do {
                    try patient.save {
                        
                        if patient.getId() > 0 {
                            if let successImage = UIImage(named: "successIndicator") {
                                SVProgressHUD.show(successImage, status: "Registration Successful.  Please sign in now")
                                UIApplication.shared.endIgnoringInteractionEvents()
                                //self.delegate?.clearAllFields()
                                //self.delegate?.dismiss(animated: true, completion: nil)
                                self.navigationController?.popToRootViewController(animated: true)
                            }
                        } else {
                            if let failImage = UIImage(named: "failedIndicator") {
                                SVProgressHUD.show(failImage, status: "Registration Failed.  Perhaps you have registered before?")
                                UIApplication.shared.endIgnoringInteractionEvents()
                            }
                        }
                    }
                } catch (SaveObjectError.mandatoryFieldsNotProvided) {
                    print("Mandatory Fields Not Provided")
                    if let failImage = UIImage(named: "failedIndicator") {
                        SVProgressHUD.show(failImage, status: "You must provide a Firstname, Lastname and Date of Birth")
                        //UIApplication.shared.endIgnoringInteractionEvents()
                    }
                } catch {
                    print(error)
                }
            }
        }
    }
    
    @IBAction func clearBtnPressed(_ sender: Any) {
        FirstName.text = ""
        LastName.text = ""
    }
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        //delegate?.dismiss(animated: true, completion: nil)
        guard (navigationController?.popToRootViewController(animated: true)) != nil else {
            print("could not pop to root view controller")
            return
        }
    }
    
}
