//
//  BaseVC.swift
//  AnalogueTimeApp
//
//  Created by Pravin Gawale on 23/09/18.
//  Copyright © 2018 Anita Smith. All rights reserved.
//

import UIKit
import Floaty

class BaseVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let floaty = Floaty()
        floaty.buttonImage = UIImage(named: "settings")
        floaty.contentMode = .scaleAspectFit
        floaty.tintColor = UIColor.white
        floaty.itemTitleColor = UIColor.white
        floaty.buttonColor = UIColor(red: 46/255, green: 146/255, blue: 4/255, alpha: 1.0)
        floaty.hasShadow = false
        
        
        floaty.addItem("Continue learning", icon: UIImage(named: "clock_blank")!, handler: { item in
            self.navigationController?.popToRootViewController(animated: true)
            floaty.close()
        })
        
        floaty.addItem("Modes", icon: UIImage(named: "clock_blank")!, handler: { item in
            
            if !(self.navigationController?.topViewController is ModesVC){
                DispatchQueue.main.async {

                    let prevLoginVC = self.storyboard?.instantiateViewController(withIdentifier: "ModesVC") as! ModesVC

                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let clockVC = storyboard.instantiateViewController(withIdentifier: "ClockVC") as! ClockVC
                    self.navigationController?.viewControllers = [clockVC,prevLoginVC]
                }
            }

            floaty.close()
        })
        
        floaty.addItem("Info", icon: UIImage(named: "clock_blank")!, handler: { item in
            if !(self.navigationController?.topViewController is AboutAppVC){
                
                let aboutAppVC = self.storyboard?.instantiateViewController(withIdentifier: "AboutAppVC") as! AboutAppVC
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let clockVC = storyboard.instantiateViewController(withIdentifier: "ClockVC") as! ClockVC
                self.navigationController?.viewControllers = [clockVC,aboutAppVC]
                
            }

            floaty.close()
        })
        
        floaty.addItem("Settings", icon: UIImage(named: "clock_blank")!, handler: { item in
            if !(self.navigationController?.topViewController is SettingsVC){

                let prevLoginVC = self.storyboard?.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let clockVC = storyboard.instantiateViewController(withIdentifier: "ClockVC") as! ClockVC
                self.navigationController?.viewControllers = [clockVC,prevLoginVC]


            }
            floaty.close()
        })
        
        floaty.addItem("Your stats", icon: UIImage(named: "clock_blank")!, handler: { item in
            if !(self.navigationController?.topViewController is YourStatsVC){
                
                let yourStatsVC = self.storyboard?.instantiateViewController(withIdentifier: "YourStatsVC") as! YourStatsVC
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let clockVC = storyboard.instantiateViewController(withIdentifier: "ClockVC") as! ClockVC
                self.navigationController?.viewControllers = [clockVC,yourStatsVC]
                
                
            }
            floaty.close()
        })
        
        floaty.addItem("Top Students", icon: UIImage(named: "clock_blank")!, handler: { item in
            if !(self.navigationController?.topViewController is TopStudentVC){
                
                let topStudentVC = self.storyboard?.instantiateViewController(withIdentifier: "TopStudentVC") as! TopStudentVC
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let clockVC = storyboard.instantiateViewController(withIdentifier: "ClockVC") as! ClockVC
                self.navigationController?.viewControllers = [clockVC,topStudentVC]
                
                
            }
            floaty.close()
        })
        self.view.addSubview(floaty)
        
    }


}
