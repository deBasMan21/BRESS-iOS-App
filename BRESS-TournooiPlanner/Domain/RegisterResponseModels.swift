//
//  RegisterResponseModels.swift
//  BRESS-TournooiPlanner
//
//  Created by Bas Buijsen on 06/01/2022.
//

import Foundation

struct RegisterResponseWrapper : Decodable{
    var result : RegisterResponse
}

struct RegisterResponse : Decodable{
    var succeeded : Bool
    var playerExists : Bool
    var token : String
}
