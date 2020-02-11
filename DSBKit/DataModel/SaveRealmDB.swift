//
//  SaveRealmDB.swift
//  DSBKit
//
//  Created by Daniel Naeh on 20/11/2019.
//  Copyright © 2019 agostini.tech. All rights reserved.
//

import Foundation
import RealmSwift
import ResearchKit

 func SaveMyRealmData(taskViewController: ORKTaskViewController,consentDocument:  ORKConsentDocument, curTrial: Trial)
{
         
        
             if let signatureResult = taskViewController.result.stepResult(forStepIdentifier: "Review")?.firstResult
             as? ORKConsentSignatureResult {
             // the cast succeeds
             //signatureResult.apply(to: consentDocument)
             
         
             print(signatureResult.signature?.familyName ?? "Print 0 ")
             let fileName = "Sig1"
             let test = signatureResult.signature?.signatureImage
             
             
             do {
                 let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                 let fileURL = documentsURL.appendingPathComponent("\(fileName).png")
               
                 if let pngImageData = test!.pngData() {
                     try pngImageData.write(to: fileURL, options: .atomic)
                     
                  // see if can bypass file repe
                 let memImageStr =    test?.pngData()?.base64EncodedString()

                     
                    // print (memImageStr!)
                  //print ("------------passed new imagstr image")

                 let imageData:NSData = NSData.init(contentsOf: fileURL as URL)!
                 let imageStr: String  = imageData.base64EncodedString()
                     
                 // print (imageStr)
 
                     
                     
                let newItem = ConsentBits()
                let confirmItems = List<ConsentBitsItems>()

                 newItem.familyName = signatureResult.signature?.familyName ?? ""
                 newItem.givenName = signatureResult.signature?.givenName! ?? ""
                 newItem.sig1 =  imageStr
                // seconde signature
               
                //Build array of names
           
                
                    
                    
                    //  print ("Second signature------------------->")
                //let taskResult = taskViewController.result // this should be a ORKTaskResult
                let taskResult = taskViewController.result // this should be a ORKTaskResult
                let results = taskResult.results as! [ORKStepResult]//[ORKStepResult]
                
                 //let results = taskViewController.result as! [ORKTaskResult]
                 for thisStepResult in results { // [ORKStepResults]
                                      
                                
                                      let stepResults = thisStepResult.results as! [ORKResult]
                                                    for item in stepResults {
                                                         // print("ITemmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm")
                                                        
                                                          if let answer = item as? ORKSignatureResult {
                                                                    if answer.signatureImage != nil { // still is a swift Bool? (optional Bool)
                                                                    let test2 = answer.signatureImage
                                                                    let memImageStr2 =    test2?.pngData()?.base64EncodedString()
                                                                    newItem.sig2 = memImageStr2!
                                                                     }
                                                           }
                                                        if  item.identifier.contains( "ExtF")
                                                        /// those are extra fields else items
                                                        {
                                                                    if let textResult = item as? ORKTextQuestionResult {
                                                                    if  textResult.textAnswer != nil { // still is a swift Bool? (optional Bool)
                                                                        let  number = textResult.identifier.replacingOccurrences(of: "ExtF", with: "")
                                                                        let value   = textResult.textAnswer!
                                                                        let extraItems = PatientDetailx()
                                                                        extraItems.Value = value
                                                                        extraItems.DetailTypeId = Int32(number) ?? 1
                                                                        newItem.PatientDetails.append(extraItems)
                                                                                                                                }
                                                            }
                                                                     else if let boolResult = item as? ORKBooleanQuestionResult{
                                                                        if  boolResult.booleanAnswer != nil { // still is a swift Bool? (optional Bool)
                                                                         let  number = boolResult.identifier.replacingOccurrences(of: "ExtF", with: "")
                                                                         let extraItems = PatientDetailx()
                                                                         let value   = boolResult.booleanAnswer!.boolValue
                                                                         extraItems.Value = value.description
                                                                         extraItems.DetailTypeId = Int32(number) ?? 1
                                                                         newItem.PatientDetails.append(extraItems)
                                                                                                                                                                                                       }
                                                             }
                                                                        
                                                                    else if let textResult = item as? ORKChoiceQuestionResult {
                                                                    if  textResult.choiceAnswers != nil { // still is a swift Bool? (optional Bool)
                                                                         print ("Choice Question Result ")
                                                                         let  number = textResult.identifier.replacingOccurrences(of: "ExtF", with: "")
                                                                         let value: Int16  = (textResult.choiceAnswers?.first as? Int16)!
                                                                         let extraItems = PatientDetailx()
                                                                         extraItems.Value  = String(value)
                                                                         extraItems.DetailTypeId = Int32(number) ?? 1
                                                                         newItem.PatientDetails.append(extraItems)
                                                                                                                       }
                                                            }
                                                                    else if let textResult = item as? ORKDateQuestionResult {
                                                                    if  textResult.dateAnswer != nil { // still is a swift Bool? (optional Bool)
                                                                       let  number = textResult.identifier.replacingOccurrences(of: "ExtF", with: "")
                                                                       let df = DateFormatter()
                                                                       df.dateFormat = "dd-MM-yyyy"
                                                                       let value = df.string(from: textResult.dateAnswer!)
                                                                       let extraItems = PatientDetailx()
                                                                       extraItems.Value = value
                                                                       extraItems.DetailTypeId = Int32(number) ?? 1
                                                                       newItem.PatientDetails.append(extraItems)
                                                                                                                                }
                                                              }
                                                        }
                                                        else
                                                        {
                                                           if let choiceResult = item as? ORKChoiceQuestionResult {
                                                                      if choiceResult.choiceAnswers?.first != nil { // still is a swift Bool? (optional Bool)
                                                                          let  number =       choiceResult.identifier
                                                                          let value = choiceResult.choiceAnswers!.first!
                                                                          let confirmItem = ConsentBitsItems()
                                                                          confirmItem.value = true
                                                                          confirmItem.confirmItemId = Int32(number) ?? 1
                                                                          confirmItem.allowNo = false
                                                                          newItem.consentItems.append(confirmItem)
                                                                        }
                                                           }
                                                           else if let boolResult = item as? ORKBooleanQuestionResult {
                                                                       if   boolResult.booleanAnswer != nil { // still is a swift Bool? (optional Bool)
                                                                         let  number = boolResult.identifier
                                                                         let value   = boolResult.booleanAnswer!.boolValue
                                                                         let confirmItem = ConsentBitsItems()
                                                                         confirmItem.value = value
                                                                         confirmItem.confirmItemId = Int32(number) ?? 1
                                                                         confirmItem.allowNo = true
                                                                        newItem.consentItems.append(confirmItem)
                                                                                                              }
                                                                         }
                                                        }
                                }
                }
            
                    
                // define data access
                let realm = try! Realm()
                    
                    
                for trialPatientDetailTypeMap in realm.objects(TrialPatientDetailTypeMap.self).filter("TrialId == \(curTrial.TrialId) ")
                {
                     for patientDetailTypeMap in realm.objects(PatientDetailType.self).filter("PatientDetailTypeId == \(trialPatientDetailTypeMap.DetailTypeId) ") {
                               
                    
                                    for  item in newItem.PatientDetails {
                                        if item.DetailTypeId == trialPatientDetailTypeMap.DetailTypeId
                                        {
                                            item.Name = patientDetailTypeMap.Name
                                        }
                        
                            }
                    }
                }
                    
                    
                 let formatter = DateFormatter()
                 //formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                 formatter.dateFormat = "dd-MMM-yyyy HH:mm"
                 let myString = formatter.string(from: Date())
                 let yourDate: Date? = formatter.date(from: myString)
           
                 print ("This is how the date looks like --------------------")
                 print (yourDate! )
            
          
                    
                 newItem.consenterEmail = loggedUser.Email
                 newItem.trialId = curTrial.TrialId
                 newItem.staffId = loggedUser.StaffId
                 newItem.date = myString
                 newItem.transmitted = false
                  
                 // Get the default Realm
                 newItem.deivceId  = UIDevice.current.identifierForVendor?.uuidString ?? "deviceIdMissing"
               
                 print("Realm Path : \(realm.configuration.fileURL?.absoluteURL)")

                    
                    
                    
                    
                try! realm.write {
                    
                    
                    realm.add(newItem)
                       
                    }

                    
         
                }
                 
                 
                 
             } catch {
                 
                 print("Eror")                }
             
         }
         else
         {
             
         }
    

}

