//
//  ClockVC.swift
//  AnalogueTimeApp
//
//  Created by Pravin Gawale on 12/09/18.
//  Copyright © 2018 Anita Smith. All rights reserved.
//

import UIKit
import Floaty
import Firebase

let kCongratsScreenTime = 600

class ClockVC: BaseVC,BEMAnalogClockDelegate {
    @IBOutlet weak var timelabel: UILabel!
    @IBOutlet weak var middleLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    
    @IBOutlet weak var tick: UIImageView!
    @IBOutlet weak var clock: BEMAnalogClockView!
    
    @IBOutlet weak var levelValue: UILabel!
    @IBOutlet weak var modeValue: UILabel!

    let delay = 6.0
    let level = LevelManger()
    var timer : Timer?
    var countDowntimer : Timer?
    var screenSpentTimer : Timer?
    var expectedTime = (0,0)
    var showInfoText = false
    var isUserSelectedCorrectTime = false {
        didSet {
        }
    }
    var numberOftries = 1
    var levelErrors = 0
    let audioPlayer = AudioPlayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.clock.enableShadows = true
        self.clock.realTime = false
        self.clock.currentTime = false
        self.clock.setTimeViaTouch = false
        self.clock.borderWidth = 3
        self.clock.delegate = self
        self.clock.digitFont = UIFont.boldSystemFont(ofSize: 17)
        self.clock.digitColor = UIColor.red
        self.clock.enableDigit = true
        self.clock.hours = 0
        self.clock.minutes = 0
        self.clock.enableGraduations = false
        self.clock.enableHub = true
        self.clock.updateTime(animated: true)
        self.timelabel.text = ""
        self.bottomLabel.text = ""
        self.showInfoText = true
        self.clock.isHidden = true
        self.timelabel.isHidden = true
        self.bottomLabel.isHidden = true
        self.tick.isHidden = true


  
        //Use mode
       // showInfoScreen()
        
