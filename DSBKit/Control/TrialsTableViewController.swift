//
//  TrialsTableViewController.swift
//  MSconsenter
//
//  Created by Daniel Naeh on 04/10/2019.
//  Copyright © 2019 Eldergen. All rights reserved.
//

import UIKit
import ResearchKit
import Alamofire
import SwiftyJSON
import CoreData
import RealmSwift
import Realm


//CustomMessageCell
//MessageCell
//customMessageCell


class TrialsTableViewController: UITableViewController ,
ORKTaskViewControllerDelegate {
   
     var progressView = UIProgressView()
     let consentDocument = ORKConsentDocument()

    var trials:  Results<Trial>?
    var versions  = List<Int32>()
    var currentTrial: Trial = Trial()
    // intialise trial list



    
     override func viewDidLoad() {
        super.viewDidLoad()
        // do any additional setup loading
      
        loadTrials()
        tableView.register(UINib(nibName: "MessageCell" , bundle: nil), forCellReuseIdentifier: "customMessageCell")
    }
    
     
     func loadTrials() {
         
     
        let realm = try! Realm()
        trials  = realm.objects(Trial.self)
        for trial in trials! {
          let version = (realm.objects(Version.self).filter("TrialId == \(trial.TrialId)").max(ofProperty: "VersionId") as Int32? ?? 0)
          versions.append(version)
        }
        
        
        tableView.reloadData()
         
     }
    
    
    
    
    
    override func  tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trials?.count ?? 1
    }
    
    
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    
     let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
        
    //let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoIteamCell", for: indexPath)
    
    
       if let trial = trials?[indexPath.row] {
        
      // get version
          let realm = try! Realm()
          let version = (realm.objects(Version.self).filter("TrialId == \(trial.TrialId)").max(ofProperty: "VersionId") as Int32? ?? 0)
         //cell.textLabel?.text = (" \(trial.Name)  (v\(version))")
        
         cell.messageBody?.text = (" \(trial.Name)  (v\(version))")
         let data = Data(base64Encoded: trial.Logo, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)!
         cell.avatarImageView.image = UIImage(data: data)
        
        // cell.backgroundColor = categoryColour
       // cell.textLabel?.textColor = ContrastColorOf(categoryColour, returnFlat: true)
        
    }
    
       
       // cell.textLabel?.text = itemArray[indexPath.row]
       // cell.detailTextLabel?.text = "Some detail"
        return cell
    
    
    
    }
    
    
    
    
    
    
    
     func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
            if reason == .completed {
                    SaveMyRealmData(taskViewController: taskViewController, consentDocument: consentDocument,curTrial: currentTrial)
                   }
            taskViewController.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    @IBAction func RefreshTrialClick(_ sender: Any) {
         
        
        //  Just create your alert as usual:
         let alertView = UIAlertController(title: "Please wait", message: "Downloading consent files.", preferredStyle: .alert)
         let upLoadaction = UIAlertAction(title: "Uplaod", style: .default) { (action) in
                
          
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
                                  MySendCosnetsItems(dictObj: arrayJson[0], consent: consent, progressView: self.progressView)                    }
                              }
            
                }
        alertView.addAction(upLoadaction)
        alertView.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        //  Show it to your users
        present(alertView, animated: true, completion: {
            let margin:CGFloat = 8.0
            let rect = CGRect(x: margin, y: 72.0, width: alertView.view.frame.width - margin * 2.0 , height: 2.0)
            self.progressView = UIProgressView(frame: rect)
            self.progressView.progress = 0.5
            self.progressView.tintColor = self.view.tintColor
            alertView.view.addSubview(self.progressView)
        })
        
        

                     

        
    }
    
    

    

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          
       
       
        if let trial = trials?[indexPath.row] {
            
        currentTrial = trial
        if trial.TrialId == 13
        {
                    let survey = ATSurveyTask().makeTask()
                     showTask(survey)
        }
        else
        {
                    let versionId = versions[indexPath.row]
                    let taskViewController = CreateConsentDocumnet(consentDoc: consentDocument, trialId: trial.TrialId, versionId: versionId)
                    taskViewController.delegate  = self
                    present(taskViewController, animated: true, completion: nil)
                    //SaveMyRealmData(taskViewController: taskViewController,consentDocument: consentDocument)
            }

            

        }
        //performSegue(withIdentifier: "ShowDetails", sender: self)
        
    }
        
        
   
       private func showTask(_ task: ORKTask) {
         let taskViewController = ORKTaskViewController(task: task, taskRun: nil)
         taskViewController.delegate = self
         present(taskViewController, animated: true, completion: nil)
     }
    
    
}
