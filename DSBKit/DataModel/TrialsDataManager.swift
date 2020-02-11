//
//  TrialsDataManager.swift
//  MSconsenter
//
//  Created by Daniel Naeh on 02/10/2019.
//  Copyright © 2019 Eldergen. All rights reserved.
//
import Foundation
import RealmSwift
import Alamofire
import SwiftyJSON



class TrialContentManager
    
{

  var listOfDwonlaodedOrganisations: List<Organisation> = List<Organisation>()
  var listOfDwonlaodedPatientDetailTypes: List<PatientDetailType> = List<PatientDetailType>()
  var listOfDwonloadedTrials: List<Trial> = List<Trial>()
  var listofDownloadedConfrimItems: List<ConfirmItem> = List<ConfirmItem>()
  var ListofDownloadedSectionResource: List<SectionResource> = List<SectionResource>()
  var ListOfDownloadedTrialSections:  List<TrialSection> = List<TrialSection>()
  var ListDownloadedVesrion: List<Version> = List<Version>()
  var ListDownloadedSite: List<Site> = List<Site>()
  var ListDownloadedStaffUser: List<StaffUser> = List<StaffUser>()
  var ListDownloadedrialPatientDetailTypeMap: List<TrialPatientDetailTypeMap> = List<TrialPatientDetailTypeMap>()

  public func GetorUpdateTrialData()   {

    print ("before connected !!!!!!!!!!!!!!!!!!!!!")
    let networkStatus = NetworkStatus.sharedInstance
    networkStatus.enquireStatus()
    if  networkStatus.connected
   {


     
    let group = DispatchGroup()
    group.enter()
      getTokenPublic(){
      group.leave()
    }
   
    group.notify(queue: .main) {
     print("task complete!")
        let realm = try! Realm()
                let reg = realm.objects(TablesMetaData.self).filter("tableName == '' " ).first
            if reg == nil  {
                    print ("System initialised localData stroe is empty ")
                
                let succ = self.clearTrialLocalSpace()
                if succ == true
                {
                 self.organsisationController()
                 self.trialController()
                 self.sectionResourceController()
                 self.staffUserController()
                }
            }
            else{
                        print ("Yes Records records ")
                }
        
     // ......
    }
    
    
    
   
    
    
   
        // Here you can notify you Main thread

        
        

    
     
    
       }else {
            print("not connected!!!!!!!!!!!!!!!!!!!!!")

    
    }
}


    

    
    
    
    
    
    
    func clearTrialLocalSpace() -> Bool
    {

        let realm = try! Realm()
        try! realm.write {
            realm.delete(realm.objects(Organisation.self))
            realm.delete(realm.objects(PatientDetailType.self))
            realm.delete(realm.objects(Trial.self))
            realm.delete(realm.objects(ConfirmItem.self))
            realm.delete(realm.objects(SectionResource.self))
            realm.delete(realm.objects(TrialSection.self))
            realm.delete(realm.objects(Version.self))
            realm.delete(realm.objects(Site.self))
            realm.delete(realm.objects(StaffUser.self))
            realm.delete(realm.objects(TrialPatientDetailTypeMap.self))

        }
        return true
      
    }
    
    
    
