//
//  TopStudentVC.swift
//  AnalogueTimeApp
//
//  Created by Pravin Gawale on 05/10/18.
//  Copyright © 2018 Anita Smith. All rights reserved.
//

import UIKit
import JGProgressHUD
import Firebase

import SDWebImage

class TopStudentVC: BaseVC,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    let loder = JGProgressHUD(style: .extraLight)

    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loder.show(in: self.view)

        let ref = Database.database().reference()
        let usersReference = ref.child("users")
        usersReference.observe(.value, with: { (snapshot) in
            print(snapshot)
            
            print(snapshot.childrenCount) // I got the expected number of items
            for case let rest as DataSnapshot in snapshot.children {
                let dict =  rest.value as! NSDictionary
                let correctAns = dict["correctAns"] as? String ?? ""
                let country = dict["country"] as? String ?? ""
                let email = dict["email"] as? String ?? ""
                let level = dict["level"] as? String ?? ""
                let name = dict["name"] as? String ?? ""
                let teacherEmail = dict["teacherEmail"] as? String ?? ""
                let teacherName = dict["teacherName"] as? String ?? ""
                let totalAppUsage = dict["totalAppUsage"] as? String ?? ""
                let totalDaysUsageTime = dict["totalDaysUsageTime"] as? String ?? ""
                let user = User(uid: "", email: email, name: name, teacherName: teacherName, teacherEmail: teacherEmail, level: level, totalAppUsage: totalAppUsage, todaysDay: totalAppUsage, todaysAppUsage: totalDaysUsageTime, country: country, correctAns: correctAns)
                self.users.append(user)
                
            }

            print("self.users = \(self.users)")
            DispatchQueue.main.async {
                self.loder.dismiss()
                self.tableView.reloadData()
            }
        }, withCancel: nil)
    }
    
    
   /* {

    }*/
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TopStudentCell", for: indexPath) as! TopStudentCell
        let user = self.users[indexPath.row]
        cell.name.text = user.name
        cell.scoreLabel.text = user.correctAns
        var country = user.country
        
        if user.country == "United States of America" {
            country = "United States"
        }
        let countryCode = self.locale(for: country).lowercased();
        
cell.flag.image = UIImage.init(named:countryCode)
        return cell
    }
    
    private func locale(for fullCountryName : String) -> String {
        let locales : String = ""
        for localeCode in NSLocale.isoCountryCodes {
            let identifier = NSLocale(localeIdentifier: localeCode)
            let countryName = identifier.displayName(forKey: NSLocale.Key.countryCode, value: localeCode)
            if fullCountryName.lowercased() == countryName?.lowercased() {
                return localeCode as! String
            }
        }
        return locales
    }
}
