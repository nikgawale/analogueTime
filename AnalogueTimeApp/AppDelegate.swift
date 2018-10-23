//
//  AppDelegate.swift
//  AnalogueTimeApp
//
//  Created by Pravin Gawale on 09/09/18.
//  Copyright © 2018 Anita Smith. All rights reserved.
//

import UIKit
import CoreData
import Firebase


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var learningTimeCount = 0
    
    var window: UIWindow?

    var totalUsage = Date()

    var shouldSaveTime = false

    var bgTaskToUpdateAppUsage : UIBackgroundTaskIdentifier!
    var bgTaskToUpdateDaysAppUsage : UIBackgroundTaskIdentifier!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        


        if let _ = CoreDataManager.shared.getAppUsageInfo() {
            let appUsage = CoreDataManager.shared.getAppUsageInfo()

            let daysUsage = CoreDataManager.shared.getDaysAppUsage()
            
            doBackgroundUploadDaysAppUsage(appUsage: appUsage!, dayUsage: daysUsage!) { (success) in}
        }
        
        
        if DataManager.sharedManager.getUser() != nil {
            
            if let user = DataManager.sharedManager.getUser() {
                Database.database().reference().child("users").child(user.uid).observe(.value, with: { (snap : DataSnapshot) in
                    if let valueDict = snap.value as? [String: AnyObject] {
                        
                        var name = ""
                        var email = ""
                        var level = ""
                        var totalAppUsage = "0"
                        var todaysDay = "0"
                        var todaysAppUsage = "0"
                        var country = ""
                        var correctAns = ""

                        if let n = valueDict["name"] as? String {
                            name = n
                        }
                        if let em = valueDict["email"] as? String {
                            email = em
                        }
                        if let lvl = valueDict["level"] as? String {
                            level = lvl
                        }
                        if let appUsage = valueDict["totalAppUsage"] as? String {
                            totalAppUsage = appUsage
                        }
                        
                        if let appUsage = valueDict["totalDaysUsageTime"] as? String {
                            let fullNameArr = appUsage.components(separatedBy: "-")
                            todaysDay = fullNameArr[0]
                            todaysAppUsage = fullNameArr[1]
                        }
                        if let coun = valueDict["country"] as? String {
                            country = coun
                        }
                        if let ans = valueDict["correctAns"] as? String {
                            correctAns = ans
                        }

                        var teacherName = ""
                        var teacherEmail = ""
                        
                        if let tName = valueDict["teacherName"] as? String {
                            teacherName = tName
                        }
                        if let tEmail = valueDict["teacherEmail"] as? String {
                            teacherEmail = tEmail
                        }
                        
                        DataManager.sharedManager.removeUser()
                        
                        let user  = User(uid: user.uid, email: email, name: name, teacherName: teacherName, teacherEmail: teacherEmail, level: level, totalAppUsage: totalAppUsage, todaysDay: todaysDay, todaysAppUsage: todaysAppUsage, country: country, correctAns: correctAns)
                        DataManager.sharedManager.saveUser(user: user)
                    } else {
                        print("Some thing Went wrong, Check email address once again!")
                    }
                })
            }
            
            totalUsage = Date()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let clockVC = storyboard.instantiateViewController(withIdentifier: "ClockVC") as! ClockVC
            let navigationController:UINavigationController = storyboard.instantiateInitialViewController() as! UINavigationController
            navigationController.viewControllers = [clockVC]
            self.window?.rootViewController = navigationController
            self.window?.makeKeyAndVisible()
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func updateTimeToDBInBackground(onCompletion: @escaping (Bool) -> Void) {
        if let user = DataManager.sharedManager.getUser() {
            let sec =  Calendar.current.dateComponents([.second], from: totalUsage, to: Date()).second ?? 0
            print("Minutes = \(0) , second = \(sec) ")
            
            self.totalUsage = Date()
            
            
            let appUsage = AppUsageInfoObj()
            appUsage.totalUsageTime = "\(sec +  (Int(user.totalAppUsage) ?? 0))"
            appUsage.uploaded = false
            
            
            CoreDataManager.shared.deleteAppUsageInfo { (success) in
                CoreDataManager.shared.saveAppUsageInfo(appUsage)
            }
            
            let dayappUsage = DayAppUsageObj()
            
            /*let storyboard = UIStoryboard(name: "Winner", bundle: nil)
            let clockVC = storyboard.instantiateViewController(withIdentifier: "WinnerViewController") as! WinnerViewController

            self.getVisibleViewController(self.window?.rootViewController)?.present(clockVC, animated: true, completion:nil)*/
            
            dayappUsage.totalDayAppUsageTime = "\(sec)"
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
            
            
            
            doBackgroundUploadDaysAppUsage(appUsage: appUsage, dayUsage: dayappUsage) { (success) in
                onCompletion(true)
            }
        }

    }
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

        if shouldSaveTime {
            updateTimeToDBInBackground { (suc) in
                
            }
        }
    }

    func doBackgroundUploadDaysAppUsage(appUsage:AppUsageInfoObj, dayUsage: DayAppUsageObj,onCompletion: @escaping (Bool) -> Void) {
        beginBgUpdateDaysAppUsage()
        let queue = DispatchQueue.global(qos: .background)
        queue.async {
            print("Before sleep Minutes = \(appUsage.totalUsageTime)")
            let ref = Database.database().reference()
//            var totalAppUsage = 0
//            var totalDaysUsage = 0
//            var todaysDay = ""
//
//            if let user = DataManager.sharedManager.getUser() {
//                totalAppUsage = sec +  (Int(user.totalAppUsage) ?? 0)
//                if dayUsage == user.todaysDay || (user.todaysDay == "0"){
//                    totalDaysUsage = sec +  (Int(user.todaysAppUsage) ?? 0)
//                } else {
//                    totalDaysUsage = (Int(user.todaysAppUsage) ?? 0)
//                }
//                todaysDay = dayUsage
//            }
            let usersReference = ref.child("users").child((DataManager.sharedManager.getUser()?.uid)!)
            var values = ["totalAppUsage": appUsage.totalUsageTime]

            if !dayUsage.day.isEmpty {
                values["totalDaysUsageTime"] = "\(dayUsage.day)-\(dayUsage.totalDayAppUsageTime)"
            }

            usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                
                if let err = err {
                    print(err)
                    return
                }
                let newuser = DataManager.sharedManager.getUser()
                newuser?.totalAppUsage = "\(appUsage.totalUsageTime)"
                newuser?.todaysAppUsage = "\(dayUsage.totalDayAppUsageTime)"
                newuser?.todaysDay = dayUsage.day
                
                DataManager.sharedManager.saveUser(user: newuser!)
                let dayUsage1 = DayAppUsageObj()
                dayUsage1.day = "\(dayUsage.day)"
                dayUsage1.uploaded = true
                dayUsage1.totalDayAppUsageTime = "\(dayUsage.totalDayAppUsageTime)"
                CoreDataManager.shared.updateStausForDayUsage(dayUsage1)
                CoreDataManager.shared.deleteAppUsageInfo(completion: { (sucess) in
                    
                })
                print("Saved user successfully into Firebase db")
                
                onCompletion(true)
            })
            
            print("after sleep Minutes = \(appUsage.totalUsageTime)")
            
            self.endBgUpdateDaysAppUsage()
        }
    }
    

    func beginBgUpdateDaysAppUsage() {
        bgTaskToUpdateDaysAppUsage = UIApplication.shared.beginBackgroundTask(withName: "updateDaysAppUsage", expirationHandler: {
            self.endBgUpdateDaysAppUsage()
        })
    }

    func endBgUpdateDaysAppUsage() {
        UIApplication.shared.endBackgroundTask(bgTaskToUpdateDaysAppUsage)
        bgTaskToUpdateDaysAppUsage = UIBackgroundTaskInvalid
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        totalUsage = Date()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        
        CoreDataManager.shared.saveContext()
    }

    func getVisibleViewController(_ rootViewController: UIViewController?) -> UIViewController? {
        
        var rootVC = rootViewController
        if rootVC == nil {
            rootVC = UIApplication.shared.keyWindow?.rootViewController
        }
        
        if rootVC?.presentedViewController == nil {
            return rootVC
        }
        
        if let presented = rootVC?.presentedViewController {
            if presented.isKind(of: UINavigationController.self) {
                let navigationController = presented as! UINavigationController
                return navigationController.viewControllers.last!
            }
            
            if presented.isKind(of: UITabBarController.self) {
                let tabBarController = presented as! UITabBarController
                return tabBarController.selectedViewController!
            }
            
            return getVisibleViewController(presented)
        }
        return nil
    }

}
