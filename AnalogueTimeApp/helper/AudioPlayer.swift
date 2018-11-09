//
//  AudioPlayer.swift
//  AnalogueTimeApp
//
//  Created by Pravin Gawale on 20/10/18.
//  Copyright © 2018 Anita Smith. All rights reserved.
//

import UIKit
import AVFoundation

class AudioPlayer: NSObject,AVAudioPlayerDelegate {
    var audioList = [String]()
    var audioPlayer: AVAudioPlayer?
    
    func playAudio(audioName:String,add:Bool = true)
    {
        let defaults = UserDefaults.standard
        let value = defaults.integer(forKey: "isAudioOn")
        
        if value == 0
        {
            if add {
                audioList.append(audioName)
            }
            
            if audioPlayer == nil || audioPlayer?.isPlaying == false
            {
                do {
                    if let fileURL = Bundle.main.path(forResource:audioName, ofType:nil) {
                        audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: fileURL))
                        audioPlayer?.delegate = self
                    } else {
                        print("No file with specified name exists")
                    }
                } catch let error {
                    print("Can't play the audio file failed with an error \(error.localizedDescription)")
                }
                
                audioPlayer?.play()
            }
        }
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        
        if audioList.count > 0
        {
            audioList.removeFirst()
        }
    }
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        audioList.removeFirst()
        if (!audioList.isEmpty)
        {
            let name = audioList.first!
            audioPlayer = nil
            print(name)
            playAudio(audioName:name,add:false)
        }
    }
}
