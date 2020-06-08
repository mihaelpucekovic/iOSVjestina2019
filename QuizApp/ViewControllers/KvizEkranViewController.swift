//
//  KvizEkranViewController.swift
//  QuizApp
//
//  Created by Mihael Puceković on 28/05/2020.
//  Copyright © 2020 Mihael. All rights reserved.
//

import UIKit

class KvizEkranViewController: UIViewController, UIButtonDelegateSQ, UIScrollViewDelegate {

    @IBOutlet weak var naslovKviza: UILabel!
    @IBOutlet weak var slikaKviza: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var labelCorrect: UILabel!
    @IBOutlet weak var startQuiz: UIButton!
    
    var correct_answer = -1
    var current_question_index = 0
    var totalQuestions = 0
    var totalCorrectAnswers = 0
    var answered = false
    var quiz: Quiz?
    var questionViews: [SingleQuestionView] = []
    var startTime:Date!
    var endTime:Date!
    var quizTime:Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.delegate = self
        setQuiz()
    }
    
    func setQuiz() {
        self.naslovKviza.text = "\(quiz!.title)"
        let url = URL(string: quiz!.image)
        let data = try? Data(contentsOf: url!)
        self.slikaKviza.image = UIImage(data: data!)
        
        totalQuestions = quiz?.questions.count ?? 0
            
        questionViews = createQuestionViews()
        setupScrollView(singleQuestionView: questionViews)
    }
    
    @IBAction func startQuiz(_ sender: UIButton) {
        self.startQuiz.isHidden = true
        self.scrollView.isHidden = false
        self.labelCorrect.isHidden = false
        
        startTime = Date()
    }
    
    @IBAction func odjava(_ sender: UIButton) {
        let userDefaults = UserDefaults.standard
        userDefaults.set("", forKey: "token")
        userDefaults.set("", forKey: "user_id")
        
        self.navigationController!.popToRootViewController(animated: true)
    }
    
   func answerPressed(_ sender: UIButton, selectedAnswer: Int) {
    if current_question_index < totalQuestions {
        if !answered {
            if selectedAnswer == quiz?.questions[current_question_index].correct_answer {
                 sender.backgroundColor = UIColor.green
                 
                 totalCorrectAnswers += 1
                 self.labelCorrect.text = "Correct: \(totalCorrectAnswers)"
             }
             else {
                 sender.backgroundColor = UIColor.red
             }
                              
             answered = true
        }
               
        current_question_index += 1
               
        if current_question_index < totalQuestions {
            scrollView.setContentOffset(CGPoint(x: view.frame.width * CGFloat(current_question_index), y: 0), animated: true)
                 
            answered = false
        }
        else {
            quizFinished()
        }
    }
   }
    
    func quizFinished() {
        quizTime = Date().timeIntervalSince(startTime)
        
        sendQuizResult()
    }
    
    func sendQuizResult() {
        let userDefaults = UserDefaults.standard
        let token = userDefaults.string(forKey: "token")
        let user_id = userDefaults.integer(forKey: "user_id")
                
        SendQuizResultService().sendQuizResults(quiz_id: quiz!.id, user_id: user_id, time: quizTime, no_of_correct: totalCorrectAnswers, token: token!) {(response) in
                    DispatchQueue.main.async {
                        if response == "Success" {
                            self.navigationController!.popViewController(animated: true)
                        }
                        else {
                            let alert = UIAlertController(title: "Error", message: response, preferredStyle: UIAlertController.Style.alert)
                                   alert.addAction(UIAlertAction(title: "Pošalji ponovno", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
                                    self.sendQuizResult()
                                   }))
                                   alert.addAction(UIAlertAction(title: "Odustani", style: UIAlertAction.Style.cancel, handler: nil))
                                   self.present(alert, animated: true, completion: nil)
                        }
                    }
                }
    }
    
    func createQuestionViews() -> [SingleQuestionView] {
        var views: [SingleQuestionView] = []
        
        for question in quiz!.questions {
            let view:SingleQuestionView = Bundle.main.loadNibNamed("SingleQuestionView", owner: self, options: nil)?.first as! SingleQuestionView
            view.labelPitanje.text = question.question
            view.odgovor1.setTitle("\(question.answers[0])", for: .normal)
            view.odgovor2.setTitle("\(question.answers[1])", for: .normal)
            view.odgovor3.setTitle("\(question.answers[2])", for: .normal)
            view.odgovor4.setTitle("\(question.answers[3])", for: .normal)
            view.correct_answer = question.correct_answer
            
            view.delegate = self
            
            views.append(view)
        }
        
        return views
    }
    
    func setupScrollView(singleQuestionView : [SingleQuestionView]) {
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(questionViews.count), height: view.frame.height)
        scrollView.isPagingEnabled = true
        
        for i in 0 ..< questionViews.count {
            questionViews[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
            scrollView.addSubview(questionViews[i])
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueRezultati" {
            let rezultatiViewController = segue.destination as! RezultatiViewController
            
            rezultatiViewController.quiz_id = quiz!.id
        }
    }
}

