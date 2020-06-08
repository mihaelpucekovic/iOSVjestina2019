//
//  ResultTableViewCell.swift
//  QuizApp
//
//  Created by Mihael Puceković on 07/06/2020.
//  Copyright © 2020 Mihael. All rights reserved.
//

import UIKit

class ResultTableViewCell: UITableViewCell {

    @IBOutlet weak var position: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var score: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        position.text = ""
        username.text = ""
        score.text = ""
    }
    
    func setup(withResult result: Result, withRow row: Int) {
        position.text = "\(row + 1)."
        username.text = "User: \(result.username)"
        score.text = "Score: \(result.score)"

    }
}
