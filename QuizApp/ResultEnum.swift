//
//  ResultEnum.swift
//  QuizApp
//
//  Created by Mihael Puceković on 19/06/2020.
//  Copyright © 2020 Mihael. All rights reserved.
//

enum ResultEnum<T> {
    case success(T)
    case failure(String)
    case error(Error)
}