    func organsisationController()
    {
        
          
          let defaults = UserDefaults.standard
          let token = defaults.string(forKey: "token")

          let header: HTTPHeaders = [
              "Authorization" :  "bearer " + token!
          ]
          let OrganisationController_URL = "https://wcbsearch.swan.ac.uk/test/api/Organisation/"
          
        
                   Alamofire.request(OrganisationController_URL, method: .get,headers : header)
                             .responseJSON{
                                 
                                 response in
                                 
                                 if response .result.isSuccess{
                                    print ("Almamosfire Success! ")
                                    let  resultJSON : JSON = JSON(response.result.value!)
                                    if let items = resultJSON.array {
                                                        for item in items {
                                         
                                                            let jasonItem: JSON = JSON(item)
                                                            self.CreateOrganisation(organisation: jasonItem)
                                                            self.CreatePatientDetailsType(patientDetail: jasonItem)
                                                            self.CreateSites(sites: jasonItem)
                                                            
                                        }//  for items
            
                                    } //  closre if resultJson
                                   let realm = try! Realm()
                                   print( "Try saving now ------> ")
                                   try! realm.write {
                                    realm.add(self.listOfDwonlaodedOrganisations)
                                    realm.add(self.ListDownloadedSite)
                                    realm.add(self.listOfDwonlaodedPatientDetailTypes)
                                                    }
                                    
                                 }  // response success
                                 else{
                                     print ("Almamosfire error ")
                                 }
              

                        }
        
        
        
    }
    
    
    func sectionResourceController()
    {
        
        
          let defaults = UserDefaults.standard
          let token = defaults.string(forKey: "token")
          let header: HTTPHeaders = [
              "Authorization" :  "bearer " + token!
          ]
          let OrganisationController_URL = "https://wcbsearch.swan.ac.uk/test/api/SectionResource/"
          
        
                   Alamofire.request(OrganisationController_URL, method: .get,headers : header)
                             .responseJSON{
                                 
                                 response in
                                 
                                 if response .result.isSuccess{
                                    print ("Almamosfire Success! ")
                                    let  resultJSON : JSON = JSON(response.result.value!)
                                    //print(resultJSON)
                                    if let items = resultJSON.array {
                                                        for item in items {
                                         
                                                            let jasonItem: JSON = JSON(item)
                                                            self.CreateSectionSources(sectionSource:  jasonItem)
                                        }//  for items
            
                                    } //  closre if resultJson
                                     let realm = try! Realm()
                                     print( "Try saving now ------> ")
                                     try! realm.write {
                                                       realm.add(self.ListofDownloadedSectionResource)
                                                      }
                                 }  // response success
                                 else{
                                     print ("Almamosfire error ")
                                 }
              

                        }
        
        
        
    }
    
    func staffUserController()
    {
        
        
          let defaults = UserDefaults.standard
          let token = defaults.string(forKey: "token")
          let header: HTTPHeaders = [
              "Authorization" :  "bearer " + token!
          ]
          let OrganisationController_URL = "https://wcbsearch.swan.ac.uk/test/api/StaffUser/"
          
        
                   Alamofire.request(OrganisationController_URL, method: .get,headers : header)
                             .responseJSON{
                                 
                                 response in
                                 
                                 if response .result.isSuccess{
                                    print ("Almamosfire Success! ")
                                    let  resultJSON : JSON = JSON(response.result.value!)
                                    //print(resultJSON)
                                    if let items = resultJSON.array {
                                                        for item in items {
                                         
                                                            let jasonItem: JSON = JSON(item)
                                                            self.CreateStaffUser(staffUser:  jasonItem)
                                        }//  for items
            
                                    } //  closre if resultJson
                                    let realm = try! Realm()
                                    print( "Try saving now ------> ")
                                     try! realm.write {
                                                       realm.add(self.ListDownloadedStaffUser)
                                                      }
                                    
                                     }  // response success
                                 else{
                                     print ("Almamosfire error ")
                                 }
              

                        }
        
        
        
    }
    
    

    
    
      func trialController()
      {
          
          
            let defaults = UserDefaults.standard
            let token = defaults.string(forKey: "token")
            let header: HTTPHeaders = [
                "Authorization" :  "bearer " + token!
            ]
            let TrialController_URL = "https://wcbsearch.swan.ac.uk/test/api/Trials/"
            
          
                     Alamofire.request(TrialController_URL, method: .get,headers : header)
                               .responseJSON{
                                   
                                   response in
                                   
                                   if response .result.isSuccess{
                                      print ("Almamosfire Success! ")
                                      //print (response.result.description);
                                      //print(response.result.debugDescription)
                                      //let string = String(bytes: response.data!, encoding: .utf8)
                                      let  resultJSON : JSON = JSON(response.result.value!)
                                      //print(resultJSON)
                        
                                      if let items = resultJSON.array {
                                                          for item in items {
                                                            let jasonItem: JSON = JSON(item)
                                                           self.CreateTrial(Trials: jasonItem)
                                                           self.confirmItems(confirmItem: jasonItem)
                                                           self.CreateVersion(version: jasonItem)
                                                           self.CreateTrialSection(trialSection: jasonItem)
                                                           self.CreatePatientDetailTypeMap(pDetailTypeMap: jasonItem)
                                          }//  for items
              
                                      } //  closre if resultJson
                                                                         let realm = try! Realm()
                                       print( "Try trial controller data saving now ------> ")
                                       try! realm.write {
                                        realm.add(self.listOfDwonloadedTrials)
                                        realm.add(self.listofDownloadedConfrimItems)
                                        realm.add(self.ListDownloadedVesrion)
                                        realm.add(self.ListOfDownloadedTrialSections)
                                        realm.add(self.ListDownloadedrialPatientDetailTypeMap)
}
                                   }  // response success
                                   else{
                                       print ("Almamosfire error ")
                                   }
                          }
          
    }
    
    
    
