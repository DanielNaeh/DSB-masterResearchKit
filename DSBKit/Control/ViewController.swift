//
//  ViewController.swift
//  MSconsenter
//
//  Created by Daniel Naeh on 21/08/2019.
//  Copyright © 2019 Eldergen. All rights reserved.
//

import UIKit
import ResearchKit
import Alamofire
import SwiftyJSON
import RealmSwift
import Realm



class ViewController: UIViewController, ORKTaskViewControllerDelegate {
    
    let consentDocument = ORKConsentDocument()
    let CONSENT_URL = "https://wcbsearch.swan.ac.uk/test/api/Consent/131"
    let M_URL = "https://wcbsearch.swan.ac.uk/test/api/Consent/"
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
     getToken  ()
        

        
    }

    
    @IBAction func MsSynch(_ sender: Any) {
        
    print(" In synch !")
        
    var arrayJson: [JSON] = []

    let realm = try! Realm()
    for consent in realm.objects(ConsentBits.self).filter("transmitted != YES") {
                print ("Realm consent name printed ========")
                print(consent.familyName)
                let originalJSON:JSON = ["familyName": consent.familyName as! String , "givenName": consent.givenName as! String ,"Sig1": consent.sig1 , "trialId": consent.trialId , "staffId": consent.staffId , "date": consent.date as! String]
                    arrayJson.append(originalJSON)
        self.sendCosnetsItems(dictObj: arrayJson[0],consent: consent)
        }
      
    }
    
    @IBAction func msConsentBtnClick(_ sender: Any) {
        

        let taskViewController = CreateConsentDocumnet(consentDoc: consentDocument, trialId: 1 , versionId: 21)
         taskViewController.delegate  = self
         present(taskViewController, animated: true, completion: nil)
      
    }
    
    
     func CreateConsent()
       {
           let sectionTypes: [ORKConsentSectionType] = [
                      .overview,
                      
                      // .dataGathering,
                      //  .privacy,
                      // .dataUse,
                      // .timeCommitment,
                      //.studySurvey,
                      // .studyTasks,
                      .custom,
                      .custom,
                      .custom,
                      .custom,
                      .custom,
                      .custom,
                      .custom,
                      .custom,
                      .custom,
                      .custom,
                      .custom,
                      .custom,
                      .custom
                    
                      
                  ]

                  

                  let customSectionArray = ["Overview",
                                            "What is a Biobank?",
                                            "Why have I been chosen?",
                                            "Do I have to take part?",
                                           "What will happen to me if I take part?",
                                           "What do I have to do?",
                                           "What are the advantages and disadvantages of taking part?",
                                           "What if new information becomes available as a result of the research?",
                                           "What happens if the biobank closes?",
                                           "Will my taking part be confidential?",
                                           "What will happen to the results of the research study?",
                                           "Who is organising and funding the biobank?",
                                           "Who has approved/reviewed the biobank?",
                                           "Other research"
                  ]
                  // let numberOfSections = sectionTypes.count;
                  
                  var i : Int = 0
                  var consentSections: [ORKConsentSection] = sectionTypes.map { contentSectionType in
                      let consentSection = ORKConsentSection(type: contentSectionType)
                      
                      
                      if (consentSection.type == .custom )
                      {
                          //consentSection.title = customSectionArray[i]
                          
                          
                          //if  (consentSection.type == .custom )
                          //{
                          //    consentSection.title = customSectionArray[i]
                              ////consentSection.summary =   String(i) +  " n this study you will be asked five (wait, no, three!)"
                             //// consentSection.content = "In this study you will be asked five (wait, no, three!) questions. You will also have your voice recorded for ten seconds."
                          //    consentSection.customLearnMoreButtonTitle = " Please read to learn more"
                          
                           //   let htmlFile = Bundle.main.path(forResource:"81", ofType: "html")
                           //  let htmlString = try? String(contentsOfFile: htmlFile!, encoding: String.Encoding.utf8)
                             // //print(htmlString!)
                             // consentSection.htmlContent = htmlString
                         // }
                          //else
                          
                          consentSection.omitFromDocument = true
                          consentSection.title = customSectionArray[i]
                          if (i == 1)
                          {
                              
                              //consentSection.contentURL = nil //NSURL.fileURL(withPath: "https://www.walescancerbank.com/patient-information-sheet.htm")
                              //consentSection.content = nil
                              //conesnt.title = nil                    //let fileUrl = URL(string: "https://www.walescancerbank.com/patient-information-sheet.htm")
                              //consentSection.contentURL = fileUrl
                              //consentSection.customLearnMoreButtonTitle = "learn more"
                              //consentSection.htmlContent = "<p>Test</p>"
                              
                          
                              consentSection.summary =     " A biobank is an organisation that collects and stores biological samples (tissue, blood, urine etc) and data and makes them available to researchers to learn more about how conditions and diseases start, develop and how to treat them. The Wales Cancer Bank is a biobank that collects such samples from patients throughout Wales. The biobank supports research into cancer by making samples available to scientists involved in cancer research."
                              
                                  consentSection.content = "Custom leave the survey"
                              
                          
                          }
                          else if(i == 2 )
                          {
                               consentSection.summary =     "Patients in Wales who are having, or who have had tissue removed during surgery or a biopsy procedure, may be invited to take part. The bank would like to collect both normal tissue and cancer tissue from patients and so your tissue, blood and other samples will be useful for cancer research whether or not you cancer."
              
                          }
                          else if(i == 3 )
                          {
                              consentSection.summary = "No. The choice to allow us to collect samples and data from you for this project is up to you. If you decide to take part, you can keep this information sheet and you will also be asked to sign a consent form. If you decide to take part, you are still free to change your mind at any time and without giving a reason. If you change your mind a long time after your consent, some of your samples may already have been used for research but we will destroy any samples we may still have in storage. However, we will keep any information we have collected so that researchers who have already used your samples can complete their research. Whatever your decision, it will not affect any part of your treatment or other care you will receive, now or in the future."
                          }
                              
                          else if(i == 4 )
                          {
                              consentSection.summary = "You are about to have, or have had, some tests for your illness, including for example, blood tests, an operation or biopsy procedure. These procedures often involve the removal of fluids, pieces of tissue or even a whole organ. These samples are sent to a laboratory to be tested by scientists and doctors. This can help them diagnose your medical condition. All of the tissue and/or fluids may not be needed for a full and accurate diagnosis - this may leave some that could be used for research that, under normal circumstances, would be thrown away. If you agree to donate to the biobank, any tissue or fluid that is not needed for your diagnosis can be stored and used for research. If you are having a biopsy procedure, two or three extra samples may be taken for the biobank which may mean the procedure will take a few extra minutes. If you have already had your operation you can still take part in this research by giving us permission to ask the pathologist for a small amount of tissue originally used for your diagnosis. In either case the utmost care will be taken to ensure that any material provided would not affect your future health or care. \n \n " +
                                 "As part of your treatment, your hospital doctor will normally take a routine blood sample from you. We would like your consent to take an additional amount (approximately 4-8 teaspoons, 20-40ml) that will be used for research. If you have specific questions about this, please ask the person taking your consent  \n \nAfter your current treatment, your hospital doctor may invite you back for further visits and this may involve other samples being taken. If, at a later stage, you have tissue samples taken as part of your further care we may wish to access left over samples and take a small amount of additional blood. These optional additional blood samples may be requested at a time when you would not be having blood taken for clinical purposes. This will allow researchers to make potentially helpful comparisons with your original samples.\n \n " +
                              "Under data protection law we have to specify the legal basis that we are relying on to process your personal data. In providing your personal data for this research we will process it on the basis that doing so is necessary for our public task for scientific and historical research purposes in accordance with the necessary safeguards, and is in the public interest. Cardiff University, specifically Wales Cancer Bank staff, will collect information about you for the biobank records from your NHS medical records. This information will include your name/NHS number/contact details/date of birth and health information, which is regarded as a special category of information. We will use your personal information (name, address, NHS number, date of birth) to make sure we are matching the correct medical record to the correct donated samples. Any information related to your diagnosis and treatment will be treated in the strictest confidence. Researchers using samples and data  from the Wales Cancer Bank will NOT receive your personal information."
                      
                          }
                          else if(i == 5 )
                          {
                              consentSection.summary = "You will need to give your written consent to donate your samples and allow us access to data by signing a simple form. This may be a paper form or an electronic form on a computer tablet device."
                          }
                              
                          else if(i == 6 )
                          {
                              consentSection.summary = "Blood, tissue and fluid samples are taken as part of your operation and your routine treatment and care. The tissue samples taken for the biobank will only be taken after all of the necessary clinical tests have been carried out on them. Therefore, taking part in this project will have no disadvantages.\n\nYou may not benefit personally from the research but the results of the research using your samples, and those from others, may benefit cancer patients in the future. For example, DNA from your samples may be used by researchers for genetic testing which could help to identify factors that influence the development and treatment of cancer. Your tissue will not be used for research that involves reproductive cloning. Your tissue or blood samples may be used for research that may lead to the development of new drugs or treatments. The research may be carried out in Academic Institutions, the NHS or commercial companies involved in cancer research in the UK or abroad.\n\nResearch studies accessing samples will be approved and monitored by a review panel of experts. Researchers sign an agreement to limit the use of your donated samples only to the research approved by the panel. Products of that research may be used in later, different research that is in line with the consent you have given. \n\nYou are asked to donate your samples to the biobank for research and will not receive a financial reward either now or in the future. The medical team involved in your treatment and care will receive no payment because of your involvement in this study. The Wales Cancer Bank is a not-for-profit organisation, but a fee may be charged to researchers using the samples to help recover some of the costs involved in maintaining the biobank."
                          }
                              
                          else if(i == 7 )
                          {
                              consentSection.summary = "Results for individual patients from research studies will not normally be relayed back to you or your doctor. Very occasionally, some research projects could identify genetic changes that may indicate an inherited disease that may affect you or your family members. For more detailed information please see the website at www.walescancerbank.com/for-patients. Your hospital doctor will be notified if any information that becomes known as a result of the research may affect you or your family's future care. We are unable to contact you directly regarding research results."
                          }
                          else if(i == 8 )
                          {
                              consentSection.summary = "Should the biobank close, the information and samples collected from it will become the responsibility of the NHS Wales."
                          }
                          else if(i == 9 )
                          {
                              consentSection.summary = "Yes. All data collected will be held on secure, password protected systems and will be kept confidential. Cardiff University is responsible for this project (the Wales Cancer Bank) based in the United Kingdom. We will be using information from you and/or your medical records in order to undertake this project and will act as the data controller for this project. This means that we are responsible for looking after your information and using it properly. Cardiff University will keep identifiable information about you for 15 years after the project has finished. Your rights to access, change or move your information are limited, as we need to manage your information in specific ways in order for the research to be reliable and accurate. If you withdraw from the project, we will keep the information about you that we have already obtained. To safeguard your rights, we will use the minimum personally-identifiable information possible."
                          }
                          else if(i == 10 )
                          {
                              consentSection.summary = "Research studies usually take several years to complete. The results from the studies using the donated samples will be used to improve treatment and care of patients in the future. Results will be published as appropriate in the scientific papers and magazines and regular updates of research in progress, research results and other relevant information will be published on the biobank's website\n (www.walescancerbank.com). In the future we would like to make the results of the scientific tests carried out on all our donors' samples available to researchers through a website. Access to this information will be secure and only researchers who have permission from the Wales Cancer Bank will be allowed access to this website. All information will be anonymised and therefore you will not be identified in any publication or from information available through the website.\n\nIf you wish to receive newsletters and biobank updates electronically, please provide your email address in the space on the consent form."
                          }
                              
                          else if(i == 11 )
                          {
                              consentSection.summary = "This is a project run in collaboration with NHS Wales and supported and paid for by the Welsh Government, Velindre NHS Trust and Cancer Research UK."
                          }
                          else if(i == 12 )
                          {
                              consentSection.summary = "The Wales Research Ethics Committee 3 has approved, and will regularly review the biobank (Wales REC 3, Castlebridge 4, 15-19 Cowbridge Road East, Cardiff, CF11 9AB)." +
                              "\n\nWales Cancer Bank is licensed by the Human Tissue Authority (licence 12107) under the UK Human Tissue Act (2004) to store human samples for research purposes."
                          }
                          else if(i == 13 )
                          {
                              consentSection.summary = "If, as a result of studies performed on your biological samples, you are eligible for a research study that might be beneficial to you, you doctor may contact you with more information. These studies will be unrelated to the biobank and may, for example, be a clinical trial. You do not have to take part in any of the studies if you do not wish to, and your medical treatment will be unaffected by your decision. \n\n" +     "You may be interested in other activity that is taking place in Wales to help health and social research (please note this will not necessarily be cancer related), such as Healthwise Wales (www.healthwisewales.gov.wales). If you are happy to be contacted by researchers, please indicate this on the consent form and include an email address. Your name and email address will be the only information that we will share with these researchers.\n\n" +
                                  "Thank you very much for taking the time to read this information. Should you agree to take part in this project, your generosity is much appreciated."
                          }

                          
                          else
                          {
                              consentSection.title = customSectionArray[i]
                          consentSection.summary =   String(i) +  " n this study you will be asked five (wait, no, three!)"
                          consentSection.content = "In this study you will be asked five (wait, no, three!) questions. You will also have your voice recorded for ten seconds."
                          consentSection.customLearnMoreButtonTitle = " Please read to learn more"
                          
                          consentSection.content = nil
                          let htmlFile = Bundle.main.path(forResource:"81", ofType: "html")
                          let htmlString = try? String(contentsOfFile: htmlFile!, encoding: String.Encoding.utf8)
                          print(htmlString!)
                          consentSection.htmlContent = htmlString
                          
                          //consentSection.contentURL = NSURL.fileURL(withPath: "http://example.com/file/example.pdf")
                          
                          //let fileUrl = URL(string: "https://wcbsearch.swan.ac.uk/")
                          //consentSection.contentURL = fileUrl
                          
                          //consentSection.customImage = UIImage(named: "bitcoin")!.withRenderingMode(.alwaysTemplate)
                          }
                      }
                      else
                      {
                          if (consentSection.type == .overview)
                          {
                           
                            
                              consentSection.title = "Patient Information Sheet (v15)"
                              consentSection.summary = "We are inviting you to take part in research by donating samples to a biobank called the Wales Cancer Bank. Before you decide whether to take part, it is important for you to know why the biobank has been set up a dn what taking part will involve for you. Please take time to read the following information carefully and discuss it with your family, friends or your GP, if you wish."
                          }
                          else if (consentSection.type == .withdrawing)
                          {
                               consentSection.summary = "You are not allowed to withdraw"                }
                          else if (consentSection.type == .privacy)
                          {
                              
                              
                          }
                          
                          
                          

                      }
                      //consentSection.image =  UIImage(named: "Universal")!.withRenderingMode(.alwaysTemplate)
                      i = i + 1
                      return consentSection
                  }
                  
                  let htmlFile = Bundle.main.path(forResource:"81", ofType: "html")
                  let htmlString = try? String(contentsOfFile: htmlFile!, encoding: String.Encoding.utf8)
                 consentDocument.sections = consentSections
                  
                  do {
                      guard let filePath = Bundle.main.path(forResource: "81", ofType: "html")
                          else {
                              // File Error
                              print ("File reading error")
                              return
                      }
                      
                      let contents =  try String(contentsOfFile: filePath, encoding: .utf8)
                      consentDocument.htmlReviewContent = contents as String
                  }
                  catch {
                      print ("File HTML error")
                  }
            
                  
                  //consentDocument.htmlReviewContent = "<p><h1>Scousi</h1></p>"
                  consentDocument.addSignature(ORKConsentSignature(forPersonWithTitle: nil, dateFormatString: nil, identifier: "UserSignature"))
                  var steps = [ORKStep]()
                  //Visual Consent
                  let visualConsentStep = ORKVisualConsentStep(identifier: "VisualConsent", document: consentDocument)
                  steps += [visualConsentStep]
                  
                   // consentDocument.makeCustomPDF(with: <#T##ORKHTMLPDFPageRenderer#>, completionHandler: <#T##(Data?, Error?) -> Void#>)
                  
                  
                  // let step = ORKQuestionStep(identifier: "yes-no-step")
                  //step.title = NSLocalizedString("Do you feel good?", comment: "")
                  //step.answerFormat = ORKBooleanAnswerFormat()
                  
                  //steps += [nameQuestionStep]
                  
                  let questionStep1 = ORKQuestionStep(identifier: "confirmItem1")
                  questionStep1.title = NSLocalizedString("I confirm that I have read, understood and have had time to consider the information sheet version number 15 for the Wales Cancer Bank and have had the opportunity to ask questions.", comment: "")
                 questionStep1.text = NSLocalizedString("I confirm that I have read, understood and have had time to consider the information sheet version number 15 for the Wales Cancer Bank and have had the opportunity to ask questions.", comment: "")
                  questionStep1.answerFormat = ORKBooleanAnswerFormat()
                  questionStep1.isOptional = false
                  steps += [questionStep1]
                  
                  let questionStep2 = ORKQuestionStep(identifier: "confirmItem2")
                  questionStep2.title = NSLocalizedString("I understand that my participation is voluntary and will not affect my medical treatment or legal rights in any way.", comment: "")
                  questionStep2.answerFormat = ORKBooleanAnswerFormat()
                  questionStep2.isOptional = false
                  steps += [questionStep2]
                  
                  
                  let questionStep3 = ORKQuestionStep(identifier: "confirmItem3")
                  questionStep3.title = NSLocalizedString("I understand that sections of my medical notes may be looked at by responsible individuals from the Wales Cancer Bank where it is relevant to the research.  I give permission for these individuals to have access to my records.", comment: "")
                  questionStep3.answerFormat =  ORKTextChoiceAnswerFormat(style: .singleChoice,
                                                                          textChoices: [
                                                                              ORKTextChoice(text: "Yes", value: NSNumber(integerLiteral: 0)),
                                                                              ORKTextChoice(text: "No", value: NSNumber(integerLiteral: 1))])
                  questionStep3.isOptional = false
                  steps += [questionStep3]
                  
                  
                  let questionStep4 = ORKQuestionStep(identifier: "confirmItem4")
                  questionStep4.title = NSLocalizedString("I understand and agree that parts of my medical information may be passed to other organisations involved in the research on the understanding that my personal patient confidentiality will be maintained.", comment: "")
                  questionStep4.answerFormat = ORKBooleanAnswerFormat()
                  questionStep4.isOptional = false
                  steps += [questionStep4]
                  
                  
                  let questionStep5 = ORKQuestionStep(identifier: "confirmItem5")
                  questionStep5.title = NSLocalizedString("I understand, and agree to, data relating to my donated samples being stored electronically.", comment: "")
                  questionStep5.answerFormat = ORKBooleanAnswerFormat()
                  questionStep5.isOptional = false
                  steps += [questionStep5]
                  
                  
                  
                  let questionStep6 = ORKQuestionStep(identifier: "confirmItem6")
                  questionStep6.title = NSLocalizedString("I understand that I personally will not receive results of any research.  However, if any research might have an impact on my care, during my treatment, then I understand that the hospital doctors can be informed.", comment: "")
                  questionStep6.answerFormat = ORKBooleanAnswerFormat()
                  questionStep6.isOptional = false
                  steps += [questionStep6]
                  
                  
                  let questionStep7 = ORKQuestionStep(identifier: "confirmItem7")
                  questionStep7.title = NSLocalizedString("I confirm agreement to donate tissue, blood and/or other samples to the Wales Cancer Bank.",comment: "")
                  questionStep7.answerFormat = ORKBooleanAnswerFormat()
                  questionStep7.isOptional = false
                  steps += [questionStep7]
                  
                  
                  let questionStep8 = ORKQuestionStep(identifier: "confirmItem8")
                  questionStep8.title = NSLocalizedString("I understand that the donated samples may be used for research at any time, either now or in the future, in accordance with Wales Cancer Bank ethically reviewed procedures.", comment: "")
                  questionStep8.answerFormat = ORKBooleanAnswerFormat()
                  questionStep8.isOptional = false
                  steps += [questionStep8]
                  
                  
                  
                  let questionStep9 = ORKQuestionStep(identifier: "confirmItem9")
                  questionStep9.title = NSLocalizedString("I agree that any samples from future procedures may also be used for research under the terms of this consent form.",  comment: "")
                  questionStep9.answerFormat = ORKBooleanAnswerFormat()
                  questionStep9.isOptional = false
                  steps += [questionStep9]
                  
                  let questionStep10 = ORKQuestionStep(identifier: "confirmItem10")
                  questionStep10.title = NSLocalizedString("I know that I can withdraw my consent at any time if I change my mind.", comment: "")
                       questionStep10.answerFormat = ORKBooleanAnswerFormat()
                  questionStep10.isOptional = false
                  steps += [questionStep10]
                  
                  
                  
                  
                  
                  consentDocument.signaturePageTitle = NSLocalizedString("Consent", comment: "")
                  consentDocument.signaturePageContent = NSLocalizedString("I agree to participate in the follow research study.", comment: "")
                  //let participantSignatureTitle = NSLocalizedString("Participant", comment: "")
                
                  
                  let signature = consentDocument.signatures!.first as! ORKConsentSignature
                  
                  
                  let reviewConsentStep = ORKConsentReviewStep(identifier: "Review", signature: signature , in: consentDocument)
                  reviewConsentStep.title = "Please hand consent"
                  reviewConsentStep.text = "I  agree to perform, WCB research."
                  reviewConsentStep.reasonForConsent = "WCB  research is important."
                  //reviewConsentStep.useSurveyMode = true
                  steps += [reviewConsentStep]

                  
              
                  let sigStep =  ORKSignatureStep(identifier: "SigStep")
                  sigStep.title = "PI signature"
                  sigStep.text = "PI sign here"
                  steps += [sigStep]
                  
                  
                  //Completion
                  let completionStep = ORKCompletionStep(identifier: "CompletionStep")
                  completionStep.title = "Finished"
                  completionStep.text = "Thank you for consenting for the Wales Cancer Bank."
                  completionStep.image = UIImage.init(named: "Universal")
                  steps += [completionStep]
                  
                  
                  let orderedTask = ORKOrderedTask(identifier: "Join", steps: steps)
                  let taskViewController = ORKTaskViewController(task: orderedTask , taskRun: nil)
                  taskViewController.delegate = self
                  
                  present(taskViewController, animated: true, completion: nil)
           
       }
       

    
    
    
    
    
    
    

    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
        if reason == .completed {
          SaveRealmData(taskViewController: taskViewController)
        }
        taskViewController.dismiss(animated: true, completion: nil)
    }
    

    
    
    
    func SaveRealmData(taskViewController: ORKTaskViewController)
    {
               
                if let signatureResult = taskViewController.result.stepResult(forStepIdentifier: "Review")?.firstResult
                 as? ORKConsentSignatureResult {
                 // the cast succeeds
                 signatureResult.apply(to: consentDocument)
                 
             
                 print(signatureResult.signature?.familyName ?? "Print 0 ")
                 let fileName = "Sig1"
                 let test = signatureResult.signature?.signatureImage
                 
        
               
                 
                 
                 do {
                     let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                     let fileURL = documentsURL.appendingPathComponent("\(fileName).png")
                     //print (fileURL)
                     
                     //print ("------------Here string image")
                     //print(imageStr)
                     //print(fileURL)
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
                     newItem.familyName = signatureResult.signature?.familyName ?? ""
                     newItem.givenName = signatureResult.signature?.givenName! ?? ""
                     newItem.sig1 = imageStr
                     let formatter = DateFormatter()
                     //formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                     formatter.dateFormat = "dd-MMM-yyyy"
                     let myString = formatter.string(from: Date())
                     let yourDate: Date? = formatter.date(from: myString)
               
                     print ("This is how the date looks like --------------------")
                     print (yourDate! )
                         
                     newItem.trialId = 1
                     newItem.staffId = 2
                     newItem.date = myString
                     newItem.transmitted = false

                    // Get the default Realm
                        
                    let realm = try! Realm()
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
        
          //taskViewController.dismiss(animated: true, completion: nil)

    }
    
    
    
    
    
    
    //https://www.appcoda.com/pdf-generation-ios/
    
    func postConsentBits ( dictObj: [String: AnyObject])
    {
        
        let defaults = UserDefaults.standard
        let token = defaults.string(forKey: "token")
        let header: HTTPHeaders = [
            "Authorization" :  "bearer " + token!
        ]


        
        let data = try! JSONSerialization.data(withJSONObject: dictObj, options: JSONSerialization.WritingOptions.prettyPrinted)
        let json = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        if let json = json {
            print(json)
        }
        
        
        Alamofire.request(request as! URLRequestConvertible)
            .responseJSON { response in
                
                if response .result.isSuccess{
                    // do whatever you want here
                    print(response.request)
                    print(response.response)
                    print(response.data)
                    print(response.result)

                    
                }
                else{
                    print ("theres an err second ")
                }
                
                
     
                
        }
        
    }
    
    
    
    
    func sendCosnetsItems (dictObj: JSON,consent: ConsentBits )
    {
        
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
                print ("finish alamofire call " )
                self.completionHandler(jasonValue: swiftyJson, erorr: nil, consent: consent)
            case .failure(let error):
                print("Failure")
                self.completionHandler(jasonValue: nil, erorr: error, consent: consent)
            }
        }
        
    }
    
    
    
    func completionHandler (jasonValue: JSON?,  erorr: Error?, consent: ConsentBits)
    {
        // succes
        if ((erorr == nil) && (jasonValue != nil))
        {
                   let realm = try! Realm()
                   try! realm.write {
                            consent.transmitted = true
                         }
            print ("Written transmitted")
        }
        else{
                   
            print(erorr.debugDescription)
        }

    
    }
    
    func getConsent ()
    {
        let defaults = UserDefaults.standard
        let token = defaults.string(forKey: "token")
        let header: HTTPHeaders = [
            "Authorization" :  "bearer " + token!
        ]
        
        //print(token)
        Alamofire.request(CONSENT_URL ,method: .get ,headers : header)
            .responseJSON{
                
                response in
                
                if response .result.isSuccess{
                    print ("Success! get consent")
                    let
                    resultJSON : JSON = JSON(response.result.value!)
                    print("Sent -----------------Result")
                    print (resultJSON)
                    
                }
                else{
                    print ("theres an err second ")
                }
        }
        
    }
    
    
    
}

