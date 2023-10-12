//
//  File.swift
//  
//
//  Created by Mattia Da Campo on 12/10/23.
//

import Foundation

import Foundation

public struct Agent: Identifiable, Codable {
    public let id: String
    public let name: String
    public let description: String
    
    public init(id: String, name: String, description: String) {
        self.id = id
        self.name = name
        self.description = description
    }
}

public struct MyAPI {
    public static func fetchAgents(token: String, completion: @escaping (Result<[Agent], Error>) -> Void) {
        let url = URL(string: "https://api.beta.superagent.sh/api/v1/agents")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let dataArray = json["data"] as? [[String: Any]] {
                        
                        var agents: [Agent] = []
                        
                        for item in dataArray {
                            if let id = item["id"] as? String,
                               let name = item["name"] as? String,
                               let description = item["description"] as? String {
                                let agent = Agent(id: id, name: name, description: description)
                                agents.append(agent)
                            }
                        }
                        
                        completion(.success(agents))
                    }
                } catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}

