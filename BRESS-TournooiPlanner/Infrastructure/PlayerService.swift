//
//  PlayerService.swift
//  BRESS-TournooiPlanner
//
//  Created by Bas Buijsen on 06/01/2022.
//

import Foundation

func apiCreatePlayer(email: String, name: String, skillLevel: Int) async throws -> Bool {
    let token = getUserToken()
    
    let json : [String: Any] = ["email": email, "name": name, "skillLevelId": skillLevel]
    
    let jsonData = try? JSONSerialization.data(withJSONObject: json)
    
    let url = URL(string: "https://bress-api.azurewebsites.net/api/player")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    
    request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    
    request.httpBody = jsonData
    
    let(data, _) = try await URLSession.shared.data(for: request)
    
    do{
        let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
        print(jsonResponse)
        
        return true
    } catch let parsingError{
        print("error", parsingError)
    }
    
    return false
}
