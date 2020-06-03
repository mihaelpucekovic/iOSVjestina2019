//
//  QuizResultsService.swift
//  QuizApp
//
//  Created by Mihael Puceković on 02/06/2020.
//  Copyright © 2020 Mihael. All rights reserved.
//

import UIKit

class QuizResultsService {
    func getQuizResults(quiz_id: Int, token: String, completion: @escaping ((String?) -> Void)){
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
                        print(json)
                        
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
