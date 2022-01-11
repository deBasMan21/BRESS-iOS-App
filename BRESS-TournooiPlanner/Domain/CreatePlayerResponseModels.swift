//
//  CreatePlayerResponseModels.swift
//  BRESS-TournooiPlanner
//
//  Created by Bas Buijsen on 06/01/2022.
//

import Foundation

struct PlayerWrapper : Decodable {
    var result : PlayerObj
}

struct PlayerObj : Decodable {
    var id : Int
    var name : String
    var email : String
    var skillLevel : SkillLevelObj
}
