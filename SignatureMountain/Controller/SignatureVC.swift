//
//  SignatureVC.swift
//  SignatureMountain
//
//  Created by Fadi Hafez on 2018-09-01.
//  Copyright © 2018 Fadi Hafez. All rights reserved.
//

import Foundation
import Alamofire
import UIKit
import SwiftyJSON
import SVProgressHUD

protocol canBeRestarted {
    func clearAllFields()
}

class SignatureVC: UIViewController {
    
    @IBOutlet weak var SigninBtn: UIButton!
    @IBOutlet weak var ClearBtn: UIButton!
    @IBOutlet weak var CancelBtn: UIButton!
    @IBOutlet weak var SignatureBoxImageView: UIImageView!
    
    var mainViewController: StartVC!
    
    var delegate : canBeRestarted?
    
    var lastPoint = CGPoint.zero
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var opacity: CGFloat = 1.0
    var brushWidth: CGFloat = 1.5
    var swiped = false
    
    var smallestX: CGFloat = 0.0
    var largestX: CGFloat = 0.0
    var smallestY: CGFloat = 0.0
    var largestY: CGFloat = 0.0
    
    var points: [CGPoint] = []
    
    var inPath: Bool = false
    
    var signinModel: JSON!
    
    var sig: String = ""
    
    var base64EncodedSig: String = ""
    
    @IBAction func clearBtnPressed(_ sender: Any) {
        SignatureBoxImageView.image = nil
    }
    override func viewDidLoad() {

        /*
        SigninBtn.layer.cornerRadius = 8.0
        CancelBtn.layer.cornerRadius = 8.0
        ClearBtn.layer.cornerRadius = 8.0
         */
        SignatureBoxImageView.layer.cornerRadius = 20.0
        SignatureBoxImageView.layer.borderColor = UIColor(red: 81/255, green: 81/255, blue: 81/255, alpha: 1.0).cgColor
        SignatureBoxImageView.layer.borderWidth = 1.0
        
        smallestX = view.frame.size.width
        smallestY = view.frame.size.height

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = false
        if let touch = touches.first {
            //lastPoint = touch.location(in: self.view)
            lastPoint = touch.location(in: SignatureBoxImageView.inputView)
            
            if inPath {
                sig.append(" '></path> ")
            }
            sig.append("<path fill='none' stroke='black' d='M \(lastPoint.x / 3) \(lastPoint.y / 3) ")
            inPath = true
            
            if lastPoint.x < smallestX {
                smallestX = lastPoint.x
            }
            if lastPoint.x > largestX {
                largestX = lastPoint.x
            }
            if lastPoint.y < smallestY {
                smallestY = lastPoint.y
            }
            if lastPoint.y > largestY {
                largestY = lastPoint.y
            }

        }
    }
    