        //Random Mode
        //startRandomMode()
        
       
        
    }
    
    
    
    func countDownTimerAction () {
        
        let delegate = UIApplication.shared.delegate as! AppDelegate

        delegate.updateTimeToDBInBackground { (success) in
            if let todaysUsage = CoreDataManager.shared.getDaysAppUsage() {
                if Int(todaysUsage.totalDayAppUsageTime)! >= 600 {
                    print("More than 10 min ")
                } else if Int(todaysUsage.totalDayAppUsageTime)! >= 1200{
                    print("More than 20 min ")
                    self.countDowntimer?.invalidate()
                }
            }
        }
    }
    
    func startDemoMode() {
        //Demo mode
        numberOftries = 1
        levelErrors = 0
        //Timer.scheduledTimer(timeInterval:0.2, target: self, selector: #selector(self.playThisisAudio), userInfo: nil, repeats: false)
        timer = Timer.scheduledTimer(timeInterval:delay, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
    
        let levelStr = level.getLevels()[level.currentLevel].1
        
        if !levelStr.isEmpty {
            let ref = Database.database().reference()
            let values = ["level": levelStr]
            let usersReference = ref.child("users").child((DataManager.sharedManager.getUser()?.uid)!)
            usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                
                if let err = err {
                    print(err)
                    return
                }
                let user = DataManager.sharedManager.getUser()
                user?.level = levelStr
                DataManager.sharedManager.saveUser(user: user!)
                print("Saved user successfully into Firebase db")
                
            })
        }
        self.levelValue.text  = levelStr
        self.modeValue.text  = "Learn"

        //self.levelLabel.text = "Level - \(levelStr) - Demo"
    }
    
    @objc func playThisisAudio() {
        
        self.audioPlayer.playAudio(audioName:"thisis.wav")
        
    }
    
    @objc func startUseMode() {
        //Use mode
        showInfoScreen(level.isExperienced ? "OK, let’s do a quick test of where you’re up to" : "Now its your turn")
        level.currentIndex = 0
        numberOftries = 1
        levelErrors = 0
        self.level.currentMode = LevelMode.Use

        let levelStr = level.getLevels()[level.currentLevel].1
        self.levelValue.text  = levelStr
        self.modeValue.text  = "Use"

        //self.levelLabel.text = "Level - \(levelStr) - Use"

        let h = level.getLevels()[level.currentLevel].0[level.currentIndex].0
        let m = level.getLevels()[level.currentLevel].0[level.currentIndex].1
        unowned let unownedSelf = self
        let deadlineTime = DispatchTime.now() + .seconds(Int(delay))
        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
            unownedSelf.showMe(hour: h, min: m)
        })
    }
    
    func startRandomMode() {
        showInfoScreen("You’re  doing  so  well  let’s  go  random.")
        //Use mode
        level.currentMode = .Random
        level.currentIndex = 0
        numberOftries = 1
        levelErrors = 0
        let levelStr = level.getLevels()[level.currentLevel].1
        self.levelValue.text  = levelStr
        self.modeValue.text  = "Use"

        //self.levelLabel.text = "Level - \(levelStr) - Random"

        let (h,m) = level.getRandomTimeInLevel(level.currentLevel)
        let deadlineTime = DispatchTime.now() + .seconds(Int(delay))
        unowned let unownedSelf = self
        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
            unownedSelf.showMe(hour: h, min: m)
        })
    }
    
    func ThisIs(hour: Int , min:Int) {
        
        self.audioPlayer.audioList.removeAll()
        self.audioPlayer.audioPlayer?.stop()
        
        self.showInfoText = false
        self.middleLabel.isHidden = true
        self.clock.isHidden = false
        self.timelabel.isHidden = false
        self.bottomLabel.isHidden = false
        self.clock.setTimeViaTouch = false
        self.clock.allowFinger(toMoveClock: false)
        
        let min_lim = (min == 0 || min < 30) ? 59 : min
        for index in 0...min_lim {
            self.clock.minutes = index
            self.clock.updateTime(animated: true)
        }
        
        self.clock.hours = hour
        self.clock.minutes = min
        self.clock.updateTime(animated: true)
        let cur_time_str = self.level.getTimeStringFrom(self.clock.hours, self.clock.minutes)
        self.timelabel.text = "\(cur_time_str)"
        self.bottomLabel.text = "This is \(cur_time_str) o'clock"
        self.playThisisAudio()
        
        level.audioPlayList(cur_time_str).forEach { (str) in
            self.audioPlayer.playAudio(audioName:str + ".wav")
        }
        

       // self.audioPlayer.playAudio(audioName:"oclock.wav")

    }
    
    
    func showMe(hour: Int , min:Int) {
        self.audioPlayer.audioList.removeAll()
        self.audioPlayer.audioPlayer?.stop()
    
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.tick.isHidden = true
        }
        
        unowned let unownedSelf = self
        DispatchQueue.main.async {
            unownedSelf.clock.allowFinger(toMoveClock: true)
            unownedSelf.clock.setTimeViaTouch = true
            unownedSelf.showInfoText = false
            unownedSelf.middleLabel.isHidden = true
            unownedSelf.clock.isHidden = false
            unownedSelf.timelabel.isHidden = false
            unownedSelf.bottomLabel.isHidden = false
            unownedSelf.clock.allowFinger(toMoveClock: true)
            unownedSelf.timelabel.text = ""
            let cur_time_str = unownedSelf.level.getTimeStringFrom(hour, min)
            unownedSelf.bottomLabel.text = "Show me \(cur_time_str) o'clock"
            self.audioPlayer.playAudio(audioName:"showme.wav")
            unownedSelf.level.audioPlayList(cur_time_str).forEach { (str) in
                self.audioPlayer.playAudio(audioName:str + ".wav")
            }
            //self.audioPlayer.playAudio(audioName:"oclock.wav")
            unownedSelf.expectedTime = (hour, min)
            unownedSelf.clock.updateTime(animated: true)
        }
    }
    
    @objc func runTimedCode() {
        if level.currentMode == .Demo {
            let h = level.getLevels()[level.currentLevel].0[level.currentIndex].0
            let m = level.getLevels()[level.currentLevel].0[level.currentIndex].1
            ThisIs(hour: h, min: m)
            if level.currentIndex == (level.getLevels()[level.currentLevel].0.count-1) {
                timer?.invalidate()
                self.perform(#selector(startUseMode), with: nil, afterDelay: TimeInterval(delay))
            } else {
                level.currentIndex = level.currentIndex + 1
            }
        }
    }
    
    
    
    @objc func showInfoScreen(_ text: String) {
        unowned let unownedSelf = self
        DispatchQueue.main.async {
            unownedSelf.clock.isHidden = true
            unownedSelf.timelabel.isHidden = true
            unownedSelf.bottomLabel.isHidden = true
            unownedSelf.middleLabel.isHidden = false
            unownedSelf.middleLabel.text = text
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Need to remove this screen
        
        if level.isExperienced {
            
            startUseMode()
        } else {
            let user = DataManager.sharedManager.getUser()
            let levelStr = user?.level
            level.currentLevel = level.getLevelIndex(levelStr!)
            startDemoMode()
        }
        
        countDowntimer = Timer.scheduledTimer(timeInterval: TimeInterval(10), target: self, selector: #selector(countDownTimerAction), userInfo: nil, repeats: true)
        
        let appdelegate  = UIApplication.shared.delegate as! AppDelegate
        appdelegate.totalUsage = Date()
        appdelegate.shouldSaveTime = true

        if appdelegate.learningTimeCount <= kCongratsScreenTime*2
        {
            startLearningModeTimer()
        }
    }
    
    func startLearningModeTimer()
    {
        screenSpentTimer = Timer.scheduledTimer(timeInterval: TimeInterval(1), target: self, selector: #selector(showLearnigScreen), userInfo: nil, repeats: true)
    }
    
    func stopLearningModeTimer()
    {
        screenSpentTimer?.invalidate()
        screenSpentTimer = nil
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        timer = nil
        countDowntimer?.invalidate()
        countDowntimer = nil
        
        stopLearningModeTimer()
        let appdelegate  = UIApplication.shared.delegate as! AppDelegate
        appdelegate.shouldSaveTime = false
    }
    
    func showLearnigScreen () {
        
        let appdelegate  = UIApplication.shared.delegate as! AppDelegate
        
        let oldTime = appdelegate.learningTimeCount
        appdelegate.learningTimeCount = oldTime + 1
        if appdelegate.learningTimeCount == kCongratsScreenTime || appdelegate.learningTimeCount == kCongratsScreenTime*2
        {
            DispatchQueue.main.async {            
            let storyboard = UIStoryboard(name: "Winner", bundle: nil)
            let winnerViewController = storyboard.instantiateViewController(withIdentifier: "WinnerViewController") as! WinnerViewController
           
            
            self.navigationController?.present(winnerViewController, animated: true, completion:{
                
            })
                winnerViewController.congratsLabel.isHidden = true
                winnerViewController.congratsImageView.isHidden = false
                if appdelegate.learningTimeCount == kCongratsScreenTime
                {
                    winnerViewController.congratsImageView.image = UIImage(named: "10min_congrats_img")
                }
                else if appdelegate.learningTimeCount == kCongratsScreenTime*2
                {
                    winnerViewController.congratsImageView.image = UIImage(named: "20min_congrats_img")
                }
            }
        }
        
        if appdelegate.learningTimeCount >= kCongratsScreenTime*2
        {
          stopLearningModeTimer()
        }
    }
    
    func currentTime(onClock clock: BEMAnalogClockView!, hours: String!, minutes: String!, seconds: String!) {
        print("Hours = \(hours)")
        print("minutes = \(minutes)")
        
        let correctMin =  (expectedTime.1 == Int(minutes)!) || (expectedTime.1 == Int(minutes)! - 1) || (expectedTime.1 == Int(minutes)! + 1) || (expectedTime.1 == Int(minutes)! - 2) || (expectedTime.1 == Int(minutes)! + 2) || (expectedTime.1 == 59) || (expectedTime.1 == 58)
        
        if ((expectedTime.0 == Int(hours)) && correctMin) {
            print("Time is  correct")
            isUserSelectedCorrectTime = true
        } else {
            isUserSelectedCorrectTime = false
            print("Time is  not correct")
        }
    }

    func clockDidBeginLoading(_ clock: BEMAnalogClockView!) {
        print("time clockDidBeginLoading=")
    }
    
    func clockDidFinishLoading(_ clock: BEMAnalogClockView!) {
        print("time clockDidFinishLoading=")
    }
    
    func userMovingHandAntiClockwise() {
//        let alert = UIAlertController(title: "Hey", message: "You can not move hand anticlockwise", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//        self.present(alert, animated: true, completion: nil)
    }
    
    func userPutsOfHisFingureOutOfClock() {
        print("time clockDidFinishLoading=")
        
        if level.isExperienced {
            if isUserSelectedCorrectTime {
            } else {
                
                if self.numberOftries == 3 {
                    showInfoScreen("Lets Learn Analogue Time!")
                    
                    self.level.currentLevel = level.getLevels()[self.level.currentLevel].2
                    level.isExperienced = false
                    self.levelErrors = 0
                    level.currentMode = .Demo
                    level.currentIndex = 0

                    let deadlineTime = DispatchTime.now() + .seconds(Int(delay))
                    unowned let unownedSelf = self
                    DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
                        unownedSelf.startDemoMode()
                    })


                } else {
                    self.numberOftries = self.numberOftries + 1
                    self.bottomLabel.text = "Good Try"
                    audioPlayer.playAudio(audioName:"goodtry.wav")
                }
            }
            if level.isExperienced  {
                if (level.currentIndex == (level.getLevels()[level.currentLevel].0.count - 1)){
                    if level.currentLevel == (level.getLevels().count-1) {
                        print("You have cleared all levels in experienced moode")
                        
                        showInfoScreen("Congratulations! You have cleared all levels in experienced moode.")
                    } else {
                        level.currentIndex = 0
                        self.numberOftries = 1
                        level.currentLevel = level.currentLevel + 1
                    }
                } else {
                    level.currentIndex = level.currentIndex + 1
                }
                let h = level.getLevels()[level.currentLevel].0[level.currentIndex].0
                let m = level.getLevels()[level.currentLevel].0[level.currentIndex].1
                showMe(hour: h , min: m)
            }



        } else {
            if isUserSelectedCorrectTime {
                
                let user = DataManager.sharedManager.getUser()
                let ref = Database.database().reference()
                let correctAns = Int((user?.correctAns)!)!+1
                
                if correctAns%10 == 0
                {
                    let storyboard = UIStoryboard(name: "Winner", bundle: nil)
                    let winnerViewController = storyboard.instantiateViewController(withIdentifier: "WinnerViewController") as! WinnerViewController
                    self.navigationController?.present(winnerViewController, animated: true, completion:{
                        winnerViewController.congratsLabel.text = "When moving to the next level, You’ve mastered this \(correctAns) level. Well done."
                        
                    })
                }
                
                let values = ["correctAns": "\(correctAns)"]
                let usersReference = ref.child("users").child((DataManager.sharedManager.getUser()?.uid)!)
                usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                    
                    if let err = err {
                        print(err)
                        return
                    }
                    let user = DataManager.sharedManager.getUser()
                    user?.correctAns = "\(correctAns)"
                    DataManager.sharedManager.saveUser(user: user!)
                    print("Saved user successfully into Firebase db")
                    
                })

                if level.currentMode == .Random {
                    if level.currentIndex == (level.getLevels()[level.currentLevel].0.count-1) {
                        showInfoScreen("You’ve  mastered  this  level.  Well  done.")
                        if self.level.currentLevel == (self.level.getLevels().count-1) {
                            showInfoScreen("Massive  effort.\n You’ve  mastered  every  level.\n  Congratulations.")
                            
                        } else {
                            self.levelErrors = 0
                            self.level.currentLevel = self.level.currentLevel + 1
                            level.currentMode = .Demo
                            level.currentIndex = 0
                            startDemoMode()
                        }
                        
                    } else {
                        
                        self.clock.hours = self.expectedTime.0
                        self.clock.minutes = self.expectedTime.1

                        level.currentIndex = level.currentIndex + 1
                        let (h,m) = level.getRandomTimeInLevel(level.currentLevel)
                        showMe(hour: h , min: m)
                        self.tick.isHidden = false
                        self.audioPlayer.playAudio(audioName:"ding.wav")
                    }
                    return
                }
                
                let limit_h = level.getLevels()[level.currentLevel].0.last?.0
                let limit_m = level.getLevels()[level.currentLevel].0.last?.1
                
                if (self.clock.hours == limit_h) && (self.clock.minutes == limit_m) {
                    startRandomMode()
                } else {
                    
                    self.clock.hours = self.expectedTime.0
                    self.clock.minutes = self.expectedTime.1

                    level.currentIndex = level.currentIndex + 1
                    
                    print("New Level = \(level.currentLevel)")
                    
                    let h = level.getLevels()[level.currentLevel].0[level.currentIndex].0
                    let m = level.getLevels()[level.currentLevel].0[level.currentIndex].1
                    showMe(hour: h , min: m)
                    self.tick.isHidden = false
                    self.audioPlayer.playAudio(audioName:"ding.wav")
                }
                
            } else {
                print("Expected time = \(expectedTime)")
                self.bottomLabel.text = "Good Try"
                audioPlayer.playAudio(audioName:"goodtry.wav")

                self.clock.allowFinger(toMoveClock: false)
                if (self.numberOftries == 2) {
                    self.numberOftries = 1
                    
                    if self.levelErrors == 3 {
                        
                        self.levelErrors = 0
                        if level.currentMode == .Use {
                            showInfoScreen("Lets check the demo")
                            level.currentMode = .Demo
                            level.currentIndex = 0
                            let deadlineTime = DispatchTime.now() + .seconds(Int(delay))
                            unowned let unownedSelf = self
                            DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
                                unownedSelf.startDemoMode()
                            })
                        } else if level.currentMode == .Random {
                            showInfoScreen("Lets check the Use mode")
                            level.currentMode = .Use
                            level.currentIndex = 0
                            let deadlineTime = DispatchTime.now() + .seconds(Int(delay))
                            unowned let unownedSelf = self
                            DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
                                unownedSelf.startUseMode()
                            })
                            
                        }
                        
                        return
                    } else {
                        unowned let unownedSelf = self
                        let deadlineTime = DispatchTime.now() + .seconds(Int(delay))
                        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
                            unownedSelf.ThisIs(hour: unownedSelf.expectedTime.0, min: unownedSelf.expectedTime.1)
                           // self.audioPlayer.playAudio(audioName:"oclock.wav")

                            let deadlineTime = DispatchTime.now() + .seconds(Int(self.delay))
                            DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
                                
                                let limit_h = unownedSelf.level.getLevels()[unownedSelf.level.currentLevel].0.last?.0
                                let limit_m = unownedSelf.level.getLevels()[unownedSelf.level.currentLevel].0.last?.1
                                
                                if (self.clock.hours == limit_h) && (self.clock.minutes == limit_m) {
                                    unownedSelf.startRandomMode()
                                } else {
                                    unownedSelf.level.currentIndex = unownedSelf.level.currentIndex + 1
                                    let h = unownedSelf.level.getLevels()[unownedSelf.level.currentLevel].0[unownedSelf.level.currentIndex].0
                                    let m = unownedSelf.level.getLevels()[unownedSelf.level.currentLevel].0[unownedSelf.level.currentIndex].1
                                    unownedSelf.showMe(hour: h , min: m)
                                }
                            })
                        })
                    }
                    
                } else {
                    if self.numberOftries == 1 {
                        self.levelErrors = self.levelErrors + 1
                    }
                    unowned let unownedSelf = self
                    let deadlineTime = DispatchTime.now() + .seconds(Int(delay))
                    DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
                        unownedSelf.numberOftries = unownedSelf.numberOftries + 1
                        unownedSelf.showMe(hour: unownedSelf.expectedTime.0, min: unownedSelf.expectedTime.1)
                    })
                }
                
            }

        }
       

    }
    
}
