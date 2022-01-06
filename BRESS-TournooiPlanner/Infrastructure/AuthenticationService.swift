//
//  AuthenticationService.swift
//  BRESS-TournooiPlanner
//
//  Created by Bas Buijsen on 05/01/2022.
//

import Foundation

func apiLogin(email:String, password:String) async throws -> Bool {
    let json : [String: Any] = ["email": email, "password": password, "fbtoken": "token"]
    
    let jsonData = try? JSONSerialization.data(withJSONObject: json)
    
    let url = URL(string: "https://bress-api.azurewebsites.net/api/playerlogin")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")

    request.httpBody = jsonData
    
    let(data, _) = try await URLSession.shared.data(for: request)
    
    do{
        let decoder = JSONDecoder()
        let model = try decoder.decode(loginResponseWrapper.self, from: data)
        
        let token : String = model.result.token
        let tokenData : Data = token.data(using: .utf8)!
        
        let playerEmail : String = model.result.user.email
        let playerEmailData : Data = playerEmail.data(using: .utf8)!
        
        let playerId : String = String(model.result.user.id)
        let playerIdData : Data = Data(from: playerId)
        print(playerId)
        
        saveToken(token: tokenData, service: "nl.bress.BRESS-TournooiPlanner", account: "BRESS-token")
        saveToken(token: playerIdData, service: "nl.bress.BRESS-TournooiPlanner", account: "BRESS-playerId")
        saveToken(token: playerEmailData, service: "nl.bress.BRESS-TournooiPlanner", account: "BRESS-playerEmail")
    } catch let parsingError{
        print("error", parsingError)
        return false
    }
    return true
}


func apiLogout(email: String) async throws{
    let json : [String: Any] = ["email": email]
    
    let jsonData = try? JSONSerialization.data(withJSONObject: json)
    
    let url = URL(string: "https://bress-api.azurewebsites.net/api/playerlogout")!
    var request = URLRequest(url: url)
    request.httpMethod = "PUT"
    
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")

    request.httpBody = jsonData
    
    let(data, _) = try await URLSession.shared.data(for: request)
    
    print(String(data: data, encoding: .utf8) as Any)
    deleteToken(service: "nl.bress.BRESS-TournooiPlanner", account: "BRESS-token")
    deleteToken(service: "nl.bress.BRESS-TournooiPlanner", account: "BRESS-playerId")
    deleteToken(service: "nl.bress.BRESS-TournooiPlanner", account: "BRESS-playerEmail")
}

func getUserToken() -> String{
    let token: String = String(data: getToken(service: "nl.bress.BRESS-TournooiPlanner", account: "BRESS-token"), encoding: .utf8)!
    return token
}

func getUserId() -> Int{
    let userId: Int = getToken(service: "nl.bress.BRESS-TournooiPlanner", account: "BRESS-playerId").to(type: Int.self)
    return userId
}

func getUserEmail() -> String{
    let email: String = String(data: getToken(service: "nl.bress.BRESS-TournooiPlanner", account: "BRESS-playerEmail"), encoding: .utf8)!
    return email
}
