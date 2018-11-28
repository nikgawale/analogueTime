//
//  LevelManger.swift
//  AnalogueTimeApp
//
//  Created by Pravin Gawale on 18/09/18.
//  Copyright © 2018 Anita Smith. All rights reserved.
//

import UIKit

extension MutableCollection {
    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        
        for (firstUnshuffled, unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            // Change `Int` in the next line to `IndexDistance` in < Swift 4.1
            let d: Int = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            let i = index(firstUnshuffled, offsetBy: d)
            swapAt(firstUnshuffled, i)
        }
    }
}

extension Sequence {
    /// Returns an array with the contents of this sequence, shuffled.
    func shuffled() -> [Element] {
        var result = Array(self)
        result.shuffle()
        return result
    }
}

enum LevelMode {
    case Demo
    case Use
    case Random
}
class LevelManger {
    var currentMode = LevelMode.Demo
    var currentLevel = 0
    var currentIndex = 0
    
    var isExperienced = false
    var demoAllLevelExceptCombos = false

    //Update images for hands
    
    //Corect time tolerance  to 1min to and 1 min past
    
    //In use mode -
    //After Good Try - this is - go to next time
    
    //Combo should have 6 of each level
    //and mixed one


    
    let level10 = ([(1,0), (2,0), (3,0), (4,0), (5,0), (6,0), (7,0), (8,0), (9,0), (10,0), (11,0), (12,0)],"1.0",0)
    let level11 = ([(1,30), (2,30), (3,30), (4,30), (5,30), (6,30), (7,30), (8,30), (9,30), (10,30), (11,30), (12,30)],"1.1",1)
    //Mix those
    //Combo
    let level12 = ([(8,00), (3,00), (5,00), (10,00), (2,00), (11,00), (1,30), (3,30), (9,30), (5,30), (11,30), (7,30)],"1.2",2)
    
    let level20 = ([(1,15), (2,15), (3,15), (4,15), (5,15), (6,15), (7,15), (8,15), (9,15), (10,15), (11,15), (12,15)],"2.0",3)
    let level21 = ([(12,45), (1,45), (2,45), (3,45), (4,45), (5,45), (6,45), (7,45), (8,45), (9,45), (10,45), (11,45)],"2.1",4)
    //Mix those
    //Combo
    let level22 = ([(4,15), (10,15), (2,15), (1,15), (6,15), (12,15), (1,45), (5,45), (7,45), (11,45), (2,45), (6,45)],"2.2",5)
    
    //qaarter to and half past is missing
    //a d should be mixed
    let level23 = ([(1,0), (5,0), (7,0), (2,00), (8,00), (12,00), (1,15), (4,15), (7,15), (11,15), (10,15), (3,15)],"2.3",6)
    
    let level30 = ([(1,5), (2,5), (3,5), (4,5), (5,5), (6,5), (7,5), (8,5), (9,5), (10,5), (11,5), (12,5)],"3.0",7)
    let level31 = ([(12,55), (1,55), (2,55), (3,55), (4,55), (5,55), (6,55), (7,55), (8,55), (9,55), (10,55), (11,55)],"3.1",8)
    //Mix those
    //Combo
    let level32 = ([(4,5), (8,5), (11,5), (2,5), (12,5), (6,5), (11,55), (9,55), (4,55), (2,55), (10,55), (1,55)],"3.2",9)
    let level33 = ([(2,0), (7,0), (12,0), (4,0), (9,0), (8,0),
                    (11,30), (4,30), (6,30), (2,30), (10,30), (1,30),
                    (7,15),(1,15),(3,15),(9,15),(10,15),(4,15),
                    (8,45),(2,45),(12,45),(9,45),(5,45),(2,45),
                    (3,5),(2,5),(11,5),(10,5),(8,5),(6,5),
                    (12,45),(5,45),(9,45),(11,45),(10,45),(3,45)].shuffled(),"3.3",10)
    
    let level40 = ([(1,10), (2,10), (3,10), (4,10), (5,10), (6,10), (7,10), (8,10), (9,10), (10,10), (11,10), (12,10)],"4.0",11)
    let level41 = ([(12,50), (1,50), (2,50), (3,50), (4,50), (5,50), (6,50), (7,50), (8,50), (9,50), (10,50), (11,50)],"4.1",12)
    let level42 = ([(4,10), (7,10), (2,10), (9,10), (5,10), (12,10), (6,50), (9,50), (1,50), (8,50), (2,50), (5,50)],"4.2",13)
    let level43 = ([(5,0), (3,0), (2,0), (11,0), (8,0), (4,0),
                    (11,30), (4,30), (6,30), (2,30), (10,30), (1,30),
                    (7,15),(1,15),(3,15),(9,15),(10,15),(4,15),
                    (8,45),(2,45),(12,45),(9,45),(5,45),(2,45),
                    (3,5),(2,5),(11,5),(10,5),(8,5),(6,5),
                    (12,45),(5,45),(9,45),(11,45),(10,45),(3,45),
                    (3,5),(2,5),(11,5),(10,5),(8,5),(6,5),
                    (12,45),(5,45),(9,45),(11,45),(10,45),(3,45),
                    (7,10),(1,10),(3,10),(11,10),(5,10),(2,10),(10,55),(12,55),(3,55),(6,55),(5,55),(1,55)].shuffled(),"4.3",14)
    
