//
//  TabBarViewController.swift
//  QuizApp
//
//  Created by Mihael Puceković on 17/06/2020.
//  Copyright © 2020 Mihael. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
   override func viewDidLoad() {
        super.viewDidLoad()
            
        let listaKvizovaViewController = self.storyboard?.instantiateViewController(withIdentifier: "listaKvizovaViewController")
        listaKvizovaViewController!.tabBarItem = UITabBarItem(title: "Quizzes", image: nil, selectedImage: nil)
        let searchEkranViewController = self.storyboard?.instantiateViewController(withIdentifier: "searchEkranViewController")
        searchEkranViewController!.tabBarItem = UITabBarItem(title: "Search", image: nil, selectedImage: nil)
        let settingsEkranViewController = self.storyboard?.instantiateViewController(withIdentifier: "settingsEkranViewController")
        settingsEkranViewController!.tabBarItem = UITabBarItem(title: "Settings", image: nil, selectedImage: nil)
        
        self.viewControllers = [listaKvizovaViewController!, searchEkranViewController!, settingsEkranViewController!]
    }
}
