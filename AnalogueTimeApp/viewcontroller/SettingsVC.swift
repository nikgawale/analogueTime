//
//  SettingsVC.swift
//  AnalogueTimeApp
//
//  Created by Pravin Gawale on 23/09/18.
//  Copyright © 2018 Anita Smith. All rights reserved.
//

import UIKit

class SettingsVC: BaseVC,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var voiceControl: TTSegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        voiceControl.itemTitles = ["Item1", "Item2"]
        voiceControl.selectItemAt(index: 0, animated: false)
        voiceControl.layer.cornerRadius = 25.0
        voiceControl.layer.borderWidth = 1
        voiceControl.layer.borderColor = UIColor.gray.cgColor
        voiceControl.changeThumbColor(UIColor.red)
        voiceControl.allowChangeThumbWidth  = true
        voiceControl.isFromSettingView = true
        
        let defaults = UserDefaults.standard
        let value = defaults.integer(forKey: "isAudioOn")
        
        voiceControl.selectItemAt(index: value, animated: true)
    }

    @IBAction func resetButtonAction(_ sender: Any) {
    
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "isAudioOn")
        defaults.synchronize()
        voiceControl.selectItemAt(index: 0, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsVCCell", for: indexPath)
        cell.textLabel?.text = "Update"
        cell.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: UIFontWeightSemibold)
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.textAlignment = .center
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        let registerVC = self.storyboard?.instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
        registerVC.updateUserInfo = true
        self.navigationController?.pushViewController(registerVC, animated: true)
    }
   
}
