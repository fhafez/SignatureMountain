//
//  ViewController.swift
//  SignatureMountain
//
//  Created by Fadi Hafez on 2018-08-31.
//  Copyright © 2018 Fadi Hafez. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD
import Alamofire

@IBDesignable
class DesignableView: UIView {
}

@IBDesignable
class DesignableButton: UIButton {
}

@IBDesignable
class DesignableLabel: UILabel {
}

@IBDesignable
class DesignableTextField: UITextField {
}

@IBDesignable
class GradientButton: UIButton {
    let gradientLayer = CAGradientLayer()
    
    @IBInspectable
    var topGradientColor: UIColor? {
        didSet {
            setGradient(topGradientColor: topGradientColor, bottomGradientColor: bottomGradientColor)
        }
    }
    
    @IBInspectable
    var bottomGradientColor: UIColor? {
        didSet {
            setGradient(topGradientColor: topGradientColor, bottomGradientColor: bottomGradientColor)
        }
    }
    
    private func setGradient(topGradientColor: UIColor?, bottomGradientColor: UIColor?) {
        if let topGradientColor = topGradientColor, let bottomGradientColor = bottomGradientColor {
            gradientLayer.frame = bounds
            gradientLayer.colors = [topGradientColor.cgColor, bottomGradientColor.cgColor]
            gradientLayer.borderColor = layer.borderColor
            gradientLayer.borderWidth = layer.borderWidth
            gradientLayer.cornerRadius = layer.cornerRadius
            layer.insertSublayer(gradientLayer, at: 0)
        } else {
            gradientLayer.removeFromSuperlayer()
        }
    }
}

extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
}


class SigninVC: UIViewController, canBeRestarted {

    @IBOutlet weak var CancelBtn: UIButton!
    @IBOutlet weak var NextBtn: UIButton!
    @IBOutlet weak var ClearBtn: UIButton!
    @IBOutlet weak var Firstname: UITextField!
    @IBOutlet weak var Lastname: UITextField!
    
    var delegate : StartVC?
    var _pageTitle: String? = ""
    var _direction: String?

    //var todaysAppts: JSON = JSON.null
    
    @IBAction func clearBtnPressed(_ sender: Any) {
        Firstname.text = ""
        Lastname.text = ""
    }

    @IBAction func nextBtnPressed(_ sender: Any) {
        prepareHUD()
        
        if _direction == "in" {
            signin()

        } else if _direction == "out" {
            signout()
        }
    }
    
    @IBAction func CancelBtnPressed(_ sender: Any) {
        delegate?.dismiss(animated: true, completion: nil)
    }
    
    func setPageTitle(pageTitle: String) {
        _pageTitle = pageTitle
    }
    
    func setDirection(direction: String) {
        _direction = direction
    }
    

    func signin() {
        
        if Firstname.text?.count == 0 || Lastname.text?.count == 0 {
            let alert: UIAlertController = UIAlertController(title: "Required Field Missing", message: "Firstname and Lastname must be provided", preferredStyle: .alert)
            
            let restartAction: UIAlertAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(restartAction)
            present(alert, animated: true, completion: nil)
        } else {
            
            // hide the keyboard
            DismissKeyboard()
            SVProgressHUD.show()
            
            let matchingModels: MatchingModels = MatchingModels(firstname: Firstname.text!, lastname: Lastname.text!)
            matchingModels.getMatchingPatients {
                
                SVProgressHUD.dismiss()
                
                debugPrint("Got the details")
                debugPrint(matchingModels)
                
                if matchingModels.count() == 0 {
                    print("no patients found with those names")
                    if let failImage = UIImage(named: "failedIndicator") {
                        SVProgressHUD.show(failImage, status: "No patient with that name found")
                    }
                } else if matchingModels.count() > 1 {
                    print("more than 1 patient found matching those names")
                    self.performSegue(withIdentifier: "getDOBVC", sender: [matchingModels, "signin"])
                } else {
                    debugPrint(matchingModels)
                    self.performSegue(withIdentifier: "SignatureVC", sender: matchingModels.getJSONMatchingPatients()[0])
                }
            }
        }
    }
    
    // hide the keyboard
    @objc func DismissKeyboard() {
        view.endEditing(true)
    }

