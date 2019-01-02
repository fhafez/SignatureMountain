//
//  Appointments.swift
//  SignatureMountain
//
//  Created by Fadi Hafez on 2019-01-01.
//  Copyright © 2019 Fadi Hafez. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import Alamofire

class Appointments {
    
    enum DataParsingError: Error {
        case unknownResponse
    }
    
    enum NetworkError: Error {
        case connectFailure
    }
    
    
    func getTodaysAppointments(completed: @escaping (JSON?, Error?) -> ()) {
        
        let params: [String: String] = [:]
        var appointments = JSON.null
        
        // download the matching patient here
        Alamofire.request(settings["todaysAppointmentsURL"]!, method: .get, parameters: params)
            .authenticate(user: settings["user"]!, password: settings["password"]!)
            .responseJSON {
                response in
                switch response.result {
                case .success:
                    if let returnVal = response.result.value {
                        debugPrint(returnVal)
                        //self.todaysAppts = JSON(returnVal)
                        appointments = JSON(returnVal)
                        debugPrint(appointments)
                        completed(appointments, nil)
                    } else {
                        completed(nil, DataParsingError.unknownResponse)
                    }
                case .failure(let error):
                    debugPrint("error \(error)")
                    completed(nil, NetworkError.connectFailure)
                }
        }
        
    }
    
    func createAppointment(params: Parameters, completed: @escaping (Int?, Error?) -> ()) {
        
        Alamofire.request(settings["commitSigninURL"]!, method: .post, parameters: params, encoding: JSONEncoding.default)
            .authenticate(user: settings["user"]!, password: settings["password"]!)
            .responseJSON {
                response in
                switch response.result {
                case .success:
                    if let returnVal = response.result.value {
                        debugPrint("Appointment created successfully")
                        let appointmentID = Int(JSON(returnVal)["id"].stringValue)
                        completed(appointmentID, nil)
                    } else {
                        completed(nil, DataParsingError.unknownResponse)
                    }
                case .failure(let error):
                    completed(nil, error)
                }
        }

    }
    
}
