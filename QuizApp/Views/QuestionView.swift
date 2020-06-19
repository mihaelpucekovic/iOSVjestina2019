//
//  QuestionView.swift
//  QuizApp
//
//  Created by Mihael Puceković on 09/05/2020.
//  Copyright © 2020 Mihael. All rights reserved.
//

import UIKit

protocol UIButtonDelegate: AnyObject {
    func selectedAnswer(_ sender:UIButton, answer:Int)
}

class QuestionView: UITableViewCell {

    @IBOutlet weak var pitanje: UILabel!
    @IBOutlet weak var odgovor1: UIButton!
    @IBOutlet weak var odgovor2: UIButton!
    @IBOutlet weak var odgovor3: UIButton!
    @IBOutlet weak var odgovor4: UIButton!
    
    weak var delegate:UIButtonDelegate?
    var correct_answer = -1
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        pitanje.text = ""
        odgovor1.setTitle("", for: .normal)
        odgovor2.setTitle("", for: .normal)
        odgovor3.setTitle("", for: .normal)
        odgovor4.setTitle("", for: .normal)
        correct_answer = -1
    }

    @IBAction func answerPressed(_ sender: UIButton) {
        delegate?.selectedAnswer(sender, answer: sender.tag)
    }
}
