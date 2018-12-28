//
//  signin.swift
//  SignatureMountain
//
//  Created by Fadi Hafez on 2018-08-31.
//  Copyright © 2018 Fadi Hafez. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Signin {
    
    private var _client_id: Int!
    private var _firstname: String!
    private var _lastname: String!
    private var _dob: String!
    private var _current_datetime: Date!
    private var _sig: String!
    private var _services: [Int] = []
    
    private var _jsonSignin: JSON = JSON.null
    
    var clientId: Int {
        return _client_id
    }

    var firstname: String {
        return _firstname
    }

    var lastname: String {
        return _lastname
    }
    
    var dob: String {
        return _dob
    }

    var currentDatetime: Date {
        return _current_datetime
    }
    
    var sig: String {
        return _sig
    }
        
    var services: [Int] {
        return _services
    }
    
    
    init(firstname: String, lastname: String) {
        self._firstname = firstname
        self._lastname = lastname
        
        let d:Date = Date()
        self._current_datetime = d
    }
    
    init(firstname: String, lastname: String, client_id: Int, current_datetime: Date, sig: String, services: [Int]) {
        self._client_id = client_id
        self._firstname = firstname
        self._lastname = lastname
        self._current_datetime = current_datetime
        self._sig = sig
        self._services = services
    }
    
    init(signinPatient: JSON, current_datetime: Date) {
        self._client_id = signinPatient["id"].intValue
        self._firstname = signinPatient["firstname"].stringValue
        self._lastname = signinPatient["lastname"].stringValue
        self._current_datetime = current_datetime
        self._sig = signinPatient["sig"].stringValue
        self._services = []
    }
    
    func asJSON() -> JSON {
        
        let df:DateFormatter = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let json:JSON = ["firstname": self._firstname,
                "lastname": self._lastname,
                "client_id": _client_id,
                "current_datetime": df.string(from:_current_datetime),
                "sig": _sig,
                "services": _services] as JSON
        
        return json
        
    }
    
    func asArray() -> Dictionary<String, Any> {
        
        let df:DateFormatter = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let stringParams: Dictionary<String, Any> = [
            "firstname": self._firstname,
            "lastname": self._lastname,
            "client_id": "\(self._client_id!)",
            "current_datetime": df.string(from:_current_datetime),
            "sig": _sig,
            "services": _services
        ]
        
        return stringParams
        
    }
    
    func count() -> Int {
        return self._jsonSignin.count
    }
    
    func createAppointment(sig: String, services: [Int]) -> Parameters {
        self._sig = sig
        self._services = services

        debugPrint(self._sig)
        
        let df:DateFormatter = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"

        let appointmentData: Parameters = [
            "client_id": self._client_id,
            "firstname": self._firstname,
            "lastname": self._lastname,
            "sig": self._sig,
            "services": self._services,
            "current_datetime": df.string(from:_current_datetime),
            "signed_in": "true"
        ]
        
        return appointmentData
    }
    
    func getDetails(completed: @escaping DetailsRetrieved) {

        let params: [String: String] = ["firstname": _firstname, "lastname": _lastname]
        
        // download the matching patient here
        Alamofire.request(settings["matchPatientsURL"]!, method: .get, parameters: params)
            .authenticate(user: settings["user"]!, password: settings["password"]!)
            .responseJSON {
                response in
                if response.result.isSuccess {
                    if let returnVal = response.result.value {
                        debugPrint(returnVal)
                        self._jsonSignin = JSON(returnVal)

                        if self._jsonSignin.count == 0 {
                            print("no client by that name found")
                        } else if self._jsonSignin.count > 1 {
                            print("\(self._jsonSignin.count) clients found");
                        } else {
                            debugPrint(self._jsonSignin[0]["id"].intValue)
                            self._client_id = self._jsonSignin[0]["id"].intValue
                            self._dob = self._jsonSignin[0]["dob"].stringValue
                        }
                    }
                } else {
                    print("error \(String(describing: response.result.error))")
//                    self.present(connectionAlert, animated: true, completion: nil)
                }
                
                completed()
        }

    }
    
}