    func signout() {
        
        if Firstname.text!.isEmpty || Lastname.text!.isEmpty {
            let alert: UIAlertController = UIAlertController(title: "Required Field Missing", message: "Firstname and Lastname must be provided", preferredStyle: .alert)
            
            let restartAction: UIAlertAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(restartAction)
            present(alert, animated: true, completion: nil)
        } else {
            
            DismissKeyboard()
            SVProgressHUD.show(withStatus: "Signing Out")
            
            // look for matching patient names
            let matchingModels: MatchingModels = MatchingModels(firstname: Firstname.text!, lastname: Lastname.text!)
            matchingModels.getMatchingPatients {
                
                debugPrint("Got the details")
                debugPrint(matchingModels)
                
                if matchingModels.count() == 0 {
                    print("no patients found with those names")
                    if let failImage = UIImage(named: "failedIndicator") {
                        SVProgressHUD.show(failImage, status: "No patient with that name found")
                    }
                } else if matchingModels.count() > 1 {
                    print("more than 1 patient found matching those names")
                    SVProgressHUD.dismiss()
                    self.getTodaysAppointments (){
                        (appointments:JSON) in
                        self.performSegue(withIdentifier: "getDOBVC", sender: [matchingModels, "signout", appointments])
                        debugPrint("done getting today's appointments")
                    }
                } else {
                    // found one patient matching first and last name
                    debugPrint(matchingModels)
                    SVProgressHUD.dismiss()
                    matchingModels.populateFields()
                    self.getTodaysAppointments (){
                        (appointments:JSON) in
                        self.signoutPatient(patientModel: matchingModels, appointments: appointments)
                        debugPrint("done getting today's appointments")
                    }
                }
            }
        }
    }
    
    func signoutPatient(patientModel: MatchingModels, appointments: JSON) {
        
        if patientModel.signedIn() == false {
            if let failImage = UIImage(named: "failedIndicator") {
                SVProgressHUD.show(failImage, status: "You are not signed in at the moment")
            }
        } else {
            
            // filter out the appointments that include the client_id of this patient
            debugPrint(appointments)
            
            let patientAppts = appointments.filter { $0.1["client_id"].intValue == patientModel.asJSON()["client_id"].intValue }
            debugPrint(patientAppts)
            if patientAppts.count == 0 {
                if let failImage = UIImage(named: "failedIndicator") {
                    SVProgressHUD.show(failImage, status: "You are not signed in at the moment")
                }
                return
            }
            
            let firstname = patientModel.asJSON()["firstname"].stringValue
            let lastname = patientModel.asJSON()["lastname"].stringValue
            let dob = patientModel.asJSON()["dob"].stringValue

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            if let date = dateFormatter.date(from: dob) {

                let patient = Patient(firstname: firstname, lastname: lastname, dob: date)
                debugPrint(appointments)
                let lastAppt = patientAppts[patientAppts.count-1].1
                patient.signout(appointment_id: lastAppt["id"].intValue, completed: {
                    print("done")
                    if let successImage = UIImage(named: "successIndicator") {
                        self.clearAllFields()
                        SVProgressHUD.show(successImage, status: "Signout Successful.  Thank you")
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                })
            }
        }
    }
    
    func getTodaysAppointments(completed: @escaping (_ appointments: JSON) -> Void) {
        
        let params: [String: String] = [:]
        var appointments = JSON.null
        
        // download the matching patient here
        Alamofire.request(settings["todaysAppointmentsURL"]!, method: .get, parameters: params)
            .authenticate(user: settings["user"]!, password: settings["password"]!)
            .responseJSON {
                response in
                if response.result.isSuccess {
                    if let returnVal = response.result.value {
                        debugPrint(returnVal)
                        
                        //self.todaysAppts = JSON(returnVal)
                        appointments = JSON(returnVal)
                        debugPrint(appointments)
                        
                    }
                } else {
                    print("error \(String(describing: response.result.error))")
                }
                completed(appointments)
        }
        
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
        
        if let pageTitle = _pageTitle {
            self.title = pageTitle
        }
        //PageTitle.text = _pageTitle
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func clearAllFields() {
        Firstname.text = ""
        Lastname.text = ""
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SignatureVC" {
            if let getSignatureVC = segue.destination as? SignatureVC {
                if let signinModel = sender as? JSON {
                    getSignatureVC.signinModel = signinModel
                    getSignatureVC.delegate = self
                    getSignatureVC.mainViewController = delegate
                }
            }
        } else if segue.identifier == "getDOBVC" {
            if let getDOBVC = segue.destination as? GetDOBVC {
                if let params = sender as? [Any] {
                    if let operation = params[1] as? String {
                        if let matchingModels = params[0] as? MatchingModels {
                            getDOBVC.matchingModels = matchingModels
                            getDOBVC.operation = operation
                            getDOBVC.delegate = self
                            getDOBVC.mainViewController = delegate
                            getDOBVC.setPageTitle(pageTitle: "\(_pageTitle ?? "") - Date of Birth")
                            if params.count == 3 {
                                if let appointments = params[2] as? JSON {
                                    getDOBVC.appointments = appointments
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

