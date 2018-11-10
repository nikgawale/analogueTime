//
//  ViewController.swift
//  AnalogueTimeApp
//
//  Created by Pravin Gawale on 09/09/18.
//  Copyright © 2018 Anita Smith. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import JGProgressHUD


class User : NSObject, NSCoding {
    var uid = ""
    var email = ""
    var name = ""
    var teacherName = ""
    var teacherEmail = ""
    var level = ""
    var totalAppUsage = "0"
    var todaysDay = "0"
    var todaysAppUsage = "0"
    var country = ""
    var correctAns = "0"

    init(uid: String,email: String, name: String,teacherName: String, teacherEmail: String, level: String, totalAppUsage: String,todaysDay:String,todaysAppUsage:String, country: String,correctAns: String) {
        self.uid = uid
        self.email = email
        self.name = name
        self.teacherName = teacherName
        self.teacherEmail = teacherEmail
        self.level = level
        self.totalAppUsage = totalAppUsage
        self.country = country
        self.todaysDay = todaysDay
        self.todaysAppUsage = todaysAppUsage
        self.correctAns = correctAns
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let uid = aDecoder.decodeObject(forKey: "uid") as! String
        let email = aDecoder.decodeObject(forKey: "email") as! String
        let name = aDecoder.decodeObject(forKey: "name") as! String
        let teacherName = aDecoder.decodeObject(forKey: "teacherName") as! String
        let teacherEmail = aDecoder.decodeObject(forKey: "teacherEmail") as! String
        let level = aDecoder.decodeObject(forKey: "level") as! String
        let country = aDecoder.decodeObject(forKey: "country") as! String
        let totalAppUsage = aDecoder.decodeObject(forKey: "totalAppUsage") as! String
        let todaysDay = aDecoder.decodeObject(forKey: "todaysDay") as! String
        let todaysAppUsage = aDecoder.decodeObject(forKey: "todaysAppUsage") as! String
        let correctAns = aDecoder.decodeObject(forKey: "correctAns") as! String
        self.init(uid: uid, email: email, name: name, teacherName: teacherName, teacherEmail: teacherEmail, level: level, totalAppUsage: totalAppUsage, todaysDay: todaysDay, todaysAppUsage: todaysAppUsage, country: country, correctAns: correctAns)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(uid, forKey: "uid")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(teacherName, forKey: "teacherName")
        aCoder.encode(teacherEmail, forKey: "teacherEmail")
        aCoder.encode(level, forKey: "level")
        aCoder.encode(totalAppUsage, forKey: "totalAppUsage")
        aCoder.encode(todaysDay, forKey: "todaysDay")
        aCoder.encode(todaysAppUsage, forKey: "todaysAppUsage")
        aCoder.encode(country, forKey: "country")
        aCoder.encode(correctAns, forKey: "correctAns")
    }

}


class LoginVC: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!


    let loder = JGProgressHUD(style: .extraLight)


    override func viewDidLoad() {
        super.viewDidLoad()
        setUITextfieldUI(usernameTextField)
    }

    func setUITextfieldUI(_ textField:UITextField) {
        let myColor = UIColor.gray
        textField.layer.borderColor = myColor.cgColor
        textField.layer.borderWidth = 1.0
        
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.rightViewMode = .always
    }
    
    @IBAction func registerAction(_ sender: Any) {
        let registerVC = self.storyboard?.instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
        self.navigationController?.pushViewController(registerVC, animated: true)
    }
    
    
    @IBAction func loginAction(_ sender: Any) {
        
        guard let email = usernameTextField.text else {
            print("Form is not valid")
            return
        }
        
        if (email.isEmpty) {
            let alert = UIAlertController(title: "Error", message: "Please enter Email ID", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        loder.show(in: self.view)
        
       
        
        Auth.auth().signIn(withEmail: email, password: "12345678") { (result, error) in
            
            if let error = error {
                print(error)
                self.loder.dismiss()
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }

            guard let uid = result?.user.uid else {
                return
            }
            
            let appdelegate  = UIApplication.shared.delegate as! AppDelegate
            appdelegate.totalUsage = Date()
            
            Database.database().reference().child("users").child(uid).observe(.value, with: { (snap : DataSnapshot) in
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
                    let user  = User(uid: uid, email: email, name: name, teacherName: teacherName, teacherEmail: teacherEmail, level: level, totalAppUsage: totalAppUsage, todaysDay: todaysDay, todaysAppUsage: todaysAppUsage, country: country, correctAns: correctAns)
                    DataManager.sharedManager.saveUser(user: user)
                    let prevLoginVC = self.storyboard?.instantiateViewController(withIdentifier: "PreviousLoginVC") as! PreviousLoginVC
                    self.navigationController?.pushViewController(prevLoginVC, animated: true)
                } else {
                    let alert = UIAlertController(title: "Error", message: "Some thing Went wrong, Check email address once again!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)

                }
                self.loder.dismiss()
            })

        }
    }
    
    //MARK :- UITextField delegate
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == usernameTextField {
            usernameTextField.resignFirstResponder()
        }
        return true
    }


}

