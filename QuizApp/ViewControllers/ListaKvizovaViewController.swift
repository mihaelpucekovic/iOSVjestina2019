//
//  ListaKvizovaViewController.swift
//  QuizApp
//
//  Created by Mihael Puceković on 27/05/2020.
//  Copyright © 2020 Mihael. All rights reserved.
//

import UIKit

class ListaKvizovaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var dogodilaSeGreska: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var quizzes: [Quiz]?
    var refreshControl: UIRefreshControl!
    var quiz: Quiz?
    var categoriesDict: [Int : String] = [:]
    var quizzesDict: [Int : [Quiz]] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(ListaKvizovaViewController.refresh), for: UIControl.Event.valueChanged)
        tableView.refreshControl = refreshControl
        
        tableView.register(UINib(nibName: "QuizTableViewCell", bundle: nil), forCellReuseIdentifier: "quizCellReuseIdentifier")
        
        dohvatiKvizove()
    }
    
    func dohvatiKvizove() {
        let urlString = "https://iosquiz.herokuapp.com/api/quizzes"
        
        QuizService().fetchQuizzes(urlString: urlString) { [weak self] (quizzes) in
            self!.quizzes = quizzes
            self?.refresh()
        }
    }
    
    @objc func refresh() {
        DispatchQueue.main.async {
            if self.quizzes == nil {
                self.dogodilaSeGreska.isHidden = false
            }
            else {
                var categoriesTemp: [String] = []
                for quiz in self.quizzes! {
                    if !categoriesTemp.contains(quiz.category) {
                        categoriesTemp.append(quiz.category)
                    }
                }
                
                for (index, category) in categoriesTemp.enumerated() {
                    self.categoriesDict[index] = category
                }
                
                for (index, category) in categoriesTemp.enumerated() {
                    var tempQuizzes: [Quiz] = []
                    
                    for quiz in self.quizzes! {
                        if quiz.category == category {
                            tempQuizzes.append(quiz)
                        }
                    }
                    
                    self.quizzesDict[index] = tempQuizzes
                }
                
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return categoriesDict.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (quizzesDict[section]?.count) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "quizCellReuseIdentifier", for: indexPath) as! QuizTableViewCell
        
        if let quiz = quizzesDict[indexPath.section]?[indexPath.row] {
            cell.setup(withQuiz: quiz)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let quiz = quizzesDict[indexPath.section]?[indexPath.row]{
            self.quiz = quiz
            performSegue(withIdentifier: "segueKvizEkran", sender: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 40))
        
        if categoriesDict[section] == "SPORTS" {
            sectionView.backgroundColor = UIColor.systemGreen
        }
        else if categoriesDict[section] == "SCIENCE" {
            sectionView.backgroundColor = UIColor.systemBlue
        }
        else {
            sectionView.backgroundColor = UIColor.orange
        }
        
        let sectionName = UILabel(frame: CGRect(x: 10, y: 0, width: tableView.frame.size.width, height: 40))
        sectionName.text = categoriesDict[section]
        sectionName.textColor = UIColor.white
        sectionName.font = UIFont.systemFont(ofSize: 15)
        sectionName.textAlignment = .left

        sectionView.addSubview(sectionName)
        return sectionView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        var sectionView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        if section == categoriesDict.count - 1 {
            sectionView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 50))
            sectionView.backgroundColor = UIColor.white
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 50))
            button.setTitle("Odjava", for: .normal)
            button.setTitleColor(.systemBlue, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            button.addTarget(self, action: #selector(odjava), for: .touchUpInside)
            sectionView.addSubview(button)
        }
        
        return sectionView
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == categoriesDict.count - 1 {
            return 40
        }
        else {
            return 0
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueKvizEkran" {
            let kvizEkranViewController = segue.destination as! KvizEkranViewController
            
            kvizEkranViewController.quiz = quiz
        }
    }
    
    @objc func odjava() {
        let userDefaults = UserDefaults.standard
        userDefaults.set("", forKey: "token")
        userDefaults.set("", forKey: "user_id")
        
        self.navigationController!.popViewController(animated: true)
    }
}
