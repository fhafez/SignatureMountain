//
//  AppDelegate.swift
//  SignatureMountain
//
//  Created by Fadi Hafez on 2018-08-31.
//  Copyright © 2018 Fadi Hafez. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as String)

        let defaults = UserDefaults.standard
        let baseURLValue: String
        let username: String
        let password: String
        
        if let settingsDict = defaults.dictionary(forKey: "settings") {
            baseURLValue = settingsDict["baseURL"] as! String
            username = settingsDict["user"] as! String
            password = settingsDict["password"] as! String
/*
            settings["baseURL"] = baseURLValue
            settings["user"] = username
            settings["password"] = password
            settings["commitSigninURL"] = "\(baseURLValue)php/signinJS.php/"
            settings["matchPatientsURL"] = "\(baseURLValue)php/matchPatients.php/"
            settings["registerPatientURL"] = "\(baseURLValue)php/registerJS.php/"
            settings["todaysAppointmentsURL"] = "\(baseURLValue)php/signinJS.php/appointments/"
            settings["signoutAppointmentURL"] = "\(baseURLValue)php/signinJS.php/"
 */
            
            
            settings["baseURL"] = baseURLValue
            settings["user"] = username
            settings["password"] = password
 
            
            //settings["commitSigninURL"] = "\(baseURLValue)php/signinJS.php/"
            settings["commitSigninURL"] = "\(baseURLValue)createAppointment"
            //settings["matchPatientsURL"] = "\(baseURLValue)php/matchPatients.php/"
            settings["matchPatientsURL"] = "\(baseURLValue)getPatients"
            settings["registerPatientURL"] = "\(baseURLValue)php/registerJS.php/"
            settings["todaysAppointmentsURL"] = "\(baseURLValue)php/signinJS.php/appointments/"
            settings["signoutAppointmentURL"] = "\(baseURLValue)php/signinJS.php/aaa"
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

