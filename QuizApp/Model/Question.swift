//
//  Question.swift
//  QuizApp
//
//  Created by Mihael Puceković on 09/05/2020.
//  Copyright © 2020 Mihael. All rights reserved.
//

import Foundation

class Question: NSObject, NSCoding {
    
    let id: Int
    let question: String
    let answers: [String]
    let correct_answer: Int
     
    init(id: Int, question: String, answers: [String], correct_answer: Int) {
        self.id = id
        self.question = question
        self.answers = answers
        self.correct_answer = correct_answer
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(id, forKey: "id")
        coder.encode(question, forKey: "question")
        coder.encode(answers, forKey: "answers")
        coder.encode(correct_answer, forKey: "correct_answer")
    }
    
    required convenience init?(coder: NSCoder) {
        let id = coder.decodeInteger(forKey: "id")
        let question = (coder.decodeObject(forKey: "question") as? String)!
        let answers = (coder.decodeObject(forKey: "answers") as? [String])!
        let correct_answer = coder.decodeInteger(forKey: "correct_answer")
        self.init(id: id, question: question, answers: answers, correct_answer: correct_answer)
    }
}
