//
//  YourStatsVC.swift
//  AnalogueTimeApp
//
//  Created by Pravin Gawale on 30/09/18.
//  Copyright © 2018 Anita Smith. All rights reserved.
//

import UIKit
import JGProgressHUD

class YourStatsVC: BaseVC {

    @IBOutlet weak var totalAppUsage: UILabel!
    
    @IBOutlet weak var todaysAppUSage: UILabel!
    
    @IBOutlet weak var correctAns: UILabel!
    
    @IBOutlet weak var currentLevel: UILabel!
    
    let loder = JGProgressHUD(style: .extraLight)

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let delegate = UIApplication.shared.delegate as! AppDelegate
        
        loder.show(in: self.view)
        
        if let user = DataManager.sharedManager.getUser() {
            let sec =  Calendar.current.dateComponents([.second], from: delegate.totalUsage, to: Date()).second ?? 0
            print("Minutes = \(0) , second = \(sec) ")
            
            
            let appUsage = AppUsageInfoObj()
            appUsage.totalUsageTime = "\(sec +  (Int(user.totalAppUsage) ?? 0))"
            appUsage.uploaded = false
            
            CoreDataManager.shared.deleteAppUsageInfo { (sucess) in
                CoreDataManager.shared.saveAppUsageInfo(appUsage)
            }
            
            let dayappUsage = DayAppUsageObj()
            
            dayappUsage.totalDayAppUsageTime = "\(sec + (Int(user.todaysAppUsage) ?? 0))"
            dayappUsage.uploaded = false
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .none
            print(dateFormatter.string(from: Date())) // Jan 2, 2001
            let day = dateFormatter.string(from: Date())
            dayappUsage.day = day
            var totalDaysUsage = 0
            if day == user.todaysDay || (user.todaysDay == "0"){
                totalDaysUsage = sec +  (Int(user.todaysAppUsage) ?? 0)
            } else {
                totalDaysUsage = (Int(user.todaysAppUsage) ?? 0)
            }
            

            dayappUsage.totalDayAppUsageTime = "\(totalDaysUsage)"
            dayappUsage.uploaded = false
            CoreDataManager.shared.deleteDaysAppUsage { (success) in
                CoreDataManager.shared.saveDaysAppUsage(dayappUsage)
            }
            
            delegate.doBackgroundUploadDaysAppUsage(appUsage: appUsage, dayUsage: dayappUsage) { (success) in
                
                self.loder.dismiss()
                let totalAppUsageF = String(format: "%.2f", Double(Double(appUsage.totalUsageTime)!/60))
                let totalDaysUsageF = String(format: "%.2f", Double(Double(totalDaysUsage)/60))
                self.totalAppUsage.text = "\(totalAppUsageF) mins"
                self.todaysAppUSage.text = "\(totalDaysUsageF) mins"
                self.correctAns.text = user.correctAns
                self.currentLevel.text = user.level
            }

        }
    }

}
