//
//  AboutAppVC.swift
//  AnalogueTimeApp
//
//  Created by Pravin Gawale on 28/09/18.
//  Copyright © 2018 Anita Smith. All rights reserved.
//

import UIKit

class AboutAppVC: BaseVC,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AboutAppVCCell", for: indexPath)
        if indexPath.row == 0 {
            cell.textLabel?.text = "24 hours in a day"
        } else if indexPath.row == 1 {
            cell.textLabel?.text = "Elly’s training"
        } else if indexPath.row == 2 {
            cell.textLabel?.text = "About Us"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        if indexPath.row == 0 || indexPath.row == 1 {
            let aboutUsVC = self.storyboard?.instantiateViewController(withIdentifier: "AboutUsVC") as! AboutUsVC
            aboutUsVC.type = (indexPath.row == 0) ? Type.TwentyFourHoursInDay : Type.EllysTraining
            self.navigationController?.pushViewController(aboutUsVC, animated: true)

        } else if indexPath.row == 2 {
            let aboutUsVC = self.storyboard?.instantiateViewController(withIdentifier: "AboutUsVC") as! AboutUsVC
            aboutUsVC.type = .AboutUs
            self.navigationController?.pushViewController(aboutUsVC, animated: true)

        }
    }
}
