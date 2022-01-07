//
//  GameResponseModels.swift
//  BRESS-TournooiPlanner
//
//  Created by Bas Buijsen on 06/01/2022.
//

import Foundation

struct GameResultWrapper : Decodable{
    var result : Game
}

struct Game : Decodable{
    var id : Int
    var score : String?
    var winner: Int
    var inQueue : Bool
    var gameStarted : Bool
    var field : Field?
    var player1 : Player
    var player2 : Player
}

struct Field : Decodable{
    var id : Int
    var name : String
    var isAvailable : Bool
}

struct Player : Decodable{
    var id : Int
    var name : String
    var email: String
    var score : Int
    var pointBalance : Int
    var skillLevel : SkillLevel
    var fbToken : String?
}

struct SkillLevel : Decodable{
    var id : Int
    var name : String
}
