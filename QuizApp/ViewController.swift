//
//  ViewController.swift
//  QuizApp
//
//  Created by Mihael Puceković on 07/05/2020.
//  Copyright © 2020 Mihael. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIButtonDelegate {
    func answerPressed(_ sender: UIButton, selectedAnswer: Int) {
        if !answered {
            if selectedAnswer == correct_answer {
                sender.backgroundColor = UIColor.green
            }
            else {
                sender.backgroundColor = UIColor.red
            }
            
            answered = true
        }
    }
    
    @IBOutlet weak var funFact: UILabel!
    @IBOutlet weak var naslovKviza: UILabel!
    @IBOutlet weak var dogodilaSeGreska: UILabel!
    @IBOutlet weak var slikaKviza: UIImageView!
    @IBOutlet weak var questionView: QuestionView!
    
    var quizzes: [Quiz]?
    var correct_answer = -1
    var answered = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionView.delegate = self
        clearQuestion()
    }
    
    @IBAction func dohvatiKvizove(_ sender: UIButton) {
        clearQuestion()
        
        let urlString = "https://iosquiz.herokuapp.com/api/quizzes"
        
        QuizService().fetchQuizzes(urlString: urlString) { [weak self] (quizzes) in
            self!.quizzes = quizzes
            
            DispatchQueue.main.async {
                if quizzes == nil {
                    self!.dogodilaSeGreska.isHidden = false
                }
                else {
                    var brojPitanjaNBA = 0
                    
                    for quiz in quizzes! {
                        let questions = quiz.questions
                        
                        let contains = questions.filter { (singleQuestion) -> Bool in
                            return singleQuestion.question.contains("NBA") == true
                        }
                        
                        brojPitanjaNBA += contains.count
                    }
                    
                    
                    
                    self?.funFact.text = "Fun Fact: Ukupno pitanja koji sadrže riječ NBA: \(brojPitanjaNBA)"
                    
                    let randomQuizIndex = Int.random(in: 0..<quizzes!.count)
                    let selectedQuiz = quizzes![randomQuizIndex]
                    
                    self!.naslovKviza.text = "\(selectedQuiz.title)"
                    
                    let url = URL(string: quizzes![randomQuizIndex].image)
                    let data = try? Data(contentsOf: url!)
                    self?.slikaKviza.image = UIImage(data: data!)
                    
                    let randomQuestionIndex = Int.random(in: 0..<selectedQuiz.questions.count)
                    let selectedQuestion = selectedQuiz.questions[randomQuestionIndex]
                    
                    let questionText = selectedQuestion.question
                    let answer0 = selectedQuestion.answers[0]
                    let answer1 = selectedQuestion.answers[1]
                    let answer2 = selectedQuestion.answers[2]
                    let answer3 = selectedQuestion.answers[3]
                    self!.correct_answer = selectedQuestion.correct_answer
                    
                    self!.questionView.pitanje.text = "\(questionText)"
                    self!.questionView.odgovor1.setTitle("\(answer0)", for: .normal)
                    self!.questionView.odgovor2.setTitle("\(answer1)", for: .normal)
                    self!.questionView.odgovor3.setTitle("\(answer2)", for: .normal)
                    self!.questionView.odgovor4.setTitle("\(answer3)", for: .normal)
                }
            }
        }
    }
    
    func clearQuestion() {
        naslovKviza.text = "Kviz"
        slikaKviza.image = nil
        questionView.pitanje.text = ""
        questionView.odgovor1.setTitle("", for: .normal)
        questionView.odgovor2.setTitle("", for: .normal)
        questionView.odgovor3.setTitle("", for: .normal)
        questionView.odgovor4.setTitle("", for: .normal)
        
        questionView.odgovor1.backgroundColor = UIColor.white
        questionView.odgovor2.backgroundColor = UIColor.white
        questionView.odgovor3.backgroundColor = UIColor.white
        questionView.odgovor4.backgroundColor = UIColor.white
        
        answered = false
        dogodilaSeGreska.isHidden = true
    }
}

