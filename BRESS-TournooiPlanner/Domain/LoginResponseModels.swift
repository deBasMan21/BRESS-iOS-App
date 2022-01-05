//
//  LoginResponseModels.swift
//  BRESS-TournooiPlanner
//
//  Created by Bas Buijsen on 05/01/2022.
//

import Foundation

struct loginResponseWrapper : Decodable{
    var result : LoginResponse
}

struct LoginResponse : Decodable{
    var token : String
    var expireDate : String
    var user : User
}

struct User : Decodable{
    var email : String
    var id : Int
}
