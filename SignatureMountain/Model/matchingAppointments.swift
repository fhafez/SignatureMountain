//
//  matchingAppointments.swift
//  SignatureMountain
//
//  Created by Fadi Hafez on 2018-09-23.
//  Copyright © 2018 Fadi Hafez. All rights reserved.
//

import Foundation

import Foundation
import Alamofire
import SwiftyJSON

class MatchingAppointments {
    
    /*
    var id: Int
    var client_id": "2",
    "dob": "1978-12-18",
    "firstname": "Rula",
    "lastname": "Tahboub",
    "services": [],
    "signed_in": true,
    "signature": "",
    "message": "SUCCESS"
    */
    
    var _jsonTodaysAppointments: JSON = JSON.null
    
    init() {
    }
    
    func matchingAppointments(client_id: Int) {
        
        for (_,currentAppointment) in _jsonTodaysAppointments {
            
            if currentAppointment["client_id"].intValue == client_id {
                debugPrint(currentAppointment["signed_in"])
            }
            
        }
        
    }
    
    func signoutPatient(completed: @escaping DetailsRetrieved) {

        Alamofire.request(todaysAppointmentsURL, method: .get)
            .authenticate(user: user, password: password)
            .responseJSON {
                response in
                if response.result.isSuccess {
                    if let returnVal = response.result.value {
                        self._jsonTodaysAppointments = JSON(returnVal)
                    }
                } else {
                    print("error \(String(describing: response.result.error))")
                    //                    self.present(connectionAlert, animated: true, completion: nil)
                }
                completed()
        }

    }
    
    func getTodaysAppointments(completed: @escaping DetailsRetrieved) {
        
        // download the matching patient here
        Alamofire.request(todaysAppointmentsURL, method: .get)
            .authenticate(user: user, password: password)
            .responseJSON {
                response in
                if response.result.isSuccess {
                    if let returnVal = response.result.value {
                        self._jsonTodaysAppointments = JSON(returnVal)
                    }
                } else {
                    print("error \(String(describing: response.result.error))")
                    //                    self.present(connectionAlert, animated: true, completion: nil)
                }
                completed()
        }
        
    }
    
    
}
