//
//  Connectivity.swift
//  SignatureMountain
//
//  Created by Fadi Hafez on 2018-12-25.
//  Copyright © 2018 Fadi Hafez. All rights reserved.
//

import Foundation
import Alamofire

class Connectivity {
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