    let level50 = ([(1,20), (2,20), (3,20), (4,20), (5,20), (6,20), (7,20), (8,20), (9,20), (10,20), (11,20), (12,10)],"5.0",15)
    let level51 = ([(12,40), (1,40), (2,40), (3,40), (4,40), (5,40), (6,40), (7,40), (8,40), (9,40), (10,40), (11,40)],"5.1",16)
    let level52 = ([(9,20), (5,20), (2,20), (12,20), (8,20), (3,20), (7,40), (3,40), (1,40), (8,40), (6,40), (11,40)],"5.2",17)
    let level53 = ([(2,0), (7,0), (12,0), (4,0), (9,0), (8,0),
                    (11,30), (4,30), (6,30), (2,30), (10,30), (1,30),
                    (7,15),(1,15),(3,15),(9,15),(10,15),(4,15),
                    (8,45),(2,45),(12,45),(9,45),(5,45),(2,45),
                    (3,5),(2,5),(11,5),(10,5),(8,5),(6,5),
                    (12,45),(5,45),(9,45),(11,45),(10,45),(3,45),
                    (3,5),(2,5),(11,5),(10,5),(8,5),(6,5),
                    (12,45),(5,45),(9,45),(11,45),(10,45),(3,45),
                    (7,10),(1,10),(3,10),(11,10),(5,10),(2,10),
                    (10,55),(12,55),(3,55),(6,55),(5,55),(1,55),
                    (4,20),(12,20),(10,20),(3,20),(2,20),(8,20),
                    (12,40),(3,40),(10,40),(7,40),(6,40),(9,40)
        ].shuffled(),"5.3",18)
    
    let level60 = ([(1,25), (2,25), (3,25), (4,25), (5,25), (6,25), (7,25), (8,25), (9,25), (10,25), (11,25), (12,25)],"6.0",19)
    let level61 = ([(12,35), (1,35), (2,35), (3,35), (4,35), (5,35), (6,35), (7,35), (8,35), (9,35), (10,35), (11,35)],"6.1",20)
    let level62 = ([(6,25), (2,25), (8,25), (12,25), (3,25), (9,25), (2,35), (8,35), (4,35), (11,35), (3,35), (11,35)],"6.2",21)
    let level63 = ([(2,0), (7,0), (12,0), (4,0), (9,0), (8,0),
                    (11,30), (4,30), (6,30), (2,30), (10,30), (1,30),
                    (7,15),(1,15),(3,15),(9,15),(10,15),(4,15),
                    (8,45),(2,45),(12,45),(9,45),(5,45),(2,45),
                    (3,5),(2,5),(11,5),(10,5),(8,5),(6,5),
                    (12,45),(5,45),(9,45),(11,45),(10,45),(3,45),
                    (3,5),(2,5),(11,5),(10,5),(8,5),(6,5),
                    (12,45),(5,45),(9,45),(11,45),(10,45),(3,45),
                    (7,10),(1,10),(3,10),(11,10),(5,10),(2,10),
                    (10,55),(12,55),(3,55),(6,55),(5,55),(1,55),
                    (4,20),(12,20),(10,20),(3,20),(2,20),(8,20),
                    (12,40),(3,40),(10,40),(7,40),(6,40),(9,40),
                    (8,25),(4,25),(12,25),(9,25),(6,25),(2,25),
                    (9,35),(11,35),(5,35),(7,35),(2,35),(10,35)
        ].shuffled(),"6.3",22)
    
