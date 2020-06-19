//
//  SendQuizResultService.swift
//  QuizApp
//
//  Created by Mihael Puceković on 01/06/2020.
//  Copyright © 2020 Mihael. All rights reserved.
//

import UIKit

class SendQuizResultService {
    func sendQuizResults(quiz_id: Int, user_id: Int, time: Double, no_of_correct: Int, token: String, completion: @escaping ((ResultEnum<Any>?) -> Void)){
        let urlString = "https://iosquiz.herokuapp.com/api/result"
        
         if let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue(token, forHTTPHeaderField: "Authorization")
            
            let parameters = ["quiz_id": quiz_id, "user_id": user_id, "time": time, "no_of_correct": no_of_correct] as [String : Any]
            
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
            
             let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
                 if let data = data {
                     do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        if let text = json as? [String: Any], let errors = text["errors"] as? [String: Any] {
                            completion(.failure("Error: \(errors)"))
                        } else {
                            completion(.success("Success"))
                        }
                     } catch {
                         completion(.failure("Failure"))
                     }
                 } else {
                     completion(.failure("Failure"))
                 }
             }
             
             dataTask.resume()
         } else {
             completion(.failure("Failure"))
         }
     }
}
