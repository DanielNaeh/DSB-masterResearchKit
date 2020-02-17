//
//  Consent.swift
//  MSconsenter
//
//  Created by Daniel Naeh on 16/10/2019.
//  Copyright © 2019 Eldergen. All rights reserved.
//


import UIKit
import ResearchKit
import Alamofire
import SwiftyJSON
import RealmSwift

public func CreateConsentDocumnet  (consentDoc: ORKConsentDocument,trialId: Int32, versionId: Int32) -> ORKTaskViewController
{
    
            let consentDocument =  consentDoc

            let consentSections =  createConsentSectionsInfoSheet(trialId: trialId)
    
             consentDocument.sections = consentSections

             consentDocument.addSignature(ORKConsentSignature(forPersonWithTitle: nil, dateFormatString: nil, identifier: "UserSignature"))
             
    
             var steps = [ORKStep]()
             let visualConsentStep = ORKVisualConsentStep(identifier: "VisualConsent", document: consentDocument)
             steps += [visualConsentStep]
            
             let confirmSteps =   createConfirmSteps( trialId: trialId, versionId: versionId)
             for confirmStep in confirmSteps{
                    steps += [confirmStep]

             }

             consentDocument.htmlReviewContent = buildReviewConfirmSteps(trialId: trialId, versionId: versionId)
    
             // consentDocument.signaturePageTitle = NSLocalizedString("Consent", comment: "")
             // consentDocument.signaturePageContent = NSLocalizedString("I agree to participate in the follow research study.", comment: "")
           
             
             let signature = consentDocument.signatures!.first as! ORKConsentSignature
      
    
             let reviewConsentStep = ORKConsentReviewStep(identifier: "Review", signature: signature , in: consentDocument)
    
    
    
    
    
    
             reviewConsentStep.title = "Please enter your name"
             reviewConsentStep.text =  ""//  "I  agree to perform, WCB research."
             reviewConsentStep.reasonForConsent =   "" //WCB research is important."
             //reviewConsentStep.useSurveyMode = true
             steps += [reviewConsentStep]

//                   let step1 = ORKInstructionStep(identifier: "step1")
//                    step1.title = "Signature Step";
//                    step1.text = "Example of an ORKSignatureStep";
//                    steps += [step1]
//
//                    let signatureStep = ORKSignatureStep (identifier: "signatureStep")
//                    signatureStep.title = "Signature Step";
//                      steps += [signatureStep]
//                    let  stepLast = ORKCompletionStep(identifier: "lastStep")
//                    stepLast.title = "Task Complete";
//                    steps += [stepLast]
    
             let sigStep =  ORKSignatureStep(identifier: "Sig2")
             sigStep.title = "Please return tablet to Nurse/Consenter"
             sigStep.text = "PI sign here"
             steps += [sigStep]
             
             //extra fields like wcbnum
             let  extraTrialFields =  createTrialSpecificFields( trialId: trialId)
             for extraTrialField in extraTrialFields{
                          steps += [extraTrialField]
            }
    
             
             //Completion
             let completionStep = ORKCompletionStep(identifier: "CompletionStep")
             completionStep.title = "Complete Conset"
             completionStep.text = "Thank you for consenting for the Wales Cancer Bank. Press done to complete"
             completionStep.image = UIImage.init(named: "Universal")
             steps += [completionStep]
             
             let orderedTask = ORKOrderedTask(identifier: "Join", steps: steps)
             let taskViewController = ORKTaskViewController(task: orderedTask , taskRun: nil)
             return (taskViewController)
      
  }





