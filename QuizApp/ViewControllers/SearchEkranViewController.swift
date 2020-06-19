//
//  SearchEkranViewController.swift
//  QuizApp
//
//  Created by Mihael Puceković on 16/06/2020.
//  Copyright © 2020 Mihael. All rights reserved.
//

import UIKit
import CoreData

class SearchEkranViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pretraziTextField: UITextField!
    
    var quizzesDB = [Quiz]()
    var refreshControl: UIRefreshControl!
    var quiz: Quiz?
    var categoriesArray = [String]()
    var quizzesArray = [[Quiz]]()
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(ListaKvizovaViewController.refresh), for: UIControl.Event.valueChanged)
        tableView.refreshControl = refreshControl
        
        tableView.register(UINib(nibName: "QuizTableViewCell", bundle: nil), forCellReuseIdentifier: "quizCellReuseIdentifier")
    }
    
    func pretraziKvizove(rijec: String) {
        self.quizzesDB = [Quiz]()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "QuizCD")
        request.predicate = NSPredicate(format: "title CONTAINS[c] %@ OR desc CONTAINS[c] %@", rijec, rijec)
        
        do {
            let result = try context?.fetch(request)
            
            for data in result as! [NSManagedObject] {
                
                let id = data.value(forKey: "id") as? Int ?? 0
                let title = data.value(forKey: "title") as? String ?? ""
                let description = data.value(forKey: "desc") as? String ?? ""
                let category = data.value(forKey: "category") as? String ?? ""
                let level = data.value(forKey: "level") as? Int ?? 0
                let image = data.value(forKey: "image") as? String ?? ""
                let imageData = data.value(forKey: "imageData") as? Data ?? Data()
                let questions = data.value(forKey: "questions") as? [Question] ?? [Question]()
                let quiz = Quiz(id: id, title: title, description: description, category: category, level: level, image: image, imageData: imageData, questions: questions)
                    
                self.quizzesDB.append(quiz)
            }
        } catch {
            print("Quiz fetch failed.")
        }
        
        self.refresh()
    }
    
    @objc func refresh() {
        self.categoriesArray = [String]()
        self.quizzesArray = [[Quiz]]()
        
        for quiz in self.quizzesDB {
            let category = quiz.category
            
            if !self.categoriesArray.contains(category) {
                self.categoriesArray.append(category)
                var tempQuizzes = [Quiz]()
                
                for quiz2 in self.quizzesDB {
                    if quiz2.category == category {
                        tempQuizzes.append(quiz2)
                    }
                }
                
                self.quizzesArray.append(tempQuizzes)
            }
        }
        
        self.tableView.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return categoriesArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (quizzesArray[section].count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "quizCellReuseIdentifier", for: indexPath) as! QuizTableViewCell
        
        quiz = quizzesArray[indexPath.section][indexPath.row]
        cell.setup(withQuiz: quiz!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        quiz = quizzesArray[indexPath.section][indexPath.row]
        performSegue(withIdentifier: "segueKvizEkranFromSearch", sender: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 40))
        
        if categoriesArray[section] == "SPORTS" {
            sectionView.backgroundColor = UIColor.systemGreen
        }
        else if categoriesArray[section] == "SCIENCE" {
            sectionView.backgroundColor = UIColor.systemBlue
        }
        else {
            sectionView.backgroundColor = UIColor.orange
        }
        
        let sectionName = UILabel(frame: CGRect(x: 10, y: 0, width: tableView.frame.size.width, height: 40))
        sectionName.text = categoriesArray[section]
        sectionName.textColor = UIColor.white
        sectionName.font = UIFont.systemFont(ofSize: 15)
        sectionName.textAlignment = .left

        sectionView.addSubview(sectionName)
        return sectionView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueKvizEkranFromSearch" {
            let kvizEkranViewController = segue.destination as! KvizEkranViewController
            
            kvizEkranViewController.quiz = quiz
        }
    }
    
    @IBAction func pretrazi(_ sender: UIButton) {
        let rijec = pretraziTextField.text ?? ""

        pretraziKvizove(rijec: rijec)
    }
}

