//
//  LoginViewController.swift
//  QuizApp
//
//  Created by Mihael Puceković on 11/05/2020.
//  Copyright © 2020 Mihael. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var quizApp: UILabel!
    @IBOutlet weak var korisnickoIme: UITextField!
    @IBOutlet weak var lozinka: UITextField!
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var dogodilaSeGreska: UILabel!
    @IBOutlet weak var dogodilaSeGreskaBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var korisnickoImeLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var korisnickoImeRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var lozinkaLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var lozinkaRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginRightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        provjera()
        animirajDolazak()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        dogodilaSeGreskaBottomConstraint.constant = self.view.frame.size.height/4
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIApplication.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIApplication.keyboardWillShowNotification, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillAppear(notification: NSNotification) {
        let userInfo = notification.userInfo!
        let keyboardHeight = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height

        dogodilaSeGreskaBottomConstraint.constant = keyboardHeight + 10
            
        let duration: TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue

        UIView.animate(withDuration: duration) { self.view.layoutIfNeeded() }
    }

    @objc func keyboardWillDisappear(notification: NSNotification) {
        let userInfo = notification.userInfo!
        
        dogodilaSeGreskaBottomConstraint.constant = self.view.frame.size.height/4
        
        let duration: TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue

        UIView.animate(withDuration: duration) { self.view.layoutIfNeeded() }
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
        performSegue(withIdentifier: "segueTabBar", sender: self)
    }
    
    @IBAction func logiraj(_ sender: UIButton) {
        dogodilaSeGreska.isHidden = true
        
        let username = korisnickoIme.text
        let password = lozinka.text
        
        LoginService().login(username: username!, password: password!) {(result) in
            DispatchQueue.main.async {
                switch result {
                case .success( _):
                    self.animirajOdlazak()
                case .failure( _):
                    self.dogodilaSeGreska.isHidden = false
                case .error(_):
                    self.dogodilaSeGreska.isHidden = false
                case .none:
                    break
                }
            }
        }
    }
    
    func animirajDolazak() {
        quizApp.alpha = 0
        quizApp.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseOut, animations: {
            self.quizApp.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.quizApp.alpha = 1
        })
            
        korisnickoIme.alpha = 0
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseOut, animations: {
            self.korisnickoIme.frame.origin.x = UIScreen.main.bounds.size.width
            self.korisnickoIme.alpha = 1
        })
        
        lozinka.alpha = 0
        UIView.animate(withDuration: 1.0, delay: 0.25, options: .curveEaseOut, animations: {
            self.lozinka.frame.origin.x = UIScreen.main.bounds.size.width
            self.lozinka.alpha = 1
        })
        
        login.alpha = 0
        UIView.animate(withDuration: 1.0, delay: 0.5, options: .curveEaseOut, animations: {
            self.login.frame.origin.x = UIScreen.main.bounds.size.width
            self.login.alpha = 1
        })
    }
    
    func animirajOdlazak() {
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseOut, animations: {
            self.quizApp.transform = self.login.transform.translatedBy(x: 0.0, y: -UIScreen.main.bounds.size.height)
            self.quizApp.alpha = 0
        }, completion: { (finished: Bool) in
            self.prikaziListuKvizova()
            self.dogodilaSeGreska.isHidden = true
            
            self.quizApp.transform = self.quizApp.transform.translatedBy(x: 0.0, y: UIScreen.main.bounds.size.height)
            self.quizApp.alpha = 1
        })
            
        UIView.animate(withDuration: 1.0, delay: 0.25, options: .curveEaseOut, animations: {
            self.korisnickoIme.transform = self.korisnickoIme.transform.translatedBy(x: 0.0, y: -UIScreen.main.bounds.size.height)
            self.korisnickoIme.alpha = 0
        }, completion: { (finished: Bool) in
            self.korisnickoIme.transform = self.korisnickoIme.transform.translatedBy(x: 0.0, y: UIScreen.main.bounds.size.height)
            self.korisnickoIme.alpha = 1
        })
        
        UIView.animate(withDuration: 1.0, delay: 0.5, options: .curveEaseOut, animations: {
            self.lozinka.transform = self.lozinka.transform.translatedBy(x: 0.0, y: -UIScreen.main.bounds.size.height)
            self.lozinka.alpha = 0
        }, completion: { (finished: Bool) in
            self.lozinka.transform = self.lozinka.transform.translatedBy(x: 0.0, y: UIScreen.main.bounds.size.height)
            self.lozinka.alpha = 1
        })
        
        UIView.animate(withDuration: 1.0, delay: 0.75, options: .curveEaseOut, animations: {
            self.login.transform = self.login.transform.translatedBy(x: 0.0, y: -UIScreen.main.bounds.size.height)
            self.login.translatesAutoresizingMaskIntoConstraints = false;
            self.login.alpha = 0
        }, completion: { (finished: Bool) in
            self.login.transform = self.login.transform.translatedBy(x: 0.0, y: UIScreen.main.bounds.size.height)
            self.login.alpha = 1
        })
    }
}