      func  CreateStaffUser  (staffUser: JSON) {
               print ("Direct Section Source Begin--->>>>>>>>>>>>>>>>>>>>>>")

                      let jasonSubItem: JSON = JSON(staffUser)
                      let staffUserClass  = StaffUser()
              print ("Staff User --->>>>>>>>>>>>>>>>>>>>>>")
                      if let staffId = jasonSubItem["StaffId"].int32 {
                        staffUserClass.StaffId = staffId
                          print(staffId)
                      }
                      if let organisationId = jasonSubItem["OrganisationId"].int32 {
                          staffUserClass.OrganisationId = organisationId
                           print(organisationId)
                      }
                      if let forename = jasonSubItem["Forename"].string {
                          staffUserClass.Forename = forename
                          print(forename)
                      }
        if let roleId = jasonSubItem["RoleId"].int32 {
                          staffUserClass.RoleId = roleId
                          print(roleId)
                      }
        if let password = jasonSubItem["Password"].string {
                          staffUserClass.Password = "jun1per"
                           print(password)
                      }
                      if let username = jasonSubItem["Username"].string {
                        staffUserClass.Username = username
                          print(username)
                      }
        if let lastSiteId = jasonSubItem["LastSiteId"].int32 {
                          staffUserClass.LastSiteId = lastSiteId
                          print(lastSiteId)
                      }
                      if let email = jasonSubItem["Email"].string {
                          staffUserClass.Email = email
                          print(email)
                      }

               ListDownloadedStaffUser.append(staffUserClass)
      }
    
    
   func  CreateSectionSources  (sectionSource: JSON) {
             print ("Direct Section Source Begin--->>>>>>>>>>>>>>>>>>>>>>")

                    let jasonSubItem: JSON = JSON(sectionSource)
                    let sectionSourceClass  = SectionResource()
            print ("Section Source --->>>>>>>>>>>>>>>>>>>>>>")
                    if let sectionResourceId = jasonSubItem["SectionResourceId"].int32 {
                        sectionSourceClass.SectionResourceId = sectionResourceId
                        print(sectionResourceId)
                    }
                    if let pageId = jasonSubItem["PageId"].int32 {
                        sectionSourceClass.PageId = pageId
                         print(pageId)
                    }
                    if let sectionType = jasonSubItem["Type"].string {
                        sectionSourceClass.SectionType = sectionType
                        print(sectionType)
                    }
                    if let location = jasonSubItem["Location"].string {
                        sectionSourceClass.Location = location
                        print(location)
                    }
                    if let position = jasonSubItem["Position"].int32 {
                        sectionSourceClass.Position = position
                         print(position)
                    }
                    if let text = jasonSubItem["Text"].string {
                        sectionSourceClass.Text = text
                        print(text)
                    }
                    if let name = jasonSubItem["Name"].string {
                        sectionSourceClass.Name = name
                        print(name)
                    }
                    if let description = jasonSubItem["Description"].string {
                        sectionSourceClass.Description = description
                        print(description)
                    }

                      ListofDownloadedSectionResource.append(sectionSourceClass)
    
    }
   
   
    
func CreateOrganisation (organisation: JSON)
{
    //listOfDwonlaodedOrganisations
    let org = Organisation()
    if let orgId = organisation["OrganisationId"].int32 {
        org.OrganisatioId  =  orgId  //print(orgId)
        }
    if let orgName = organisation["Name"].string {
           org.Name = orgName // print(orgName)
    }
    listOfDwonlaodedOrganisations.append(org)
}


func CreateSites (sites: JSON)
{
  if let subitems = sites["Site"].array {
     for item in subitems {
         let site = Site()
         let jasonSubItem: JSON = JSON(item)
          if let name = jasonSubItem["Name"].string {
            site.Name = name
                         print("SITE \(name)")
            }
            if let siteId = jasonSubItem["SiteId"].int32 {
                                   print("SITE \(siteId)")
                site.SiteId = siteId
                }
             if let description = jasonSubItem["Description"].string {
                                   print("SITE \(description)")
                site.Description = description
                }
        ListDownloadedSite.append(site)
        }
    }
    
}

 
    
func confirmItems (confirmItem: JSON)
{
    
   print ("Confirm items --->>>>>>>>>>>>>>>>>>>>>>")
   if let subitems = confirmItem["ConfirmItem"].array {
      for item in subitems {
        let jasonSubItem: JSON = JSON(item)
        let cobfirmItem = ConfirmItem()
        if let confirmItemId = jasonSubItem["ConfirmItemId"].int32 {
            cobfirmItem.ConfirmItemId = confirmItemId
            print(confirmItemId)
        }
        if let trialId = jasonSubItem["TrialId"].int32 {
            cobfirmItem.TrialId = trialId
            print(trialId)
        }
        if let text = jasonSubItem["Text"].string {
            cobfirmItem.Text = text
            print(text)
        }
        if let position = jasonSubItem["Position"].int32 {
            cobfirmItem.Position = position
            print(position)
        }
        if let name = jasonSubItem["Name"].string {
            cobfirmItem.Name = name
            print(name)
        }
        if let startDate = jasonSubItem["StartDate"].string {
            cobfirmItem.StartDate = startDate
            print(startDate)
        }
        if let endDate = jasonSubItem["EndDate"].string {
            cobfirmItem.EndDate = endDate
            print(endDate)
        }
        if let versionId = jasonSubItem["VersionId"].int32 {
            cobfirmItem.VersionId = versionId
            print(versionId)
        }
        if let allowNo = jasonSubItem["AllowNo"].bool {
            cobfirmItem.AllowNo = allowNo
            print(allowNo)
        }
        listofDownloadedConfrimItems.append(cobfirmItem)
    }
        
  }
        
        
}

