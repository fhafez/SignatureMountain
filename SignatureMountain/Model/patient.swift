//
//  patient.swift
//  SignatureMountain
//
//  Created by Fadi Hafez on 2018-09-19.
//  Copyright © 2018 Fadi Hafez. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Patient {
    
    private var _id: Int!
    private var _fisrtname: String
    private var _lastname: String
    private var _dob: Date
    
    init(firstname: String, lastname: String, dob: Date) {
        
        self._fisrtname = firstname
        self._lastname = lastname
        self._dob = dob
        self._id = 0
    }

    init(firstname: String, lastname: String, dob: String) {
        
        self._fisrtname = firstname
        self._lastname = lastname
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        if let date = dateFormatter.date(from: dob) {
            self._dob = date
        } else {
            self._dob = dateFormatter.date(from: "01/01/1970")!
        }
        self._id = 0
    }

    func getId() -> Int {
        return _id
    }
    
    func signout(appointment_id: Int, completed: @escaping DetailsRetrieved) {
        
        let dateFormatter = DateFormatter()
        let currentDate:Date = Date()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.string(from: currentDate)
        
        let params: [String: String] = ["client_id": "\(self._id!)", "signout_date": date]
        let signoutURL = settings["signoutAppointmentURL"]! + "\(appointment_id)"
        
        // register the patient into the DB
//        let request = Alamofire.request(signoutURL, method: .put, parameters: params, encoding: JSONEncoding.default)
//        debugPrint(request)
        
        Alamofire.request(signoutURL, method: .put, parameters: params, encoding: JSONEncoding.default)
            .authenticate(user: settings["user"]!, password: settings["password"]!)
            .validate()
            .responseJSON {
                response in
                if response.result.isSuccess {
                    if let returnVal = response.result.value {
                        debugPrint(returnVal)
                        
                        let jsonReturn = JSON(returnVal)
                        if let clientId = jsonReturn["id"].int {
                            debugPrint(jsonReturn["id"])
                            self._id = clientId
                        }
                    }
                } else {
                    //debugPrint("error \(String(describing: response.result.error))")
                    debugPrint("\(response.error!)")
                }
                
                completed()
        }
    }
    
    func save(completed: @escaping DetailsRetrieved) throws {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.string(from: self._dob)
        
        let params: [String: String] = ["firstname": self._fisrtname, "lastname": self._lastname, "dob": date]
        
        if self._fisrtname.isEmpty || self._lastname.isEmpty || date.isEmpty {
            let error = SaveObjectError.mandatoryFieldsNotProvided
            throw error
        }
        
        // register the patient into the DB
        Alamofire.request(settings["registerPatientURL"]!, method: .post, parameters: params, encoding: JSONEncoding.default)
            .authenticate(user: settings["user"]!, password: settings["password"]!)
            .validate()
            .responseJSON {
                response in
                if response.result.isSuccess {
                    if let returnVal = response.result.value {
                        debugPrint(returnVal)
                        
                        let jsonReturn = JSON(returnVal)
                        if let clientId = jsonReturn["id"].int {
                            debugPrint(jsonReturn["id"])
                            self._id = clientId
                        }

                    }
                } else {
                    //debugPrint("error \(String(describing: response.result.error))")
                    debugPrint("\(response.error!)")
                }
                
                completed()
        }
        
    }
    
}
