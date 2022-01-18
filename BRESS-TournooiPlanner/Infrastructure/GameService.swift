//
//  CurrentGameService.swift
//  BRESS-TournooiPlanner
//
//  Created by Bas Buijsen on 06/01/2022.
//

import Foundation

func getCurrentGame() async throws -> Game? {
    var returnValue : Game? = nil
    let playerId : Int = getUserId()
    
    let token = getUserToken()
    
    let url = URL(string: "\(apiURL)/player/\(playerId)/currentGame")!
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    
    request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

    let(data, _) = try await URLSession.shared.data(for: request)
    
    do{
        let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
        print(jsonResponse)
        
        let decoder = JSONDecoder()
        let model = try decoder.decode(GameResultWrapper.self, from: data)
            
        returnValue = model.result
    } catch let parsingError{
        print("error", parsingError)
    }
    
    return returnValue
}

func enterScore(score : [[String]], gameId : Int) async throws -> Bool{
    let token = getUserToken()
    let playerId : Int = getUserId()
    
    let json : [String: Any] = ["scorePlayer1": score[0], "scorePlayer2": score[1]]
    
    let jsonData = try? JSONSerialization.data(withJSONObject: json)
    
    let url = URL(string: "\(apiURL)/player/\(playerId)/currentGame/\(gameId)")!
    var request = URLRequest(url: url)
    request.httpMethod = "PUT"
    
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    
    request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

    request.httpBody = jsonData
    
    let(data, _) = try await URLSession.shared.data(for: request)
    
    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
    print(jsonResponse)
    
    do{
        let decoder = JSONDecoder()
        let model = try decoder.decode(ErrorResponse.self, from: data)
        
        print(model)
        
        if model.errorCode == 404 && model.message == "Game not found" {
            return false
        }
        
    } catch let exception{
        print("error", exception)
    }
    
    return true
}


func getNextGame() async throws -> Game? {
    var returnValue : Game? = nil
    let playerId : Int = getUserId()

    let token = getUserToken()

    let url = URL(string: "\(apiURL)/player/\(playerId)/nextGame")!
    var request = URLRequest(url: url)
    request.httpMethod = "GET"

    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")

    request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

    let(data, _) = try await URLSession.shared.data(for: request)

    do{
        let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
        print(jsonResponse)

        let decoder = JSONDecoder()
        let model = try decoder.decode(GameResultWrapper.self, from: data)

        returnValue = model.result
    } catch let parsingError{
        print("error", parsingError)
    }
    return returnValue
}