func createTrialSpecificFields(trialId: Int32) -> [ORKStep]{
    var stp = [ORKStep]()
    let realm = try! Realm()
    for trialPatientDetailTypeMap in realm.objects(TrialPatientDetailTypeMap.self).filter("TrialId == \(trialId) ").sorted(byKeyPath: "Position", ascending: true) {
        
        for patientDetailTypeMap in realm.objects(PatientDetailType.self).filter("PatientDetailTypeId == \(trialPatientDetailTypeMap.DetailTypeId) ") {
            
            if (patientDetailTypeMap.DetailType == 1  || patientDetailTypeMap.DetailType == 2)
            {
                let questionStep1 = ORKQuestionStep(identifier: "ExtF" + String(patientDetailTypeMap.PatientDetailTypeId))
                questionStep1.title =  NSLocalizedString(patientDetailTypeMap.Name, comment: "")
               // questionStep1.text =   patientDetailTypeMap.Name
                questionStep1.answerFormat = ORKTextAnswerFormat()
                questionStep1.isOptional = false;
                stp.append(questionStep1)

            }
            else if patientDetailTypeMap.DetailType == 3                  {
                           
                let questionStep1 = ORKQuestionStep(identifier: "ExtF" + String(patientDetailTypeMap.PatientDetailTypeId))
                questionStep1.title =  NSLocalizedString(patientDetailTypeMap.Name, comment: "")
                //questionStep1.text =   patientDetailTypeMap.Name
                if patientDetailTypeMap.Name.uppercased() == "SEX"
                {
                   questionStep1.answerFormat = ORKBooleanAnswerFormat(yesString: "Female", noString: "Male")
                }
                else
                {
                   questionStep1.answerFormat = ORKBooleanAnswerFormat()
                }
                questionStep1.isOptional = false;
                stp.append(questionStep1)
                            
            }
            else if patientDetailTypeMap.DetailType == 4
            {
                var defaultDate = Date()

                let calendar = Calendar(identifier: .gregorian)

                
                var components = DateComponents()

                let  minDate  = Calendar.current.date(byAdding: .year, value: -100, to: Date())
                let maxDate = Calendar.current.date(byAdding: .year, value: -18, to: defaultDate)

                let nameQuestionStepTitle = NSLocalizedString(patientDetailTypeMap.Name, comment: "")
                let dateAnswer = ORKDateAnswerFormat(style:ORKDateAnswerStyle.date, defaultDate: nil, minimumDate: minDate, maximumDate: maxDate , calendar: nil)
                let questionStep1 = ORKQuestionStep(identifier: "ExtF" + String(patientDetailTypeMap.PatientDetailTypeId), title:nameQuestionStepTitle, answer: dateAnswer)
                stp.append(questionStep1)
                questionStep1.isOptional = false;
            }
            
            else if patientDetailTypeMap.DetailType == 6
            {
               let choices = [
                 ORKTextChoice(text: "V7", value: 2 as! Int as NSCoding & NSCopying & NSObjectProtocol),
                 ORKTextChoice(text: "V8", value: 3 as! Int as NSCoding & NSCopying & NSObjectProtocol),
                 ORKTextChoice(text: "V9", value: 4 as! Int as NSCoding & NSCopying & NSObjectProtocol),
                ]
               let answerFormat: ORKAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: choices) as! ORKAnswerFormat
               let questionStep1 = ORKQuestionStep(identifier: "ExtF" + String(patientDetailTypeMap.PatientDetailTypeId), title: NSLocalizedString(patientDetailTypeMap.Name, comment: ""), answer: answerFormat)
               questionStep1.isOptional = false
               stp.append(questionStep1)
            }
            
            
        }
    }
     return stp
    
    
}



