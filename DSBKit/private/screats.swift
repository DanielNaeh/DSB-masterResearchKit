//
//  File.swift
//  MSconsenter
//
//  Created by Daniel Naeh on 13/09/2019.
//  Copyright © 2019 Eldergen. All rights reserved.
//
import UIKit
import Foundation
import Alamofire

var secretParameters: [String : String] = [String : String]()
//let secretParameters: [String : String] = ["password" : "jun1per", "username" : "daniel", "grant_type" : "password"]
func storeCerdentialsInMem(staffUser: StaffUser)
{
     secretParameters = ["password" : staffUser.Password, "username" : staffUser.Username, "grant_type" :"password"]
     loggedUser = staffUser
    
}