     func CreateTrialSection (trialSection: JSON)
       {
           print ("Trial Sections --->>>>>>>>>>>>>>>>>>>>>>")
         if let subitems = trialSection["TrialSection"].array {
            for item in subitems {
               
               let trialSection = TrialSection()
               let jasonSubItem: JSON = JSON(item)
               if let sectionId = jasonSubItem["SectionId"].int32 {
                   trialSection.SectionId = sectionId
                   print(sectionId)
                 }
                if let trialId = jasonSubItem["TrialId"].int32 {
                    trialSection.TrialId = trialId
                    print(trialId)
                  }
               if let name = jasonSubItem["Name"].string {
                     trialSection.Name = name
                     print(name)
                   }
                if let position = jasonSubItem["Position"].int32 {
                         trialSection.Position = position
                         print(position)
                   }
                ListOfDownloadedTrialSections.append(trialSection)
                
            }
        }
    }
    
    func CreatePatientDetailTypeMap (pDetailTypeMap: JSON)
       {
        print ("TrialPatientDetailTypeMap --->>>>>>>>>>>>>>>>>>>>>>")
                                          
        if let subitems = pDetailTypeMap["TrialPatientDetailTypeMap"].array {
            for item in subitems {
               let patientDetailTypeMap = TrialPatientDetailTypeMap()
               let jasonSubItem: JSON = JSON(item)
               if let detailTypeId = jasonSubItem["DetailTypeId"].int32 {
                patientDetailTypeMap.DetailTypeId = detailTypeId
                   print(detailTypeId)
                 }
                if let mapId = jasonSubItem["MapId"].int32 {
                    patientDetailTypeMap.MapId = mapId
                   print(mapId)
                 }
               if let trialId = jasonSubItem["TrialId"].int32 {
                patientDetailTypeMap.TrialId = trialId
                   print(trialId)
                 }
               if let detailTypeId = jasonSubItem["DetailTypeId"].int32 {
                patientDetailTypeMap.DetailTypeId = detailTypeId
                   print(detailTypeId)
                }
                if let position = jasonSubItem["Position"].int32 {
                    patientDetailTypeMap.Position = position
                   print(position)
                 }
                ListDownloadedrialPatientDetailTypeMap.append(patientDetailTypeMap)
            }
        }
    }
    
    
    
