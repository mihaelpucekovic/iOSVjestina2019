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
    let imageData: Data
    var questions = [Question]()
     
    init(id: Int, title: String, description: String, category: String, level: Int, image: String, imageData: Data, questions: [Question]) {
        self.id = id
        self.title = title
        self.description = description
        self.category = category
        self.level = level
        self.image = image
        self.imageData = imageData
        self.questions = questions
    }
}