    func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint) {
        
        // 1
        UIGraphicsBeginImageContext(view.frame.size)
        //UIGraphicsBeginImageContext(SignatureBoxImageView.frame.size)
        let context = UIGraphicsGetCurrentContext()
        
        SignatureBoxImageView.image?.draw(in: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        
        // 2
        context?.move(to: CGPoint(x: fromPoint.x, y: fromPoint.y))
        context?.addLine(to: CGPoint(x: toPoint.x, y: toPoint.y))
        
        // 3
        context?.setLineCap(CGLineCap.round)
        context?.setLineWidth(brushWidth)
        context?.setLineJoin(CGLineJoin.round)
        context?.setStrokeColor(red: red, green: green, blue: blue, alpha: opacity)
        context?.setBlendMode(CGBlendMode.normal)
        context?.setShouldAntialias(true)
        
        sig.append("L\(toPoint.x / 3) \(toPoint.y / 3) ")
        
        // 4
        context?.strokePath()
        
        // 5
        SignatureBoxImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        SignatureBoxImageView.alpha = opacity
        UIGraphicsEndImageContext()
        
    }
    
    @IBAction func signinBtnPressed(_ sender: Any) {
        self.sig.append(" '></path></svg>")
        
        print("X: \(smallestX) to \(largestX)")
        print("Y: \(smallestY) to \(largestY)")
        
        largestX += 10
        largestY += 10
        
        SVProgressHUD.setMaximumDismissTimeInterval(4)
        SVProgressHUD.setMaximumDismissTimeInterval(4)
        SVProgressHUD.setDefaultStyle(.light)
        SVProgressHUD.show(withStatus: "Signing in")
        SVProgressHUD.setShouldTintImages(false)
        SVProgressHUD.setFont(UIFont(name: "Avenir Book", size: 24.0)!)
        SVProgressHUD.setImageViewSize(CGSize(width: 400, height: 400))

        let utf8str = "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?><!DOCTYPE svg PUBLIC \"-//W3C//DTD SVG 1.1//EN\" \"http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd\"><svg xmlns=\"http://www.w3.org/2000/svg\" version=\"1.1\" width=\"\(largestX / 3)\" height=\"\(largestY / 3)\">\(self.sig)".data(using: String.Encoding.utf8)
        
        if let base64Encoded = utf8str?.base64EncodedString() {
            self.base64EncodedSig = base64Encoded
            commitSignin() {
                if let successImage = UIImage(named: "successIndicator") {
                    SVProgressHUD.show(successImage, status: "Signin Successful.  Please see front desk now.")
                    self.delegate?.clearAllFields()
                    self.mainViewController?.dismiss(animated: true, completion: nil)
                }
            }
        } else {
            let alert: UIAlertController = UIAlertController(title: "Signin Failed", message: "Signin Failed.  Please see front desk.", preferredStyle: .alert)
            let failedAction: UIAlertAction = UIAlertAction(title: "OK", style: .default) { (UIAlertAction) in
                if let failImage = UIImage(named: "failedIndicator") {
                    SVProgressHUD.show(failImage, status: "Signin Failed.  Please see front desk now.")
                    self.delegate?.clearAllFields()
                    self.mainViewController?.dismiss(animated: true, completion: nil)
                }
            }
            
            alert.addAction(failedAction)
            //self.present(alert, animated: true, completion: nil)
            
            //SVProgressHUD.showError(withStatus: "Signin Failed")
        }

    }
    
    func commitSignin(completed: @escaping DetailsRetrieved) {
        
        let connectionAlert: UIAlertController = UIAlertController(title: "Issue", message: "Connection Failure", preferredStyle: .alert)
        let appointmentModel: Signin = Signin(signinPatient: signinModel, current_datetime: Date())
        let params: Parameters = appointmentModel.createAppointment(sig: self.base64EncodedSig, services: [])
        debugPrint(params)
        debugPrint(base64EncodedSig)
        
        Alamofire.request(commitSigninURL, method: .post, parameters: params, encoding: JSONEncoding.default)
                .authenticate(user: user, password: password)
                .responseJSON {
                    response in
                    debugPrint(response)
                    if response.result.isSuccess {
                        debugPrint("Appointment created successfully")
                    } else {
                        print("error \(String(describing: response.result.error))")
                        self.present(connectionAlert, animated: true, completion: nil)
                    }
                    completed()
            }
    }

    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 6
        swiped = true
        if let touch = touches.first {
            //let currentPoint = touch.location(in:view)
            let currentPoint = touch.location(in:SignatureBoxImageView.inputView)
            drawLineFrom(fromPoint: lastPoint, toPoint: currentPoint)
            points.append(currentPoint)
            
            // 7
            lastPoint = currentPoint
            
            if currentPoint.x < smallestX {
                smallestX = currentPoint.x
            }
            if currentPoint.x > largestX {
                largestX = currentPoint.x
            }
            if currentPoint.y < smallestY {
                smallestY = currentPoint.y
            }
            if currentPoint.y > largestY {
                largestY = currentPoint.y
            }
        }
    }
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        delegate?.clearAllFields()
        mainViewController.dismiss(animated: true, completion: nil)
    }
    
}
