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
        let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
        print(jsonResponse)
        
        let decoder = JSONDecoder()
        let model = try decoder.decode(loginResponseWrapper.self, from: data)
        
        let token : String = model.result.token
        let tokenData : Data = token.data(using: .utf8)!
        
        let playerEmail : String = model.result.user.email
        let playerEmailData : Data = playerEmail.data(using: .utf8)!
        
        let playerId : Int = model.result.user.id
        let playerIdData : Data = playerId.data
        
        saveToken(token: tokenData, service: "nl.bress.BRESS-TournooiPlanner-token", account: "BRESS-token")
        saveToken(token: playerIdData, service: "nl.bress.BRESS-TournooiPlanner-id", account: "BRESS-playerId")
        saveToken(token: playerEmailData, service: "nl.bress.BRESS-TournooiPlanner-email", account: "BRESS-playerEmail")
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
    deleteToken(service: "nl.bress.BRESS-TournooiPlanner-token", account: "BRESS-token")
    deleteToken(service: "nl.bress.BRESS-TournooiPlanner-id", account: "BRESS-playerId")
    deleteToken(service: "nl.bress.BRESS-TournooiPlanner-email", account: "BRESS-playerEmail")
}

func apiRegister(email: String, password: String) async throws -> RegisterResponse {
    var returnValue : RegisterResponse = RegisterResponse(succeeded: false, playerExists: false, token: "")
    
    let json : [String: Any] = ["email": email, "password": password]
    
    let jsonData = try? JSONSerialization.data(withJSONObject: json)
    
    let url = URL(string: "https://bress-api.azurewebsites.net/api/playerregister")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")

    request.httpBody = jsonData
    
    let(data, _) = try await URLSession.shared.data(for: request)
    
    do{
        let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
        print(jsonResponse)
        
        let decoder = JSONDecoder()
        let model = try decoder.decode(RegisterResponseWrapper.self, from: data)
            
        let token : String = model.result.token
        let tokenData : Data = token.data(using: .utf8)!
        
        saveToken(token: tokenData, service: "nl.bress.BRESS-TournooiPlanner-token", account: "BRESS-token")
        
        print(model.result.succeeded)
        
        returnValue = model.result
    } catch let parsingError{
        print("error", parsingError)
    }
    
    return returnValue
}

func getUserToken() -> String{
    let token: String = String(data: getToken(service: "nl.bress.BRESS-TournooiPlanner-token", account: "BRESS-token"), encoding: .utf8)!
    return token
}

func getUserId() -> Int{
    return Int(getToken(service: "nl.bress.BRESS-TournooiPlanner-id", account: "BRESS-playerId").uint8)
}

func getUserEmail() -> String{
    let email: String = String(data: getToken(service: "nl.bress.BRESS-TournooiPlanner-email", account: "BRESS-playerEmail"), encoding: .utf8)!
    return email
}
