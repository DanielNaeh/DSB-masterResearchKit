//
//  TrialsRealm.swift
//  MSconsenter
//
//  Created by Daniel Naeh on 30/09/2019.
//  Copyright © 2019 Eldergen. All rights reserved.
//

import Foundation
import RealmSwift
import ResearchKit



    class  TablesMetaData: Object{
        @objc dynamic var mataTbaleID = UUID().uuidString
        @objc dynamic  var   tableName:  String = ""
        @objc dynamic var    updateDate : String = ""
       
        override static func primaryKey() -> String? {
          return "mataTbaleID"
        }
    }

class  Organisation : Object{
        
    @objc dynamic var OrganisatioId:  Int32 = 0
    @objc dynamic var Name: String = ""
}

class  Site : Object{
        
    @objc dynamic var SiteId:  Int32 = 0
    @objc dynamic var Name: String = ""
    @objc dynamic var Description: String = ""
    
}

class PatientDetailx: Object {
    
    @objc dynamic var DetailTypeId: Int32 = 0
    @objc dynamic var Value: String = ""
    @objc dynamic var Name: String = ""
    
    
}


class  ConsentBits: Object{
    @objc dynamic var  personID = UUID().uuidString
    @objc dynamic    var   deivceId:  String = ""
    @objc dynamic    var   givenName:  String = ""
    @objc dynamic var    familyName:   String  = ""
    @objc dynamic var   sig1 : String = ""
    @objc dynamic var   sig2 : String = ""
    @objc dynamic var   transmitted : Bool = false
    @objc dynamic var date : String = ""
    @objc dynamic var   trialId : Int32 = 1
    @objc dynamic var staffId : Int32 = 2
    @objc dynamic var consenterEmail : String = ""
    dynamic var consentItems = List<ConsentBitsItems>()
    dynamic var PatientDetails = List<PatientDetailx>()
    
    override static func primaryKey() -> String? {
     return "personID"
   }
    
}


class ConsentBitsItems: Object {
@objc dynamic var value: Bool = false
@objc dynamic var confirmItemId: Int32 = 0
@objc dynamic var allowNo: Bool = false
    
}



class StaffUser :  Object {
    
    @objc dynamic var StaffId: Int32 = 0
    @objc dynamic var OrganisationId: Int32 = 0
    @objc dynamic var Forename: String = ""
    @objc dynamic var Surname: String = ""
    @objc dynamic var RoleId: Int32 = 0
    @objc dynamic var Password:  String = ""
    @objc dynamic var Username: String = ""
    @objc dynamic var LastSiteId: Int32 = 0
    @objc dynamic var Email: String = ""
    
}

class  TrialSection : Object{
    @objc dynamic var SectionId: Int32 = 0
    @objc dynamic var TrialId:  Int32 =  0
    @objc dynamic var Name: String = ""
    @objc dynamic var Position: Int32 = 0
}


class  SectionResource: Object {
    
    @objc dynamic var SectionResourceId: Int32 = 0
    @objc dynamic var PageId:  Int32 =  0
    @objc dynamic var SectionType: String = ""
    @objc dynamic var Location: String = ""
    @objc dynamic var Position: Int32 = 0
    @objc dynamic var Text: String = ""
    @objc dynamic var Name: String = ""
    @objc dynamic var Description: String = ""
}


class  Version : Object{
        
    @objc dynamic var VersionId:  Int32 = 0
    @objc dynamic var TrialId: Int32 = 0
    @objc dynamic var Name: String = ""
    @objc dynamic var Created: String = ""
    @objc dynamic var Locked: Bool = false
    @objc dynamic var PDFTemplatePath: String =  ""
    
}

class  ConfirmItem : Object{
        
    @objc dynamic var ConfirmItemId:  Int32 = 0
    @objc dynamic var TrialId: Int32 = 0
    @objc dynamic var Text: String = ""
    @objc dynamic var Position: Int32 = 0
    @objc dynamic var Name: String = ""
    @objc dynamic var StartDate: String =  ""
    @objc dynamic var EndDate: String = ""
    @objc dynamic var VersionId: Int32 = 0
    @objc dynamic var AllowNo: Bool = false
    
    
}

class PatientDetailType: Object{
    
    @objc dynamic var PatientDetailTypeId: Int32 = 0
    @objc dynamic var Name: String = ""
    @objc dynamic var DetailType: Int32 = 0
    @objc dynamic var OrganisationId: Int32 = 0
    
}



class  Trial : Object{
    
     @objc dynamic var  TrialId: Int32  = 0
     @objc dynamic var  Name: String = ""
     @objc dynamic var  OrganisationId: Int32 = 0
     @objc dynamic var  KeyDetail: Int32 = 0
     @objc dynamic var  HeaderId: Int32 = 0
     @objc dynamic var  SummaryFontName: String = ""
     @objc dynamic var  SummaryFontSize: Float = 0
     @objc dynamic var  SummaryFontColour:  String = ""
     @objc dynamic var  SummaryTickColour: Int32 = 0
     @objc dynamic var  Logo:   String = ""
     @objc dynamic var  HeaderBack: String = ""
     @objc dynamic var  LeadEmail: String = ""
     @objc dynamic var  Website: String = ""
     @objc dynamic var  UseHeader: Bool = false
     @objc dynamic var  Logo2: String = ""
     @objc dynamic var  RegisterPatientFirst: Bool = false
     @objc dynamic var  SkipToSectionId: Int32 = 0
}




class  TrialPatientDetailTypeMap: Object {
    @objc dynamic var  MapId:  Int32 = 0
    @objc dynamic var  TrialId:  Int32 = 0
    @objc dynamic var  DetailTypeId:  Int32 = 0
    @objc dynamic var  Position:  Int32 = 0

}














