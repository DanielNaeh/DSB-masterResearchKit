//
//  Datamodel.swift
//  MSconsenter
//
//  Created by Daniel Naeh on 28/08/2019.
//  Copyright © 2019 Eldergen. All rights reserved.
//

import Foundation

class DMconsentItem
{
    var   givenName:  String = ""
    var   sirName:   String  = ""
    var   sig1 : String = ""
    var   transmitted : Bool = false
    var date : String = ""
    var   trialId : Int32 = 0
    var staffId : Int32 = 0
}


class DMConsentBitsItems
{
    var value: Bool? = nil
    var confirmItemId:  Int32 = 0;
}

