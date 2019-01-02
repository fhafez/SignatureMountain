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
    
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet var datePicker : UIDatePicker!
    
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
        
        //Date Picker
        datePicker = UIDatePicker()
        datePicker.tag = 100
        datePicker.datePickerMode = UIDatePicker.Mode.date
        datePicker.addTarget(self, action: #selector(self.setDate(_sender:)), for: .valueChanged)
        datePicker.timeZone = TimeZone.current
        dateField.inputView = datePicker
        
    }
    
    @objc func setDate(_sender : UIDatePicker){
        let dateFormatter: DateFormatter = DateFormatter()
        // Set date format
        dateFormatter.dateFormat = "MM/dd/yyyy"
        // Apply date format
        let selectedDate: String = dateFormatter.string(from: _sender.date)
        print("Selected value \(selectedDate)")
        if(_sender.tag == 100){
            dateField.text = "\(selectedDate)"
        }
        //self.view.endEditing(true)
    }
    
    @objc func DismissKeyboard() {
        view.endEditing(true)
    }

    @IBAction func registerBtnPressed(_ sender: Any) {

        self.view.endEditing(true)
        prepareHUD(lightness: .dark)
        
        SVProgressHUD.show(withStatus: "Registering")
        UIApplication.shared.beginIgnoringInteractionEvents()

        if let firstname = FirstName.text {
            if let lastname = LastName.text {
                let patient = Patient(firstname: firstname, lastname: lastname, dob: dateField.text!)
                SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.light)
                do {
                    try patient.save {
                        
                        if patient.getId() > 0, let successImage = UIImage(named: "successIndicator") {
                            SVProgressHUD.show(successImage, status: "Registration Successful.  Please sign in now")
                            UIApplication.shared.endIgnoringInteractionEvents()
                            self.navigationController?.popToRootViewController(animated: true)
                        } else if let failImage = UIImage(named: "failed") {
                                SVProgressHUD.show(failImage, status: "Registration Failed.  Perhaps you have registered before?")
                                UIApplication.shared.endIgnoringInteractionEvents()
                        }
                    }
                } catch (SaveObjectError.mandatoryFieldsNotProvided) {
                    print("Mandatory Fields Not Provided")
                    if let failImage = UIImage(named: "failed") {
                        SVProgressHUD.show(failImage, status: "You must provide a Firstname, Lastname and Date of Birth")
                        UIApplication.shared.endIgnoringInteractionEvents()
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
