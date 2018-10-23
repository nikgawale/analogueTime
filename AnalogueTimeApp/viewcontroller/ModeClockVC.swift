//
//  ModeClockVC.swift
//  AnalogueTimeApp
//
//  Created by Pravin Gawale on 23/09/18.
//  Copyright © 2018 Anita Smith. All rights reserved.
//

import UIKit

class ModeClockVC: BaseVC,BEMAnalogClockDelegate {

    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var timelabel: UILabel!
    @IBOutlet weak var middleLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var clock: BEMAnalogClockView!

    let viewModel = ModeViewModel()
    var timer : Timer?
    var showInfoText = false
    let level = LevelManger()
    let delay = 3
    var expectedTime = (0,0)
    var isUserSelectedCorrectTime = false
    var weDriveClocks  = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
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

        if viewModel.type == .DEMO {
            //DEMO for all the levels
            startDemoMode()
        } else if viewModel.type == .WE_DRIVE {
            startWeDriveMode()
        } else if viewModel.type == .YOU_DRIVE {
            startYouDriveMode()
        } 
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        timer = nil
    }
    
    func startWeDriveMode() {
        showInfoScreen("Show me the given time! ")
        level.currentIndex = Int(arc4random_uniform(UInt32(11)))
        level.demoAllLevelExceptCombos = true
        let randomLevel = Int(arc4random_uniform(UInt32(11)))

        let (h,m) = level.getRandomTimeInLevel(randomLevel)
        expectedTime = (h,m)
        
        unowned let unownedSelf = self
        let deadlineTime = DispatchTime.now() + .seconds(delay)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
            unownedSelf.showMe(hour: h, min: m)
        })
    }

    func startYouDriveMode() {
        showInfoScreen("Turn  the  minute  hand  and  I’ll  tell  you  the  time")
        unowned let unownedSelf = self
        let deadlineTime = DispatchTime.now() + .seconds(delay)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
            unownedSelf.clock.allowFinger(toMoveClock: true)
            unownedSelf.clock.setTimeViaTouch = true
            unownedSelf.showInfoText = false
            unownedSelf.middleLabel.isHidden = true
            unownedSelf.clock.isHidden = false
            unownedSelf.timelabel.isHidden = false
            unownedSelf.bottomLabel.isHidden = false
            unownedSelf.clock.allowFinger(toMoveClock: true)
            unownedSelf.timelabel.text = ""
        })
    }
    
    func showMe(hour: Int , min:Int) {
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
            unownedSelf.expectedTime = (hour, min)
            unownedSelf.clock.updateTime(animated: true)
        }
    }
    func startDemoMode() {
        //Demo mode
        level.demoAllLevelExceptCombos = true
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(delay), target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
        
        let levelStr = level.getLevels()[level.currentLevel].1
        self.levelLabel.text = "Level - \(levelStr) - Demo"
    }
    
    @objc func runTimedCode() {
        let h = level.getLevels()[level.currentLevel].0[level.currentIndex].0
        let m = level.getLevels()[level.currentLevel].0[level.currentIndex].1
        ThisIs(hour: h, min: m)
        if level.currentIndex == (level.getLevels()[level.currentLevel].0.count-1) {
            
            if level.currentLevel == (level.getLevels().count-1) {
                timer?.invalidate()
                showInfoScreen("Well Done, we have completed Demo Mode.")
                level.demoAllLevelExceptCombos = false
                unowned let unownedSelf = self
                let deadlineTime = DispatchTime.now() + .seconds(delay)
                DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
                    unownedSelf.navigationController?.popViewController(animated: true)
                })

            } else {
                level.currentLevel  = level.currentLevel + 1
                level.currentIndex = 0
            }

        } else {
            level.currentIndex = level.currentIndex + 1
        }
    }
    func ThisIs(hour: Int , min:Int) {
        
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
        var cur_time_str = self.level.getTimeStringFrom(self.clock.hours, self.clock.minutes)
        self.timelabel.text = "\(cur_time_str)"
        self.bottomLabel.text = "This is \(cur_time_str)"
        
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
    
    func currentTime(onClock clock: BEMAnalogClockView!, hours: String!, minutes: String!, seconds: String!) {
        print("Hours = \(hours)")
        print("minutes = \(minutes)")
        
        if viewModel.type == .WE_DRIVE {
            let correctMin =  (expectedTime.1 == Int(minutes)!) || (expectedTime.1 == Int(minutes)! - 1) || (expectedTime.1 == Int(minutes)! + 1)
            if ((expectedTime.0 == Int(hours)) && correctMin) {
                print("Time is  correct")
                isUserSelectedCorrectTime = true
            } else {
                isUserSelectedCorrectTime = false
            }
        }
    }
    
    func userPutsOfHisFingureOutOfClock() {
        if viewModel.type == .YOU_DRIVE {
            var cur_time_str = self.level.getTimeStringFrom(self.clock.hours, self.clock.minutes)
            if cur_time_str.isEmpty {
                cur_time_str = "\(self.clock.hours) hours \(self.clock.minutes) min"
            }
            self.timelabel.text = "\(cur_time_str)"
            self.bottomLabel.text = "This is \(cur_time_str)"
            self.clock.allowFinger(toMoveClock: false)
            unowned let unownedSelf = self
            let deadlineTime = DispatchTime.now() + .seconds(delay)
            DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
                unownedSelf.clock.allowFinger(toMoveClock: true)
            })

        } else if viewModel.type == .WE_DRIVE{
            if isUserSelectedCorrectTime {
                if weDriveClocks == 25 {
                    showInfoScreen("Well Done, we have completed We drive Mode.")
                    level.demoAllLevelExceptCombos = false
                    unowned let unownedSelf = self
                    let deadlineTime = DispatchTime.now() + .seconds(delay)
                    DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
                        unownedSelf.navigationController?.popViewController(animated: true)
                    })

                } else {
                    
                    self.bottomLabel.text = "Well Done!"
                    weDriveClocks = weDriveClocks + 1
                    level.currentIndex = Int(arc4random_uniform(UInt32(11)))
                    level.demoAllLevelExceptCombos = true
                    let randomLevel = Int(arc4random_uniform(UInt32(11)))
                    
                    let (h,m) = level.getRandomTimeInLevel(randomLevel)
                    expectedTime = (h,m)
                    
                    unowned let unownedSelf = self
                    let deadlineTime = DispatchTime.now() + .seconds(delay)
                    DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
                        unownedSelf.showMe(hour: h, min: m)
                    })

                }
            } else {
                self.bottomLabel.text = "Good Try"
                weDriveClocks = weDriveClocks + 1
                level.currentIndex = Int(arc4random_uniform(UInt32(11)))
                level.demoAllLevelExceptCombos = true
                let randomLevel = Int(arc4random_uniform(UInt32(11)))
                
                let (h,m) = level.getRandomTimeInLevel(randomLevel)
                expectedTime = (h,m)
                
                unowned let unownedSelf = self
                let deadlineTime = DispatchTime.now() + .seconds(delay)
                DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
                    unownedSelf.showMe(hour: h, min: m)
                })

            }
        }
    }
}
