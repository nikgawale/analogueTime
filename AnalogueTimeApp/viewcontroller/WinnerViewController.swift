//
//  WinnerViewController.swift
//  AnalogueTimeApp
//
//  Created by Pravin Gawale on 09/10/18.
//  Copyright © 2018 Anita Smith. All rights reserved.
//

import UIKit

class WinnerViewController: UIViewController {
    @IBOutlet weak var congratsLabel: UILabel!
    
    @IBOutlet weak var congratsImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func closeButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true) {
            
        }
    }

}
