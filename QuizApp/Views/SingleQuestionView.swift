//
//  SingleQuestionView.swift
//  QuizApp
//
//  Created by Mihael Puceković on 29/05/2020.
//  Copyright © 2020 Mihael. All rights reserved.
//

import UIKit

protocol UIButtonDelegateSQ: AnyObject {
    func answerPressed(_ sender:UIButton, selectedAnswer:Int)
}

class SingleQuestionView: UITableViewCell {

    @IBOutlet weak var labelPitanje: UILabel!
    @IBOutlet weak var odgovor1: UIButton!
    @IBOutlet weak var odgovor2: UIButton!
    @IBOutlet weak var odgovor3: UIButton!
    @IBOutlet weak var odgovor4: UIButton!
    
    var correct_answer = -1
    weak var delegate:UIButtonDelegateSQ?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        labelPitanje.text = ""
        odgovor1.setTitle("", for: .normal)
        odgovor2.setTitle("", for: .normal)
        odgovor3.setTitle("", for: .normal)
        odgovor4.setTitle("", for: .normal)
        correct_answer = -1
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

