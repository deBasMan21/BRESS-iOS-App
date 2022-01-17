//
//  ErrorResponse.swift
//  BRESS-TournooiPlanner
//
//  Created by Bas Buijsen on 17/01/2022.
//

import Foundation

struct ErrorResponse : Decodable {
    var errorCode: Int
    var message: String
}
