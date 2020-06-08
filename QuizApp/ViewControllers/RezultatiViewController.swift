//
//  RezultatiViewController.swift
//  QuizApp
//
//  Created by Mihael Puceković on 07/06/2020.
//  Copyright © 2020 Mihael. All rights reserved.
//

import UIKit

class RezultatiViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var dogodilaSeGreska: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var quiz_id:Int = 0
    var results: [Result]?
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(ListaKvizovaViewController.refresh), for: UIControl.Event.valueChanged)
        tableView.refreshControl = refreshControl
        
        tableView.register(UINib(nibName: "ResultTableViewCell", bundle: nil), forCellReuseIdentifier: "resultCellReuseIdentifier")
        
        dohvatiRezultate()
    }
    
    func dohvatiRezultate() {
        let userDefaults = UserDefaults.standard
        let token = userDefaults.string(forKey: "token")
        
        QuizResultsService().getQuizResults(quiz_id: quiz_id, token: token!) { [weak self] (results) in
            self!.results = results
            self?.refresh()
        }
    }
    
    @objc func refresh() {
        DispatchQueue.main.async {
            if self.results == nil {
                self.dogodilaSeGreska.isHidden = false
            }
            else {
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (results?.count) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultCellReuseIdentifier", for: indexPath) as! ResultTableViewCell
        
        if let result = results?[indexPath.row] {
            cell.setup(withResult: result, withRow: indexPath.row)
        }
        
        return cell
    }
}

