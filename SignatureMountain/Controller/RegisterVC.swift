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
    
    var mainViewController: ViewController!
    var delegate : ViewController?

    @IBAction func abc(_ sender: Any) {
        view.endEditing(true)
    }
    @IBAction func dobTouched(_ sender: Any) {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FirstName.layer.cornerRadius = 10.0
        LastName.layer.cornerRadius = 10.0

        RegisterBtn.layer.cornerRadius = buttonCornerRadius
        ClearBtn.layer.cornerRadius = buttonCornerRadius
        CancelBtn.layer.cornerRadius = buttonCornerRadius
        
        RegisterBtn.layer.borderWidth = buttonBorderWidth
        RegisterBtn.layer.borderColor = buttonBorderColor
        ClearBtn.layer.borderWidth = buttonBorderWidth
        ClearBtn.layer.borderColor = buttonBorderColor
        CancelBtn.layer.borderWidth = buttonBorderWidth
        CancelBtn.layer.borderColor = buttonBorderColor

        DOBView.layer.cornerRadius = 10.0
        
        let Tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DismissKeyboard))
        let DOBTap:UITapGestureRecognizer = UITapGestureRecognizer(target: DOB, action: #selector(DismissKeyboard))
        
        view.addGestureRecognizer(Tap)
        DOB.addGestureRecognizer(DOBTap)
    }
    
    @objc func DismissKeyboard() {
        view.endEditing(true)
    }

    
    /*
    @IBAction func dobChanged(_ sender: Any) {
        view.endEditing(true)
    }
    */
    
    @IBAction func registerBtnPressed(_ sender: Any) {

        SVProgressHUD.setMaximumDismissTimeInterval(3)
        SVProgressHUD.setMaximumDismissTimeInterval(3)
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.setShouldTintImages(false)
        SVProgressHUD.setImageViewSize(CGSize(width: 200, height: 200))

        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.dark)
        SVProgressHUD.show(withStatus: "Registering")

        if let firstname = FirstName.text {
            if let lastname = LastName.text {
                let patient = Patient(firstname: firstname, lastname: lastname, dob: DOB.date)
                do {
                    try patient.save {
                        
                        if patient.getId() > 0 {
                            if let successImage = UIImage(named: "successIndicator") {
                                SVProgressHUD.show(successImage, status: "Registration Successful.  Please sign in now")
                                self.delegate?.clearAllFields()
                                self.mainViewController?.dismiss(animated: true, completion: nil)
                            }
                        } else {
                            if let failImage = UIImage(named: "failedIndicator") {
                                SVProgressHUD.show(failImage, status: "Registration Failed.  Perhaps you have registered before?")
                            }
                        }
                    }
                } catch (SaveObjectError.mandatoryFieldsNotProvided) {
                    print("Mandatory Fields Not Provided")
                    if let failImage = UIImage(named: "failedIndicator") {
                        SVProgressHUD.show(failImage, status: "You must provide a Firstname, Lastname and Date of Birth")
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
        delegate?.dismiss(animated: true, completion: nil)
    }
    
}
