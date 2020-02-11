//
//  LoginViewController.swift
//  MSconsenter
//
//  Created by Daniel Naeh on 07/10/2019.
//  Copyright © 2019 Eldergen. All rights reserved.
//

import UIKit
import RealmSwift

var loggedUser: StaffUser  =  StaffUser()


class LoginViewController: UIViewController {

    @IBOutlet weak var loginEmail: UITextField!
    
    @IBOutlet weak var loginPassword: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let myColor  = navigationController?.navigationBar.barTintColor?.cgColor
        
        loginEmail.layer.cornerRadius = 8.0
        loginEmail.layer.masksToBounds = true
        loginEmail.layer.borderColor = myColor
        // loginEmail.layer.borderColor =
        //navigationController?.navigationBar.barTintColor?.cgColor
        loginEmail.layer.borderWidth = 2.0
        
       
        loginPassword.layer.cornerRadius = 8.0
        loginPassword.layer.masksToBounds = true
        loginPassword.layer.borderColor = myColor
        loginPassword.layer.borderWidth = 2.0
        
        
        loginButton.backgroundColor  = UIColor(cgColor: myColor!)
        registerButton.backgroundColor  = UIColor(cgColor: myColor!)
        
//        NotificationCenter.default.addObserver(self, selector: Selector("keyboardWillShow:"), name:UIResponder.keyboardWillShowNotification, object: nil);
//        NotificationCenter.default.addObserver(self, selector: Selector("keyboardWillHide:"), name:UIResponder.keyboardWillHideNotification, object: nil);

        
    }
    
//    func keyboardWillShow(sender: NSNotification) {
//        self.view.frame.origin.y = -80 // Move view 150 points upward
//    }
//
//    func keyboardWillHide(sender: NSNotification) {
//        self.view.frame.origin.y = 0 // Move view to original position
//    }
//
    
    @IBAction func loginClick(_ sender: Any) {
        
        
        
        //MARK: get login information
        let realm = try! Realm()
        //loginPassword.text
        print ("Before segway")
        //let predicate = NSPredicate(format: "Password == '\(loginPassword.text!)' AND Email == '\(loginEmail.text!)'")
        let predicate =  "Password == 'jun1per' AND Email == 'daniel.naeh@gmail.com' "
        //print (predicate)
        let _: Bool = false
        let user =  realm.objects(StaffUser.self).filter(predicate).first
        print ("after  condition")
       // print(user!)
        if user != nil
        {   // store username and passsword in keychain
            
            
            storeCerdentialsInMem(staffUser:  user!)
            performSegue(withIdentifier: "ShowTaskList" ,sender: self)
            getToken()
            // now check if we need to process unsent rows
              let networkStatus = NetworkStatus.sharedInstance
              networkStatus.enquireStatus()
              if  networkStatus.connected
             {
                
         // Query and update from any thread
//         DispatchQueue(label: "background").async {
//             autoreleasepool {
//                 let realm = try! Realm()
//                ProcessSendTable(realm: realm)                 }
//             }
             //ProcessSendTable(realm: realm)          

                
         }

//            DispatchQueue.global(qos: .background).async {
//                print("Run on background thread")
//                ProcessSendTable()
//                DispatchQueue.main.async {
//                    print("We finished that.")
//                    // only back on the main thread, may you access UI:
//                            }
//                }
//            }
        }
        else{
            // out put messge
             let alertView = UIAlertController(title: "Login failure", message: "Wrong user name or password.", preferredStyle: .alert)
            alertView.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

            //  Show it to your users
            self.present(alertView, animated: true, completion: nil)
            
            
        }
        //MARK: check  on data base
        print ("after segway")
    
    }
    
 
    
    
    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func RegisterTrialData(_ sender: Any) {
        

      
        
      let dataLoadManager = TrialContentManager()
      dataLoadManager.GetorUpdateTrialData()
        
        
        
    }
}
