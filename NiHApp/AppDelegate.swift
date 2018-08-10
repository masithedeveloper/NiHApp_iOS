//
//  AppDelegate.swift
//  NiHApp
//
//  Created by Masi on 2018-08-04.
//  Copyright © 2018 Masi. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    //-------------------------------------------------------------------------------------------------------------
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // REMOVE THIS PLEASE!!!!!!!
        //KeychainWrapper.standard.removeObject(forKey: "PersonId")
        //KeychainWrapper.standard.removeObject(forKey: "PersonType")
        let PersonId = KeychainWrapper.standard.integer(forKey: "PersonId")
        
        if PersonId != nil
        {
            // Take user to a home page
            let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            if(KeychainWrapper.standard.bool(forKey: "PersonType"))!{
                let billSummaryPage = mainStoryboard.instantiateViewController(withIdentifier: "BillSummaryViewController") as! BillSummaryViewController
                let appDelegate = UIApplication.shared.delegate
                appDelegate?.window??.rootViewController = billSummaryPage
            }
            else{//} if (!KeychainWrapper.standard.bool(forKey: "PersonType")!){
                let notificationPage = mainStoryboard.instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
                let appDelegate = UIApplication.shared.delegate
                appDelegate?.window??.rootViewController = notificationPage
            }
        }
        else{
            loadDrivers()
        }
        return true
    }
    //-------------------------------------------------------------------------------------------------------------
    func loadDrivers(){
        //Send HTTP Request to perform Sign in
        let myUrl = URL(string: "http://www.nihapp.co.za/api/auth")
        let request = URLRequest(url:myUrl!)
        
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil
            {
                //self.displayMessage(userMessage: "Could not successfully perform this request. Please try again later")
                print("error=\(String(describing: error))")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSArray
                
                if let parseJSON = json {
                    
                    DispatchQueue.main.async
                        {
                            //let firstName: String?  = parseJSON["firstName"] as? String
                            //let lastName: String? = parseJSON["lastName"] as? String
                            
                            //if firstName?.isEmpty != true && lastName?.isEmpty != true {
                                //self.userFullNameLabel.text =  firstName! + " " + lastName!
                            //}
                    }
                } else {
                    //Display an Alert dialog with a friendly error message
                    //self.displayMessage(userMessage: "Could not successfully perform this request. Please try again later")
                }
                
            } catch {
                // Display an Alert dialog with a friendly error message
                //self.displayMessage(userMessage: "Could not successfully perform this request. Please try again later")
                print(error)
            }
        }
        task.resume()
    }
    //-------------------------------------------------------------------------------------------------------------
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    //-------------------------------------------------------------------------------------------------------------
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    //-------------------------------------------------------------------------------------------------------------
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    //-------------------------------------------------------------------------------------------------------------
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    //-------------------------------------------------------------------------------------------------------------
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    //-------------------------------------------------------------------------------------------------------------
}

