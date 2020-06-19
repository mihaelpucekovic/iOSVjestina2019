//
//  QuizService.swift
//  QuizApp
//
//  Created by Mihael Puceković on 08/05/2020.
//  Copyright © 2020 Mihael. All rights reserved.
//

import UIKit

class QuizService {
    func fetchQuizzes(completion: @escaping ((ResultEnum<Any>?) -> Void)){
        let urlString = "https://iosquiz.herokuapp.com/api/quizzes"
        
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            
            let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])

                        if let quizzesList = json as? [String: Any], let quizzes = quizzesList["quizzes"] as? [[String: Any]] {
                            let quizzesArray = quizzes.compactMap{ json -> Quiz? in
                                if
                                    let id = json["id"] as? Int,
                                    let title = json["title"] as? String,
                                    let description = json["description"] as? String,
                                    let category = json["category"] as? String,
                                    let level = json["level"] as? Int,
                                    let image = json["image"] as? String,
                                    let questions = json["questions"] as? [[String: Any]] {
                                    var questionObjects = [Question]()
                                    
                                    for singleQuestion in questions {
                                        let id = singleQuestion["id"] as? Int
                                        let question = singleQuestion["question"] as? String
                                        let answers = singleQuestion["answers"] as? [String]
                                        let correct_answer = singleQuestion["correct_answer"] as? Int
                                        let questionObject = Question(id: id!, question: question!, answers: answers!, correct_answer: correct_answer!)
                                        questionObjects.append(questionObject)
                                    }
                                    
                                    let urlString = URL(string: image)
                                    let imageData = try? Data(contentsOf: urlString!)
                                    
                                    let quiz = Quiz(id: id, title: title, description: description, category: category, level: level, image: image, imageData: imageData!, questions: questionObjects)
                                    return quiz
                                } else {
                                    return nil
                                }
                            }
                            completion(.success(quizzesArray))
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
