//
//  ListaKvizovaViewController.swift
//  QuizApp
//
//  Created by Mihael Puceković on 27/05/2020.
//  Copyright © 2020 Mihael. All rights reserved.
//

import UIKit
import CoreData

class ListaKvizovaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var dogodilaSeGreska: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var quizzesDB = [Quiz]()
    var refreshControl: UIRefreshControl!
    var quiz: Quiz?
    var categoriesArray = [String]()
    var quizzesArray = [[Quiz]]()
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    var loadedFromServer = false
    let reachability = try! Reachability()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.navigationItem.hidesBackButton = true
        
        tableView.delegate = self
        tableView.dataSource = self
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(ListaKvizovaViewController.refresh), for: UIControl.Event.valueChanged)
        tableView.refreshControl = refreshControl
        
        tableView.register(UINib(nibName: "QuizTableViewCell", bundle: nil), forCellReuseIdentifier: "quizCellReuseIdentifier")
        
        dohvatiKvizoveIzBaze()
        self.refresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do {
          try reachability.startNotifier()
        } catch {
          print("Could not start reachability notifier")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
    }
    
    @objc func reachabilityChanged(note: Notification) {
      let reachability = note.object as! Reachability

      if reachability.connection != .unavailable && !loadedFromServer {
        dohvatiKvizoveSaServera()
      }
    }
    
    func dohvatiKvizoveIzBaze() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "QuizCD")
        var quizzesTemp = [Quiz]()

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
                    
                quizzesTemp.append(quiz)
            }
            
            self.quizzesDB = quizzesTemp
        } catch {
            print("Quiz fetch failed.")
        }
    }
    
    func dohvatiKvizoveSaServera() {
        QuizService().fetchQuizzes() { [weak self] (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let quizzes as [Quiz]):
                    self!.spremanjeIAzuriranjeKvizova(quizzesServer: quizzes)
                case .failure( _):
                    self!.dogodilaSeGreska.isHidden = false
                case .error(_):
                    self!.dogodilaSeGreska.isHidden = false
                case .none:
                    break
                case .some(.success(_)):
                    break
                }
            }
        }
    }
    
    func spremanjeIAzuriranjeKvizova(quizzesServer: [Quiz]) {
        for quizServer in quizzesServer {
            let urlString = URL(string: quizServer.image)
            let imageData = try? Data(contentsOf: urlString!)
            
            if quizzesDB.contains(where: { $0.id == quizServer.id }) {
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: "QuizCD")
                request.predicate = NSPredicate(format: "id = %@", "\(quizServer.id)")
                
                do {
                    let result = try context?.fetch(request)
                    let quizUpdate = result![0] as! NSManagedObject
                    
                    quizUpdate.setValue(quizServer.id, forKey: "id")
                    quizUpdate.setValue(quizServer.title, forKey: "title")
                    quizUpdate.setValue(quizServer.description, forKey: "desc")
                    quizUpdate.setValue(quizServer.category, forKey: "category")
                    quizUpdate.setValue(quizServer.level, forKey: "level")
                    quizUpdate.setValue(quizServer.image, forKey: "image")
                    quizUpdate.setValue(imageData, forKey: "imageData")
                    quizUpdate.setValue(quizServer.questions, forKey: "questions")
                    
                } catch {
                    print("Quiz update failed.")
                }
            } else {
                let entity = NSEntityDescription.entity(forEntityName: "QuizCD", in: context!)
                let newQuiz = NSManagedObject(entity: entity!, insertInto: context)
                newQuiz.setValue(quizServer.id, forKey: "id")
                newQuiz.setValue(quizServer.title, forKey: "title")
                newQuiz.setValue(quizServer.description, forKey: "desc")
                newQuiz.setValue(quizServer.category, forKey: "category")
                newQuiz.setValue(quizServer.level, forKey: "level")
                newQuiz.setValue(quizServer.image, forKey: "image")
                newQuiz.setValue(imageData, forKey: "imageData")
                newQuiz.setValue(quizServer.questions, forKey: "questions")
            }
            
            do {
                try context?.save()
            } catch {
               print("Error during saving.")
            }
        }
        
        dohvatiKvizoveIzBaze()
        self.refresh()
        loadedFromServer = true
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
        performSegue(withIdentifier: "segueKvizEkran", sender: indexPath.row)
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
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        var sectionView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        if section == categoriesArray.count - 1 {
            sectionView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 50))
            sectionView.backgroundColor = UIColor.white
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 50))
            button.setTitle("Logout", for: .normal)
            button.setTitleColor(.systemBlue, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            button.addTarget(self, action: #selector(odjava), for: .touchUpInside)
            sectionView.addSubview(button)
        }
        
        return sectionView
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == categoriesArray.count - 1 {
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
        userDefaults.set("", forKey: "username")
        
        self.navigationController!.popViewController(animated: true)
    }
}
