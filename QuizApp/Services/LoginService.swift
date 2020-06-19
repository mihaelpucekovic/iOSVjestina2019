//
//  LoginService.swift
//  QuizApp
//
//  Created by Mihael Puceković on 11/05/2020.
//  Copyright © 2020 Mihael. All rights reserved.
//

import UIKit

class LoginService {
    func login(username: String, password: String, completion: @escaping ((ResultEnum<Any>?) -> Void)){
        let urlString = "https://iosquiz.herokuapp.com/api/session"
        
         if let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            let parameters = ["username": username, "password": password]
            
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
            
             let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
                 if let data = data {
                     do {
                         let json = try JSONSerialization.jsonObject(with: data, options: [])
                         if let loginInfo = json as? [String: Any], let token = loginInfo["token"] as? String, let user_id = loginInfo["user_id"] as? Int {
                            
                            let userDefaults = UserDefaults.standard
                            userDefaults.set(token, forKey: "token")
                            userDefaults.set("\(user_id)", forKey: "user_id")
                            userDefaults.set(username, forKey: "username")
                            
                            completion(.success("Success"))
                         } else {
                            completion(.failure("Failure"))
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
