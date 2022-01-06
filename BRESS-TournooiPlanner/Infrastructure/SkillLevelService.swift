//
//  SkillLevelService.swift
//  BRESS-TournooiPlanner
//
//  Created by Bas Buijsen on 06/01/2022.
//

import Foundation

func getAllSkillLevels() async throws -> [SkillLevelObj] {
    let token = getUserToken()
    
    let url = URL(string: "https://bress-api.azurewebsites.net/api/skilllevel")!
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
        let model = try decoder.decode(SkillLevelObjWrapper.self, from: data)
            
        return model.result
    } catch let parsingError{
        print("error", parsingError)
    }
    
    return []
}
