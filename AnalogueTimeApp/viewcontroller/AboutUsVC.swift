//
//  AboutUsVC.swift
//  AnalogueTimeApp
//
//  Created by Pravin Gawale on 28/09/18.
//  Copyright © 2018 Anita Smith. All rights reserved.
//

import UIKit
enum Type {
    case TwentyFourHoursInDay
    case EllysTraining
    case AboutUs
}

class AboutUsVC: BaseVC {

    @IBOutlet weak var bgImage: UIImageView!
    
    var type = Type.TwentyFourHoursInDay
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        switch type {
        case .TwentyFourHoursInDay:
            bgImage.image = UIImage(named: "24_hours_in_a_day")
        case .EllysTraining:
            bgImage.image = UIImage(named: "About_Elly")
        case .AboutUs:
            bgImage.image = UIImage(named: "aboutUs")
        }
    }
}
