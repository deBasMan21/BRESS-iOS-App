//
//  SkillLevel.swift
//  BRESS-TournooiPlanner
//
//  Created by Bas Buijsen on 06/01/2022.
//

import Foundation

struct SkillLevelObj : Decodable, Identifiable {
    var id : Int
    var name : String
}

struct SkillLevelObjWrapper : Decodable {
    var result : [SkillLevelObj]
}
