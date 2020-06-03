//
//  LoginViewController.swift
//  QuizApp
//
//  Created by Mihael Puceković on 11/05/2020.
//  Copyright © 2020 Mihael. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var korisnickoIme: UITextField!
    @IBOutlet weak var lozinka: UITextField!
    @IBOutlet weak var dogodilaSeGreska: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        provjera()
    }
    
    @IBAction func logiraj(_ sender: UIButton) {
        dogodilaSeGreska.isHidden = true
        
        let username = korisnickoIme.text
        let password = lozinka.text
        
        LoginService().login(username: username!, password: password!) {(response) in
            DispatchQueue.main.async {
                if response == "Success" {
                    self.prikaziListuKvizova()
                }
                else {
                    self.dogodilaSeGreska.isHidden = false
                }
            }
        }
    }
    
    func provjera() {
        let userDefaults = UserDefaults.standard
        if let token = userDefaults.string(forKey: "token"), let user_id = userDefaults.string(forKey: "user_id") {
            if token != "" && user_id != "" {
                prikaziListuKvizova()
            }
        }
    }
    
    func prikaziListuKvizova() {
        performSegue(withIdentifier: "segueListaKvizova", sender: self)
    }
}