    func getLevels() -> [([(Int,Int)], String,Int)] {
        
        if demoAllLevelExceptCombos {
            return [level10,level11,
                    level20,level21,
                    level30,level31,
                    level40,level41,
                    level50,level51,
                    level60,level61]

        } else if isExperienced {
            return [([(9,0), (4,0), (12,0), (8,0)],"1.0",0),
                    ([(3,30), (12,30), (7,30), (2,30)],"1.1",1),
                    ([(4,15), (2,15), (6,15), (5,15)],"2.0",3),
                    ([(1,45), (12,45), (7,45), (4,45)],"2.1",4),
                    ([(5,5), (12,5), (1,5), (6,5)],"3.0",7),
                    ([(9,55), (3,55), (5,55), (12,55)],"3.1",8),
                    ([(4,10), (8,10), (5,10), (9,10)],"4.0",11),
                    ([(8,50), (6,50), (2,50), (10,50)],"4.1",12),
                    ([(2,20), (10,20), (3,20), (8,20)],"5.0",15),
                    ([(12,40), (9,40), (4,40), (7,40)],"5.1",16),
                    ([(1,25), (6,25), (10,25), (12,25)],"6.0",19),
                    ([(3,35), (1,35), (8,35), (5,35)],"6.1",20)]

        } else {
            return [level10,level11,level12,
                    level20,level21,level22,level23,
                    level30,level31,level32,level33,
                    level40,level41,level42,level43,
                    level50,level51,level52,level53 ,
                    level60,level61,level62,level63]
        }
    }
    
    func getRandomTimeInLevel(_ levelIndex: Int) -> (Int,Int) {
        let randomInt = Int(arc4random_uniform(UInt32(getLevels()[levelIndex].0.count)))
        return getLevels()[levelIndex].0[randomInt]
    }
    
    func getTimeStringFrom(_ hour: Int, _ min: Int) -> String {
        
        var str = ""
        switch min {
        case 0:
            str = "\(hour)"
        case 5:
            str = "5 past \(hour)"
        case 10:
            str = "10 past \(hour)"
        case 15:
            str = "quarter past \(hour)"
        case 20:
            str = "20 past \(hour)"
        case 25:
            str = "25 past \(hour)"
        case 30:
            str = "half past \(hour)"
        case 35:
            str = "25 to \(hour+1)"
        case 40:
            str = "20 to \(hour+1)"
        case 45:
            str = "quarter to \(hour+1)"
        case 50:
            str = "10 to \(hour+1)"
        case 55:
            str = "5 to \(hour+1)"
        default:
            str = ""
        }
        return str
    }
    
    func getLevelIndex(_ levelStr:String) -> Int {
        switch levelStr {
        case "1.0" :
            return 0
        case "1.1":
            return 1
        case "1.2":
            return 2
        case "2.1":
            return 3
        case "2.2":
            return 4
        case "2.3":
            return 5
        case "3.0":
            return 6
        case "3.1":
            return 7
        case "3.2":
            return 8
        case "3.3":
            return 9
        case "4.0":
            return 10
        case "4.1":
            return 11
        case "4.2":
            return 12
        case "4.3":
            return 13
        case "5.0":
            return 14
        case "5.1":
            return 15
        case "5.2":
            return 16
        case "5.3":
            return 17
        case "6.0":
            return 18
        case "6.1":
            return 19
        case "6.2":
            return 20
        case "6.3":
            return 21
        default:
            return 0
        }
        
        return 0
    }
    
    func audioPlayList (_ timeStr:String) -> [String] {
        
        var playList = [String]()
        
        if timeStr.lowercased().contains("5 to") {
            playList.append("5")
            playList.append("to")
            let digit = timeStr.split(separator: " ").last!
            playList.append(String(digit))
        } else if timeStr.lowercased().contains("10 to") {
            playList.append("10")
            playList.append("to")
            let digit = timeStr.split(separator: " ").last!
            playList.append(String(digit))
        } else if timeStr.lowercased().contains("quarter to") {
            playList.append("quarter")
            playList.append("to")
            let digit = timeStr.split(separator: " ").last!
            playList.append(String(digit))
        } else if timeStr.lowercased().contains("20 past") {
            playList.append("20")
            playList.append("past")
            let digit = timeStr.split(separator: " ").last!
            playList.append(String(digit))
        } else if timeStr.lowercased().contains("25 past") {
            playList.append("25")
            playList.append("past")
            let digit = timeStr.split(separator: " ").last!
            playList.append(String(digit))
        } else if timeStr.lowercased().contains("25 to") {
            playList.append("25")
            playList.append("to")
            let digit = timeStr.split(separator: " ").last!
            playList.append(String(digit))
        } else if timeStr.lowercased().contains("20 to") {
            playList.append("20")
            playList.append("to")
            let digit = timeStr.split(separator: " ").last!
            playList.append(String(digit))
        } else if timeStr.lowercased().contains("10 past") {
            playList.append("10")
            playList.append("past")
            let digit = timeStr.split(separator: " ").last!
            playList.append(String(digit))
        } else if timeStr.lowercased().contains("5 past") {
            playList.append("5")
            playList.append("past")
            let digit = timeStr.split(separator: " ").last!
            playList.append(String(digit))
        } else if timeStr.lowercased().contains("half past") {
            playList.append("half")
            playList.append("past")
            let digit = timeStr.split(separator: " ").last!
            playList.append(String(digit))
        } else {
            playList.append(timeStr)
        }
        
        return playList
    }
}
