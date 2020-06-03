//
//  QuizTableViewCell.swift
//  QuizApp
//
//  Created by Mihael Puceković on 27/05/2020.
//  Copyright © 2020 Mihael. All rights reserved.
//

import UIKit

class QuizTableViewCell: UITableViewCell {
    
    @IBOutlet weak var quizTitle: UILabel!
    @IBOutlet weak var quizDescription: UILabel!
    @IBOutlet weak var quizImage: UIImageView!
    @IBOutlet weak var quizLevel1: UIImageView!
    @IBOutlet weak var quizLevel2: UIImageView!
    @IBOutlet weak var quizLevel3: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        quizTitle.text = ""
        quizDescription.text = ""
        quizImage?.image = nil
        quizLevel1?.isHidden = true
        quizLevel2?.isHidden = true
        quizLevel3?.isHidden = true
    }
    
    func setup(withQuiz quiz: Quiz) {        
        quizTitle.text = quiz.title
        quizDescription.text = quiz.description
        
        let urlString = URL(string: quiz.image)
        let data = try? Data(contentsOf: urlString!)
        quizImage.image = UIImage(data: data!)
        
        let level = quiz.level
        
        if level == 1 {
            quizLevel1?.isHidden = false
        }
        if level == 2 {
            quizLevel1?.isHidden = false
            quizLevel2?.isHidden = false
        }
        if level == 3 {
            quizLevel1?.isHidden = false
            quizLevel2?.isHidden = false
            quizLevel3?.isHidden = false
        }
    }
}
