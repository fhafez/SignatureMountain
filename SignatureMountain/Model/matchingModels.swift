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

class MatchingModels {
    
    private var _client_id: Int!
    private var _firstname: String!
    private var _lastname: String!
    private var _dob: String!
    private var _signedIn: Bool!
    private var _current_datetime: Date!
    private var _sig: String!
    private var _services: [Int] = []
    
    private var _jsonMatchingPatients: JSON = JSON.null
    
    init(firstname: String, lastname: String) {
        self._firstname = firstname
        self._lastname = lastname
        
        let d:Date = Date()
        self._current_datetime = d
    }
    
    init() {
    }
    
    func signedIn() -> Bool {
        return self._signedIn
    }
    
    func asJSON() -> JSON {
        
        let df:DateFormatter = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let json:JSON = ["firstname": self._firstname,
                         "lastname": self._lastname,
                         "client_id": _client_id,
                         "current_datetime": df.string(from:_current_datetime),
                         "signed_in": self._signedIn,
                         "dob":self._dob,
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
            "signed_in": "\(self._signedIn!)",
            "current_datetime": df.string(from:_current_datetime),
            "sig": _sig,
            "services": _services
        ]
        
        return stringParams
        
    }
    
    func count() -> Int {
        return self._jsonMatchingPatients.count
    }
    
    // if multiple patients were returned with the same first and last names this method is used to pick one of them using DOB
    func findPatientByDOB(DoB: String) -> JSON {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        for (_,s) in _jsonMatchingPatients {
            
            debugPrint(s)
            
            if s["dob"].stringValue == DoB {
                return s
            }            
        }
        
        return JSON.null
    }
    
    func getJSONMatchingPatients() -> JSON {
        self._jsonMatchingPatients[0]["patientID"] = self._jsonMatchingPatients["id"]
        debugPrint(_jsonMatchingPatients)
        return self._jsonMatchingPatients
    }
    
    func populateFields() {
        if _jsonMatchingPatients != JSON.null && _jsonMatchingPatients.arrayValue.count == 1 {
            self._firstname = _jsonMatchingPatients[0]["firstname"].stringValue
            self._lastname = _jsonMatchingPatients[0]["lastname"].stringValue
            self._dob = _jsonMatchingPatients[0]["dob"].stringValue
            self._client_id = _jsonMatchingPatients[0]["id"].intValue
            self._signedIn = _jsonMatchingPatients[0]["signed_in"].boolValue
            self._sig = _jsonMatchingPatients[0]["sig"].stringValue
            if let services = _jsonMatchingPatients[0]["services"].arrayObject as? [Int] {
                self._services = services
            }
        }
    }
    
    // get all the patients matching the first and last names provided
    func getMatchingPatients(completed: @escaping DetailsRetrieved) {
        
        let params: [String: String] = ["firstname": _firstname, "lastname": _lastname]
        
        // download the matching patient here
        Alamofire.request(settings["matchPatientsURL"]!, method: .get, parameters: params)
            .authenticate(user: settings["user"]!, password: settings["password"]!)
            .responseJSON {
                response in
                if response.result.isSuccess {
                    if let returnVal = response.result.value {
                        debugPrint("Return val: ")
                        debugPrint(returnVal)
                        self._jsonMatchingPatients = JSON(returnVal)
                    }
                } else {
                    if let err = response.result.error {
                        //print("error \(String(describing: response.result.error))")
                        if err._code == NSURLErrorTimedOut {
                            debugPrint(err)
                        }
                    }
                    //                    self.present(connectionAlert, animated: true, completion: nil)
                }
                completed()
        }
        
    }
    
}

