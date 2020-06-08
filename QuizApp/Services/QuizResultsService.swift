//
//  QuizResultsService.swift
//  QuizApp
//
//  Created by Mihael Puceković on 02/06/2020.
//  Copyright © 2020 Mihael. All rights reserved.
//

import UIKit

class QuizResultsService {
    func getQuizResults(quiz_id: Int, token: String, completion: @escaping (([Result]?) -> Void)){
        let urlString = "https://iosquiz.herokuapp.com/api/score?quiz_id=\(quiz_id)"
        
         if let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue(token, forHTTPHeaderField: "Authorization")
            
             let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
                 if let data = data {
                     do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                      
                        if let results = json as? [[String: Any]] {
                            let resultsArray = results.map({ json -> Result? in
                                if
                                    let scoreString = json["score"] as? String,
                                    let score = Double(scoreString),
                                    let username = json["username"] as? String {
                                    let result = Result(score: score, username: username)
                                    return result
                                } else {
                                    return nil
                                }
                            }).filter { $0 != nil } .map { $0! } .sorted(by: { $0.score > $1.score })
                            completion(Array(resultsArray.prefix(20)))
                        } else {
                            completion(nil)
                        }
                     } catch {
                         completion(nil)
                     }
                 } else {
                     completion(nil)
                 }
             }
             
             dataTask.resume()
         } else {
             completion(nil)
         }
     }
}
