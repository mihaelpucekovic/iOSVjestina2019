//
//  QuestionView.swift
//  QuizApp
//
//  Created by Mihael Puceković on 09/05/2020.
//  Copyright © 2020 Mihael. All rights reserved.
//

import UIKit

protocol UIButtonDelegate: AnyObject {
    func answerPressed(_ sender:UIButton, selectedAnswer:Int)
}

class QuestionView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var pitanje: UILabel!
    @IBOutlet weak var odgovor1: UIButton!
    @IBOutlet weak var odgovor2: UIButton!
    @IBOutlet weak var odgovor3: UIButton!
    @IBOutlet weak var odgovor4: UIButton!
    
    weak var delegate:UIButtonDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
              
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("QuestionView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }


    @IBAction func answer1Selected(_ sender: UIButton) {
        delegate?.answerPressed(sender, selectedAnswer: 0)
    }
    @IBAction func answer2Selected(_ sender: UIButton) {
        delegate?.answerPressed(sender, selectedAnswer: 1)
    }
    @IBAction func answer3Selected(_ sender: UIButton) {
        delegate?.answerPressed(sender, selectedAnswer: 2)
    }
    @IBAction func answer4Selected(_ sender: UIButton) {
        delegate?.answerPressed(sender, selectedAnswer: 3)
    }
}
