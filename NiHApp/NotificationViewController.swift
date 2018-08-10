//
//  HomePageViewController.swift
//  NiHApp
//
//  Created by Masi on 2018-08-04.
//  Copyright © 2018 Masi. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class NotificationViewController: UIViewController {

    @IBOutlet weak var userFullNameLabel: UILabel!
    //-------------------------------------------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    //-------------------------------------------------------------------------------------------------------------
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //-------------------------------------------------------------------------------------------------------------
    @IBAction func signOutButtonTapped(_ sender: Any) {
        KeychainWrapper.standard.removeObject(forKey: "PersonId")
        KeychainWrapper.standard.removeObject(forKey: "PersonType")
        
        let signInPage = self.storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        let appDelegate = UIApplication.shared.delegate
        appDelegate?.window??.rootViewController = signInPage
    }
    //-------------------------------------------------------------------------------------------------------------
    @IBAction func loadMemberProfileButtonTapped(_ sender: Any) {
       loadMemberProfile()
    }
    //-------------------------------------------------------------------------------------------------------------
    func loadMemberProfile()
    {
        let userId: String? = KeychainWrapper.standard.string(forKey: "PersonId")
        
        //Send HTTP Request to perform Sign in
        let myUrl = URL(string: "http://localhost:8080/api/users/\(userId!)")
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "GET"// Compose a query string
        request.addValue(userId!, forHTTPHeaderField: "PersonId")

        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
       
            if error != nil
            {
                self.displayMessage(userMessage: "Could not successfully perform this request. Please try again later")
                print("error=\(String(describing: error))")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
               
                if let parseJSON = json {
                    
                    DispatchQueue.main.async
                        {
                            let firstName: String?  = parseJSON["firstName"] as? String
                            let lastName: String? = parseJSON["lastName"] as? String
                            
                            if firstName?.isEmpty != true && lastName?.isEmpty != true {
                                self.userFullNameLabel.text =  firstName! + " " + lastName!
                            }
                       }
                } else {
                    //Display an Alert dialog with a friendly error message
                    self.displayMessage(userMessage: "Could not successfully perform this request. Please try again later")
                }
                
            } catch {
                    // Display an Alert dialog with a friendly error message
                    self.displayMessage(userMessage: "Could not successfully perform this request. Please try again later")
                    print(error)
                }
            
        }
        task.resume()
    }
    //-------------------------------------------------------------------------------------------------------------
    func displayMessage(userMessage:String) -> Void {
        DispatchQueue.main.async
            {
                let alertController = UIAlertController(title: "Alert", message: userMessage, preferredStyle: .alert)
                
                let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                    // Code in this block will trigger when OK button tapped.
                    print("Ok button tapped")
                }
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion:nil)
        }
    }
    //-------------------------------------------------------------------------------------------------------------
}
