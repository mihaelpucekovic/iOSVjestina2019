//
//  KvizEkranViewController.swift
//  QuizApp
//
//  Created by Mihael Puceković on 28/05/2020.
//  Copyright © 2020 Mihael. All rights reserved.
//

import UIKit
import CoreData

class KvizEkranViewController: UIViewController, UIButtonDelegate, UIScrollViewDelegate {

    @IBOutlet weak var naslovKviza: UILabel!
    @IBOutlet weak var slikaKviza: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var labelCorrect: UILabel!
    @IBOutlet weak var startQuiz: UIButton!
    @IBOutlet weak var currentQuestionNumber: UILabel!
    
    var correct_answer = -1
    var currentQuestionIndex = 0
    var totalQuestions = 0
    var totalCorrectAnswers = 0
    var answered = false
    var quiz: Quiz?
    var questionViews: [QuestionView] = []
    var startTime:Date!
    var endTime:Date!
    var totalQuizTime = 0.0
    var startQuizTime = 0.0
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.delegate = self
        setQuiz()
    }
    
    func setQuiz() {
        self.naslovKviza.text = "\(quiz!.title)"
        self.slikaKviza.image = UIImage(data: quiz!.imageData)
        
        totalQuestions = quiz?.questions.count ?? 0
            
        questionViews = createQuestionViews()
        setupScrollView()
        
        dohvatiStanjeIzBaze()
        
        if currentQuestionIndex > 0 {
            let alert = UIAlertController(title: "Continuing quiz", message: "Continuing already started quiz.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
                self.startSetup()
                
                self.labelCorrect.text = "Correct: \(self.totalCorrectAnswers)"
                
                self.scrollView.setContentOffset(CGPoint(x: self.view.frame.width * CGFloat(self.currentQuestionIndex), y: 0), animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func startQuiz(_ sender: UIButton) {
        startSetup()
    }
    
    func startSetup() {
        currentQuestionNumber.text = "Question \(currentQuestionIndex + 1)/\(totalQuestions)"
        self.startQuiz.isHidden = true
        self.scrollView.isHidden = false
        self.labelCorrect.isHidden = false
        self.currentQuestionNumber.isHidden = false
        startTime = Date()
    }
    
    @IBAction func odjava(_ sender: UIButton) {
        let userDefaults = UserDefaults.standard
        userDefaults.set("", forKey: "token")
        userDefaults.set("", forKey: "user_id")
        userDefaults.set("", forKey: "username")
        
        self.navigationController!.popToRootViewController(animated: true)
    }
    
   func selectedAnswer(_ sender: UIButton, answer: Int) {
    if currentQuestionIndex < totalQuestions {
        if !answered {
            if answer == quiz?.questions[currentQuestionIndex].correct_answer {
                 sender.backgroundColor = UIColor.green
                 
                 totalCorrectAnswers += 1
                 self.labelCorrect.text = "Correct: \(totalCorrectAnswers)"
             }
             else {
                 sender.backgroundColor = UIColor.red
             }
                              
             answered = true
        }
               
        currentQuestionIndex += 1
        totalQuizTime = startQuizTime + Date().timeIntervalSince(startTime)
        
        azurirajStanjeUBazi(startQuestionIndex : currentQuestionIndex, correctAnswers : totalCorrectAnswers, currentQuizTime: totalQuizTime)
        
        if currentQuestionIndex < totalQuestions {
            currentQuestionNumber.text = "Question \(currentQuestionIndex + 1)/\(totalQuestions)"
            
            scrollView.setContentOffset(CGPoint(x: view.frame.width * CGFloat(currentQuestionIndex), y: 0), animated: true)
                 
            answered = false
        }
        else {
            quizFinished()
        }
    }
   }
    
    func quizFinished() {
        azurirajStanjeUBazi(startQuestionIndex : 0, correctAnswers : 0, currentQuizTime: 0.0)
        
        totalQuizTime = startQuizTime + Date().timeIntervalSince(startTime)
        
        sendQuizResult()
    }
    
    func sendQuizResult() {
        let userDefaults = UserDefaults.standard
        let token = userDefaults.string(forKey: "token")
        let user_id = userDefaults.integer(forKey: "user_id")
                
        SendQuizResultService().sendQuizResults(quiz_id: quiz!.id, user_id: user_id, time: totalQuizTime, no_of_correct: totalCorrectAnswers, token: token!) {(result) in
                    DispatchQueue.main.async {
                        switch result {
                        case .success( _):
                            let alert = UIAlertController(title: "Finished", message: "Quiz is finished! Correct answers \(self.totalCorrectAnswers).", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "Back", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
                                self.navigationController!.popViewController(animated: true)
                            }))
                            self.present(alert, animated: true, completion: nil)
                        case .failure(let message):
                            let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "Send again", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
                             self.sendQuizResult()
                            }))
                            alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.cancel, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        case .none: break
                        case .some(.error(_)): break
                        }
                    }
                }
    }
    
    func createQuestionViews() -> [QuestionView] {
        var views: [QuestionView] = []
        
        for question in quiz!.questions {
            let view:QuestionView = Bundle.main.loadNibNamed("QuestionView", owner: self, options: nil)?.first as! QuestionView
            view.pitanje.text = question.question
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
    
    func setupScrollView() {
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
    
    func dohvatiStanjeIzBaze() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "QuizCD")
        request.predicate = NSPredicate(format: "id = %@", "\(quiz!.id)")

        do {
            let result = try context?.fetch(request)
            let data = result![0] as! NSManagedObject
            
            currentQuestionIndex = data.value(forKey: "startQuestionIndex") as? Int ?? 0
            totalCorrectAnswers = data.value(forKey: "correctAnswers") as? Int ?? 0
            startQuizTime = data.value(forKey: "currentQuizTime") as? Double ?? 0
        } catch {
            print("Quiz fetch failed.")
        }
    }
    
    func azurirajStanjeUBazi(startQuestionIndex : Int, correctAnswers : Int, currentQuizTime : Double) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "QuizCD")
        request.predicate = NSPredicate(format: "id = %@", "\(quiz!.id)")
        
        do {
            let result = try context?.fetch(request)
            let quizUpdate = result![0] as! NSManagedObject
            
            quizUpdate.setValue(startQuestionIndex, forKey: "startQuestionIndex")
            quizUpdate.setValue(correctAnswers, forKey: "correctAnswers")
            quizUpdate.setValue(currentQuizTime, forKey: "currentQuizTime")
        } catch {
            print("Quiz update failed.")
        }
        
        do {
            try context?.save()
        } catch {
            print("Error during saving.")
        }
    }
}

