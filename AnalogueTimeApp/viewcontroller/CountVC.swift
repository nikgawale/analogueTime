//
//  CountVC.swift
//  AnalogueTimeApp
//
//  Created by Pravin Gawale on 24/09/18.
//  Copyright © 2018 Anita Smith. All rights reserved.
//

import UIKit

class CountVC: BaseVC {

    @IBOutlet weak var countImage: UIImageView!
    var timer : Timer?

    @IBOutlet weak var topLabel: UILabel!
    
    @IBOutlet weak var middleLabel: UILabel!
    let audioPlayer = AudioPlayer()
    
    let countArrayFor5s = ["count_5s_5_img",
                           "count_5s_10_img",
                           "count_5s_15_img",
                           "count_5s_20_img",
                           "count_5s_25_img",
                           "count_5s_30_img",
                           "count_5s_35_img",
                           "count_5s_40_img",
                           "count_5s_45_img",
                           "count_5s_50_img",
                           "count_5s_55_img",
                           "count_5s_60_img"]
    
    let countArrayFor15s = ["count_15s_15_img","count_15s_30_img","count_15s_45_img","count_15s_60_img"]

    
    var isCountBy5Selected = false
    var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        startMode()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        timer = nil
    }
    
    func startMode() {
        //Demo mode
        runTimedCode()
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(2), target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
    }
    
    @objc func runTimedCode() {
        
        let imageArray = isCountBy5Selected ? countArrayFor5s : countArrayFor15s
        if currentIndex == (imageArray.count) {
            currentIndex = 0
            let imageName = imageArray[currentIndex]
            countImage.image = UIImage(named:imageName)
            topLabel.text = getTextForTime(imageName)
            self.audioPlayer.playAudio(audioName:topLabel.text! + ".wav")

            
        } else {
            let imageName = imageArray[currentIndex]
            countImage.image = UIImage(named:imageName)
            topLabel.text = getTextForTime(imageName)
            self.audioPlayer.playAudio(audioName:topLabel.text! + ".wav")

            currentIndex = currentIndex  + 1
        }
    }
    
    func getTextForTime(_ imageName:String) -> String {
    
        switch imageName {
        case let str where str.contains("_5_"):
            return "5"
        case let str where str.contains("_10_"):
            return "10"
        case let str where str.contains("_15_"):
            return "15"
        case let str where str.contains("_20_"):
            return "20"
        case let str where str.contains("_25_"):
            return "25"
        case let str where str.contains("_30_"):
            return "30"
        case let str where str.contains("_35_"):
            return "35"
        case let str where str.contains("_40_"):
            return "40"
        case let str where str.contains("_45_"):
            return "45"
        case let str where str.contains("_50_"):
            return "50"
        case let str where str.contains("_55_"):
            return "55"
        case let str where str.contains("_60_"):
            return "60"

        default:
            return ""
        }
    }
}