func createConfirmSteps(trialId: Int32, versionId: Int32) -> [ORKStep]{
    var stp = [ORKStep]()
    let realm = try! Realm()
    for confirmItem in realm.objects(ConfirmItem.self).filter("TrialId == \(trialId) AND  VersionId == \(versionId) ") {


//        let questionStep = ORKQuestionStep(identifier: confirmItem.Name)
//        //questionStep.question = NSLocalizedString(confirmItem.Text, comment: "")
//        questionStep.title =  NSLocalizedString(confirmItem.Text, comment: "")
//        questionStep.text =   "consent only valid if yes"
//        questionStep.answerFormat = ORKBooleanAnswerFormat()
//        questionStep.answerFormat?.isAnswerValid(with: "true")
//        questionStep.isOptional = false
//        stp.append(questionStep)

        let questionStep1 = ORKQuestionStep(identifier: "\(confirmItem.ConfirmItemId)")
        questionStep1.title =  NSLocalizedString(confirmItem.Text, comment: "")
        questionStep1.text =   "Consent is valid only if agree"
        if confirmItem.AllowNo != true
        {
          questionStep1.answerFormat = ORKTextChoiceAnswerFormat(style: .multipleChoice, textChoices: [ORKTextChoice(text: "Yes", value: 1 as NSCoding & NSCopying & NSObjectProtocol)])
        }
        else
        {
            questionStep1.answerFormat = ORKBooleanAnswerFormat()
        }
       
       
          questionStep1.isOptional = false
          stp.append(questionStep1)
        
        }
    
    return stp
}

func buildReviewConfirmSteps(trialId: Int32, versionId: Int32) -> String {
    var  htmlString: String = ""
    let realm = try! Realm()
    for confirmItem in realm.objects(ConfirmItem.self).filter("TrialId == \(trialId) AND  VersionId == \(versionId) ") {
       
        
        if confirmItem.AllowNo != true
        {
              htmlString  = htmlString  + " <li>" + NSLocalizedString(confirmItem.Text, comment: "") + "</li> </hr> </br>"
         }
        
    }

    return   "<html>" + htmlString + "</html>"
}



func createConsentSectionsInfoSheet (trialId: Int32) -> [ORKConsentSection]
{
    var ORKConsentSectionArr = [ORKConsentSection]()
    
    
    let realm = try! Realm()
    var custome =  ORKConsentSectionType.overview
     for trialSection in realm.objects(TrialSection.self).filter("TrialId == \(trialId) ")
     {
  
        for sectionResoucre  in realm.objects(SectionResource.self).filter("PageId == \(trialSection.SectionId) AND Description != '' ")
        {
       
            
            let ORKsection = ORKConsentSection(type: custome)
            if (sectionResoucre.SectionType  == "Text" || sectionResoucre.SectionType  == "image")
            {
            
                ORKsection.customLearnMoreButtonTitle = "Click to read Information"
//                ORKsection.contentURL =  Bundle.main.url(forResource: "consentitems", withExtension: "html")//
              
                ORKsection.title = sectionResoucre.Description
                ORKsection.summary = sectionResoucre.Text
                ORKsection.content = sectionResoucre.Text
                
            }
            if sectionResoucre.SectionType  == "html"
                  
                       {
                        ORKsection.title = sectionResoucre.Description
                        ORKsection.htmlContent = sectionResoucre.Text
                        
                       }
            ORKConsentSectionArr.append(ORKsection)
            break
        }

        custome =  ORKConsentSectionType.custom
    }
    
    return ORKConsentSectionArr
    
}


         
// let htmlFile = Bundle.main.path(forResource:"81", ofType: "html")
// let htmlString = try? String(contentsOfFile: htmlFile!, encoding: String.Encoding.utf8)


//             do {
//                 guard let filePath = Bundle.main.path(forResource: "consentitems", ofType: "html" )
//                     else {
//                         // File Error
//                         print ("File reading error")
//                         throw NSError(domain: "could not create consecont document", code: 42, userInfo: ["ui1":12, "ui2":"val2"] )
//                 }
//
//                 let contents =  try String(contentsOfFile: filePath, encoding: .utf8)
//
//                 consentDocument.htmlReviewContent = contents as String
//
//
//             }
//             catch {
//                 print ("File HTML error")
//             }
       
    
    
             
    
    
    
    
            //consentDocument.htmlReviewContent = "<p><h1>Scousi</h1></p>"
