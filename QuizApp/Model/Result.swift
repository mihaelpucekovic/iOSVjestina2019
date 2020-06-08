//
//  Result.swift
//  QuizApp
//
//  Created by Mihael Puceković on 07/06/2020.
//  Copyright © 2020 Mihael. All rights reserved.
//

import Foundation

class Result {
    
    let score: Double
    let username: String
     
    init(score: Double, username: String) {
        self.score = score
        self.username = username
    }
}
