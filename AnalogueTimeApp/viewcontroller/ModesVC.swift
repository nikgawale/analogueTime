//
//  ModesVC.swift
//  AnalogueTimeApp
//
//  Created by Pravin Gawale on 23/09/18.
//  Copyright © 2018 Anita Smith. All rights reserved.
//

import UIKit

class ModesVC: BaseVC {
    
    @IBOutlet weak var control: TTSegmentedControl!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        control.itemTitles = ["Item1", "Item2", "Item3","Item4","Item5"]
        control.selectItemAt(index: 0, animated: false)
        control.layer.cornerRadius = 25.0
        control.layer.borderWidth = 1
        control.layer.borderColor = UIColor.gray.cgColor
        control.allowChangeThumbWidth  = true
        control.changeThumbColor(UIColor.red)
    }
    
    @IBAction func startAction(_ sender: Any) {
        print("selcted = \(control.currentIndex)")
        control.selectItemAt(index: 0, animated: true)
        
        switch control.currentIndex {
        case 0:
            let modeVC = self.storyboard?.instantiateViewController(withIdentifier: "ModeClockVC") as! ModeClockVC
            modeVC.viewModel.type = .DEMO
            self.navigationController?.pushViewController(modeVC, animated: true)
        case 1:
            let modeVC = self.storyboard?.instantiateViewController(withIdentifier: "ModeClockVC") as! ModeClockVC
            modeVC.viewModel.type = .WE_DRIVE
            self.navigationController?.pushViewController(modeVC, animated: true)

        case 2:
            let modeVC = self.storyboard?.instantiateViewController(withIdentifier: "ModeClockVC") as! ModeClockVC
            modeVC.viewModel.type = .YOU_DRIVE
            self.navigationController?.pushViewController(modeVC, animated: true)
        case 3:
            let countVC = self.storyboard?.instantiateViewController(withIdentifier: "CountVC") as! CountVC
            countVC.isCountBy5Selected = true
            self.navigationController?.pushViewController(countVC, animated: true)
        case 4:
            let countVC = self.storyboard?.instantiateViewController(withIdentifier: "CountVC") as! CountVC
            countVC.isCountBy5Selected = false
            self.navigationController?.pushViewController(countVC, animated: true)

        default:
            print("Default")
        }
    }
}
