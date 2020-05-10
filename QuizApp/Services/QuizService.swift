//
//  QuizService.swift
//  QuizApp
//
//  Created by Mihael Puceković on 08/05/2020.
//  Copyright © 2020 Mihael. All rights reserved.
//

import Foundation
import UIKit

class QuizService {
    func fetchQuizzes(urlString: String, completion: @escaping (([Quiz]?) -> Void)){
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            
            let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])

                        if let quizzesList = json as? [String: Any], let quizzes = quizzesList["quizzes"] as? [[String: Any]] {
                            let quizzesArray = quizzes.map({ json -> Quiz? in
                                if
                                    let id = json["id"] as? Int,
                                    let title = json["title"] as? String,
                                    let description = json["description"] as? String,
                                    let category = json["category"] as? String,
                                    let level = json["level"] as? Int,
                                    let image = json["image"] as? String,
                                    let questions = json["questions"] as? [[String: Any]] {
                                    let quiz = Quiz(id: id, title: title, description: description, category: category, level: level, image: image, questions: questions)
                                    return quiz
                                } else {
                                    return nil
                                }
                            }).filter { $0 != nil } .map { $0! }
                            completion(quizzesArray)
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
