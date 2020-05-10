//
//  Question.swift
//  QuizApp
//
//  Created by Mihael Puceković on 09/05/2020.
//  Copyright © 2020 Mihael. All rights reserved.
//

import Foundation

class Question {
    
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
}
