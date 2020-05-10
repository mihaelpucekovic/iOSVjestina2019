//
//  Quiz.swift
//  QuizApp
//
//  Created by Mihael Puceković on 08/05/2020.
//  Copyright © 2020 Mihael. All rights reserved.
//

import Foundation

class Quiz {
    
     let id: Int
     let title: String
     let description: String
     let category: String
     let level: Int
     let image: String
    var questions = [Question]()
     
    init(id: Int, title: String, description: String, category: String, level: Int, image: String, questions: [[String: Any]]) {
        self.id = id
        self.title = title
        self.description = description
        self.category = category
        self.level = level
        self.image = image
        
        for singleQuestion in questions {
            let id = singleQuestion["id"] as? Int
            let question = singleQuestion["question"] as? String
            let answers = singleQuestion["answers"] as? [String]
            let correct_answer = singleQuestion["correct_answer"] as? Int
            let questionObject = Question(id: id!, question: question!, answers: answers!, correct_answer: correct_answer!)
            self.questions.append(questionObject)
        }
        
    }
}