    func CreateVersion (version: JSON)
    {
      print ("Version --->>>>>>>>>>>>>>>>>>>>>>")
      if let subitems = version["Version"].array {
         for item in subitems {
            
            let version = Version()
            let jasonSubItem: JSON = JSON(item)
            if let versionId = jasonSubItem["VersionId"].int32 {
                version.VersionId = versionId
                print(versionId)
              }
            if let trialId = jasonSubItem["TrialId"].int32 {
                version.TrialId = trialId
                print(trialId)
              }
            if let name = jasonSubItem["Name"].string{
                version.Name = name
                print(name)
              }
            if let locked = jasonSubItem["Locked"].bool{
                version.Locked = locked
                print(locked)
              }
            if let pDFTemplatePath = jasonSubItem["PDFTemplatePath"].string{
                version.PDFTemplatePath = pDFTemplatePath
                print(pDFTemplatePath)
              }
            ListDownloadedVesrion.append(version)
        }
      }
    }
    
    
    
func CreatePatientDetailsType (patientDetail: JSON)
{
  if let subitems = patientDetail["PatientDetailType"].array {
     for item in subitems {
        
        let patientDeatilType = PatientDetailType()
        let jasonSubItem: JSON = JSON(item)
        if let name = jasonSubItem["Name"].string {
            patientDeatilType.Name = name   
            print(name)
          }
        
        if let patientDetailTypeId = jasonSubItem["PatientDetailTypeId"].int32 {
            patientDeatilType.PatientDetailTypeId = patientDetailTypeId
         }
         if let detailType = jasonSubItem["Type"].int32 {
            patientDeatilType.DetailType = detailType
         }
          if let organisationid = jasonSubItem["OrganisationId"].int32 {
            patientDeatilType.OrganisationId = organisationid
        }
         listOfDwonlaodedPatientDetailTypes.append(patientDeatilType)
       }
    }
}

    

    func CreateTrial (Trials: JSON)
    {
        
         print ("Trial --->>>>>>>>>>>>>>>>>>>>>>")

         //print (Trials)
        //listOfDwonlaodedOrganisations
        let trial = Trial()
        if let trialId = Trials["TrialId"].int32 {
            trial.TrialId  =  trialId
            print("Trial Id \(trialId)")
            }
        if let Name = Trials["Name"].string {
           trial.Name  =  Name
           print(" Trail Name \(Name)")
           }
     
        if let OrganisationId = Trials["Organisation"]["OrganisationId"].int32 {
           trial.OrganisationId  =  OrganisationId
           print("OrganisationId \( OrganisationId)")
           }
        
     
         if let HeaderId = Trials["HeaderId"].int32 {
           trial.HeaderId  =  HeaderId
           print("Header \(HeaderId)")
           }
         if let KeyDetail = Trials["KeyDetail"].int32 {
           trial.KeyDetail  =  KeyDetail
           print("Key deatil \(KeyDetail)")
           }
    
         if let SummaryFontName = Trials["SummaryFontName"].string {
           trial.SummaryFontName  =  SummaryFontName
           print("  Font Name \(SummaryFontName)")
           }
        if let SummaryFontSize = Trials["SummaryFontSize"].float{
          trial.SummaryFontSize  =  SummaryFontSize
          print("Font Size\( SummaryFontSize)")
          }
        if let summaryTickColour = Trials["SummaryTickColour"].int32{
            trial.SummaryTickColour  =  summaryTickColour
            print("SummaryTickColour\(summaryTickColour)")
            }
        if let logo = Trials["Logo"].string{
            trial.Logo  =  logo
            print("Logo\( logo)")
            }
         if let headerBack = Trials["HeaderBack"].string{
            trial.HeaderBack  =  headerBack
            print("HeaderBack\( headerBack)")
            }
         if let leadEmail = Trials["LeadEmail"].string{
            trial.LeadEmail  =  leadEmail
            print("LeadEmail\( leadEmail)")
            }
        if let website = Trials["Website"].string{
           trial.Website  =  website
           print("Website\( website)")
           }
        if let useHeader = Trials["UseHeader"].bool{
           trial.UseHeader  =  useHeader
           print("UseHeader\( useHeader)")
           }
        if let logo2 = Trials["Logo2"].string{
           trial.Logo2  =  logo2
           print("Logo2\( logo2)")
           }
        if let registerPatientFirst = Trials["RegisterPatientFirst"].bool{
           trial.RegisterPatientFirst  =  registerPatientFirst
           print("RegisterPatientFirst\( registerPatientFirst)")
           }
        if let skipToSectionId = Trials["SkipToSectionId"].int32{
           trial.SkipToSectionId  =  skipToSectionId
           print("SkipToSectionId\( skipToSectionId)")
           }
        
           listOfDwonloadedTrials.append(trial)
    }
    

    
}

// Marke ->  Create Staff


