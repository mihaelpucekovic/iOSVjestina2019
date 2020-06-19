//
//  SettingsEkranViewController.swift
//  QuizApp
//
//  Created by Mihael Puceković on 15/06/2020.
//  Copyright © 2020 Mihael. All rights reserved.
//

import UIKit

class SettingsEkranViewController: UIViewController {

    @IBOutlet weak var username: UILabel!
    
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        username.text = "Username: \(userDefaults.integer(forKey: "username"))"
    }
    
    @IBAction func odjava(_ sender: UIButton) {
        userDefaults.set("", forKey: "token")
        userDefaults.set("", forKey: "user_id")
        userDefaults.set("", forKey: "username")
        
        self.navigationController!.popToRootViewController(animated: true)
    }
}
