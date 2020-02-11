//
//  GetToken.swift
//  MSconsenter
//
//  Created by Daniel Naeh on 16/10/2019.
//  Copyright © 2019 Eldergen. All rights reserved.
//

import UIKit
import ResearchKit
import Alamofire
import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift


public  func  getToken ()
{
    
    //let defaults = UserDefaults.standard
    //let token = defaults.string(forKey: "token")
   // let secretParameters: [String : String] = ["password" : "jun1per", "username" : "daniel", "grant_type" : "password"]

    
    
    let header: HTTPHeaders = [
        "Content-Type" :  "application/x-www-form-urlencoded"
    ]
    
    let url = "https://wcbsearch.swan.ac.uk/test/token"

    Alamofire.request(url ,method: .post  , parameters : secretParameters ,headers : header)
        .responseJSON{
            
            
            
            response in
            
            if response .result.isSuccess{
                print ("Success! got token data")
                let
                tokenJSON : JSON = JSON(response.result.value!)
                
                let mytoken:  String = tokenJSON["access_token"].stringValue
                let defaults = UserDefaults.standard
                defaults.set(mytoken, forKey: "token" )
                print ("My tokenis ---------------------->")
                print(mytoken)
                print("Sent -----------------Token")
            }
            else{
                print ("theres an err ")
                
            }
    }
}


public  func  getTokenPublic (complete: @escaping ()->())
{
    
    //let defaults = UserDefaults.standard
    //let token = defaults.string(forKey: "token")
   // let secretParameters: [String : String] = ["password" : "jun1per", "username" : "daniel", "grant_type" : "password"]

   let embededSecretParameters = ["password" : "jun1per", "username" : "daniel", "grant_type" :"password"]
    let header: HTTPHeaders = [
        "Content-Type" :  "application/x-www-form-urlencoded"
    ]
    
    let url = "https://wcbsearch.swan.ac.uk/test/token"

    Alamofire.request(url ,method: .post  , parameters : embededSecretParameters ,headers : header)
        .responseJSON{
            
            
            
            response in
            
            if response .result.isSuccess{
                print ("Success! got token data")
                let
                tokenJSON : JSON = JSON(response.result.value!)
                
                let mytoken:  String = tokenJSON["access_token"].stringValue
                let defaults = UserDefaults.standard
                defaults.set(mytoken, forKey: "token" )
                print ("My Public Public Public Public token is ---------------------->")
                print(mytoken)
                print("Sent -----------------Token")
                complete()            }
            else{
                print ("theres an err ")
                complete()
            }
    }    
}






func MySendCosnetsItems (dictObj: JSON,consent: ConsentBits,progressView: UIProgressView )
   {
       
        let M_URL = "https://wcbsearch.swan.ac.uk/test/api/Consent/"

       let defaults = UserDefaults.standard
       let token = defaults.string(forKey: "token")
       
    
//    print( "Sent siggggggggnaturessssssssssssssssssssssssssssssssssss")
//       print(consent.sig1);
//       print ( "Sent siggggggggnaturessssssssssssssssssssssssssssssssssss")
//       print(consent.sig2);

       let header: HTTPHeaders = [
           "Authorization" :  "bearer " + token!
       ]

       
       let encoder = JSONEncoder()
       let jsonData = try! encoder.encode(dictObj)
       
       
       let url = URL(string: M_URL)
       var request = URLRequest(url: url! )
       request.httpMethod = HTTPMethod.post.rawValue
       request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
       request.httpBody = jsonData
       
           progressView.progress = 0.5
           Alamofire.request(request).responseJSON { response in
           switch response.result {
           case .success(let value):
               let swiftyJson = JSON(value)
               print ("finish alamofire call " )
               completionHandler(jasonValue: swiftyJson, erorr: nil, consent: consent,progressView: progressView)
           case .failure(let error):
               print("Failure")
               completionHandler(jasonValue: nil, erorr: error, consent: consent, progressView: progressView)
           }
       }
       
   }

func completionHandler (jasonValue: JSON?,  erorr: Error?, consent: ConsentBits,progressView: UIProgressView )
{
    // succes
    if ((erorr == nil) && (jasonValue != nil))
    {
               let realm = try! Realm()
               try! realm.write {
                        consent.transmitted = true
                     }
     progressView.progress = 0.9
     print ("Written transmitted")
    }
    else{
        progressView.progress = 0.9
        print(erorr.debugDescription)
    }

}




func TreadSafeMySendCosnetsItems  (dictObj: JSON,consent: ConsentBits,realm: Realm)
   {
       
       let M_URL = "https://wcbsearch.swan.ac.uk/test/api/Consent/"

       let defaults = UserDefaults.standard
       let token = defaults.string(forKey: "token")
       

       let header: HTTPHeaders = [
           "Authorization" :  "bearer " + token!
       ]

       
       let encoder = JSONEncoder()
       let jsonData = try! encoder.encode(dictObj)
       
       
       let url = URL(string: M_URL)
       var request = URLRequest(url: url! )
       request.httpMethod = HTTPMethod.post.rawValue
       request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
       request.httpBody = jsonData
       
       
           Alamofire.request(request).responseJSON { response in
           switch response.result {
           case .success(let value):
              let swiftyJson = JSON(value)
              if ( swiftyJson != nil)
               {
                   print ("finish alamofire call " )
                             //let realm = try! Realm()
                   try! realm.write {
                               consent.transmitted = true
                        }
                   print ("Written transmitted")
               }
           case .failure(let error):
               print("Failure")
               print(error)
               //TreadSafecompletionHandler(jasonValue: nil, erorr: error, consent: consent, realm: realm)
           }
       }
       
   }








// check what this does
   
func ProcessSendTable() -> Bool
{
    print ("In Process table ========")
    var arrayJson: [JSON] = []


    
    let realm = try! Realm()
    for consent in realm.objects(ConsentBits.self).filter("transmitted != YES") {
                 print(" In  begin synch !")
                 print ("Realm consent name printed ========")
                 print(consent.familyName)
                              /// create array of consent items
                  let prodArray:NSMutableArray = NSMutableArray()
                  for x in consent.consentItems{
                        let para:NSMutableDictionary = NSMutableDictionary()
                         para.setValue(x.value , forKey: "value")
                         para.setValue(String(x.confirmItemId), forKey: "confirmItemId")
                         para.setValue(String(x.allowNo) , forKey: "allowNo")
                         prodArray.add(para)
                        
                    }
                   let extraDetailsArray:NSMutableArray = NSMutableArray()
                   for x in consent.PatientDetails{
                        let para:NSMutableDictionary = NSMutableDictionary()
                        para.setValue(x.Value , forKey: "Value")
                        para.setValue(String(x.DetailTypeId), forKey: "DetailTypeId")
                    para.setValue(String(x.Name), forKey: "Name")

                        extraDetailsArray.add(para)
                    }
                    
        let originalJSON:JSON = ["familyName": consent.familyName as! String , "givenName": consent.givenName as! String ,"Sig1": consent.sig1 ,"Sig2": consent.sig2 ,"trialId": consent.trialId , "staffId": consent.staffId , "date": consent.date as! String ,"consentItems": prodArray, "PatientDetails": extraDetailsArray, "personId": consent.personID , "deviceId":  consent.deivceId , "consenterEmail": consent.consenterEmail]
                       print(originalJSON)
                       arrayJson.append(originalJSON)
                      if arrayJson.count > 0 {
                          TreadSafeMySendCosnetsItems(dictObj: arrayJson[0], consent: consent, realm: realm)
                            return true
                            }
                      }
    return false
}
    


