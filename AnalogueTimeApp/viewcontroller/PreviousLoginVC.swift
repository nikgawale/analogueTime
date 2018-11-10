//
//  PreviousLoginVC.swift
//  AnalogueTimeApp
//
//  Created by Pravin Gawale on 11/09/18.
//  Copyright © 2018 Anita Smith. All rights reserved.
//

import UIKit


class PreviousLoginVC: UIViewController {
    
    @IBAction func NewUserAction(_ sender: Any) {
        let clockVC = self.storyboard?.instantiateViewController(withIdentifier: "ClockVC") as! ClockVC
        let navigationController = self.navigationController!
        navigationController.setViewControllers([clockVC], animated: true)
        self.navigationController?.pushViewController(clockVC, animated: true)
    }

    @IBAction func experincedUserAction(_ sender: Any) {
        let clockVC = self.storyboard?.instantiateViewController(withIdentifier: "ClockVC") as! ClockVC
        let navigationController = self.navigationController!
        navigationController.setViewControllers([clockVC], animated: true)
        clockVC.level.isExperienced = true
        self.navigationController?.pushViewController(clockVC, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

}
