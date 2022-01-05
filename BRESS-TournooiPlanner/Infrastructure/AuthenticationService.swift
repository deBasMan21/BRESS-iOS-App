//
//  AuthenticationService.swift
//  BRESS-TournooiPlanner
//
//  Created by Bas Buijsen on 05/01/2022.
//

import Foundation

func apiLogin(email:String, password:String) {
    let json : [String: Any] = ["email": email, "password": password, "fbtoken": "token"]
    
    let jsonData = try? JSONSerialization.data(withJSONObject: json)
    
    let url = URL(string: "https://bress-api.azurewebsites.net/api/playerlogin")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")

    request.httpBody = jsonData

    let task = URLSession.shared.dataTask(with: request){ data, response, error in
        guard let data = data, error == nil else{
            print(error?.localizedDescription ?? "no data")
            return
        }
        
        do{
            let decoder = JSONDecoder()
            let model = try decoder.decode(loginResponseWrapper.self, from: data)
            
            let token : String = model.result.token
            let tokenData : Data = token.data(using: .utf8)!
            
            let playerId : String = String(model.result.user.id)
//            let playerIdData : Data = playerId.data(using: .utf8)!
            let playerIdData : Data = Data(from: playerId)
            print(playerId)
            
            saveToken(token: tokenData, service: "nl.bress.BRESS-TournooiPlanner", account: "BRESS-token")
            saveToken(token: playerIdData, service: "nl.bress.BRESS-TournooiPlanner", account: "BRESS-playerId")
        } catch let parsingError{
            print("error", parsingError)
        }
    }
    
    task.resume()
}


func apiLogout(email: String){
    let json : [String: Any] = ["email": email]
    
    let jsonData = try? JSONSerialization.data(withJSONObject: json)
    
    let url = URL(string: "https://bress-api.azurewebsites.net/api/playerlogout")!
    var request = URLRequest(url: url)
    request.httpMethod = "PUT"
    
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")

    request.httpBody = jsonData

    let task = URLSession.shared.dataTask(with: request){ data, response, error in
        guard let data = data, error == nil else{
            print(error?.localizedDescription ?? "no data")
            return
        }
        print(String(data: data, encoding: .utf8) as Any)
        deleteToken(service: "nl.bress.BRESS-TournooiPlanner", account: "BRESS")
    }
    
    task.resume()
}

func getUserToken() -> String{
    let token: String = String(data: getToken(service: "nl.bress.BRESS-TournooiPlanner", account: "BRESS-token"), encoding: .utf8)!
    return token
}

func getUserId() -> Int{
    let userId: Int = getToken(service: "nl.bress.BRESS-TournooiPlanner", account: "BRESS-playerId").to(type: Int.self)
    return userId
}
