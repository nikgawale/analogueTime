//
//  RegisterVC.swift
//  AnalogueTimeApp
//
//  Created by Pravin Gawale on 13/09/18.
//  Copyright © 2018 Anita Smith. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD
import DropDown

struct CountryRoot : Decodable{
    let countries: [Country]
    enum CodingKeys : String, CodingKey {
        case countries = ""
    }

}

struct Country :Decodable {
    
    var name: String    = ""
    var flag: String    = ""

    enum CodingKeys : String, CodingKey {
        case name
        case flag
    }
}

class RegisterVC: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var scrollview: UIScrollView!
    
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var studentNameTextField: UITextField!
    @IBOutlet weak var studentEmailTextField: UITextField!

    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var topLabel: UILabel!
    let loder = JGProgressHUD(style: .extraLight)
    
    var updateUserInfo = false
    let dropDown = DropDown()

    override func viewDidLoad() {
        super.viewDidLoad()

        let countriesUrl = URL(string:"https://restcountries.eu/rest/v2/all")
        loder.show(in: self.view)
        self.view.isUserInteractionEnabled = false
        let task = URLSession.shared.dataTask(with: countriesUrl!) { (data, resp, error) in
            DispatchQueue.main.async {
                self.loder.dismiss()
                self.view.isUserInteractionEnabled = true
            }
            if error != nil {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Error", message: "Error occured while fetching countries!! ", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }

            } else {
                guard let data = data else {
                    print("Error: No data to decode")
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Error", message: "Error occured while fetching countries!! ", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                    return
                }
                
                guard let countryRoot = try? JSONDecoder().decode([Country].self, from: data) else {
                    print("Error: Couldn't decode data into Experince")
                    return
                }

                self.dropDown.dataSource = countryRoot.map({ (count) -> String in
                    return count.name
                })
                print("Country - \(countryRoot)")
            }
        }
        task.resume()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.scrollview.isScrollEnabled = true
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        if updateUserInfo {
            
            topLabel.text = "UPDATE"
            registerBtn.setTitle("UPDATE", for: .normal)
            
            let name = DataManager.sharedManager.getUser()?.name
            let email = DataManager.sharedManager.getUser()?.email
            let country = DataManager.sharedManager.getUser()?.country

            self.studentNameTextField.text = name
            self.studentEmailTextField.text = email
            self.countryTextField.text = country
        } else {
            topLabel.text = "REGISTER"
            registerBtn.setTitle("REGISTER", for: .normal)
        }
        
        setUITextfieldUI(studentNameTextField)
        setUITextfieldUI(studentEmailTextField)
        setUITextfieldUI(countryTextField)

        dropDown.anchorView = countryTextField
        /*dropDown.dataSource =
            ["Afghanistan", "Albania", "Algeria","Andorra","Angola","Antigua and Barbuda","Argentina","Armenia","Australia","Austria","Azerbaijan",
             "Bahamas","Bahrain","Bangladesh","Barbados","Belarus","Belgium","Belize",
             "Benin","Bhutan","Bolivia","Bosnia and Herzegovina","Botswana","Brazil",
             "Brunei","Bulgaria","Burkina Faso","Burundi",
             "Cabo Verde",
             "Cambodia",
             "Cameroon",
             "Canada",
             "Central African Republic (CAR)",
             "Chad",
             "Chile",
             "China",
             "Colombia",
             "Comoros",
             "Democratic Republic of the Congo",
             "Republic of the Congo",
             "Costa Rica",
             "Cote d'Ivoire",
             "Croatia",
             "Cuba",
             "Cyprus",
             "Czech Republic",
             "Denmark",
             "Djibouti",
             "Dominica",
             " Dominican Republic",
             "Ecuador",
             "Egypt",
             "El Salvador",
             "Equatorial Guinea",
             "Eritrea",
             "Estonia",
             "Eswatini (formerly Swaziland)",
             "Ethiopia",
             "Fiji",
             "Finland",
             "France",
             "Gabon",
             "Gambia",
             "Georgia",
             "Germany",
             "Ghana",
             "Greece",
             "Grenada",
             "Guatemala",
             "Guinea",
             "Guinea-Bissau",
             "Guyana",
             "Haiti",
             "Honduras",
             "Hungary",
             "Iceland",
             "India",
             "Indonesia",
             "Iran",
             "Iraq",
             "Ireland",
             "Israel",
             "Italy",
             "Jamaica",
             "Japan",
             "Jordan",
             "Kazakhstan",
             "Kenya",
             "Kiribati",
             "Kosovo",
             "Kuwait",
             "Kyrgyzstan",
             "Laos",
             "Latvia",
             "Lebanon",
             "Lesotho",
             "Liberia",
             "Libya",
             "Liechtenstein",
             "Lithuania",
             "Luxembourg",
             "Macedonia (FYROM)",
             "Madagascar",
             "Malawi",
             "Malaysia",
             "Maldives",
             "Mali",
             "Malta",
             "Marshall Islands",
             "Mauritania",
             "Mauritius",
             "Mexico",
             "Micronesia",
             "Moldova",
             "Monaco",
             "Mongolia",
             "Montenegro",
             "Morocco",
             "Mozambique",
             "Myanmar (formerly Burma)",
             "Namibia",
             "Nauru",
             "Nepal",
             "Netherlands",
             "New Zealand",
             "Nicaragua",
             "Niger",
             "Nigeria",
             "North Korea",
             "Norway",
             "Oman",
             "Pakistan",
             "Palau",
             "Palestine",
             "Panama",
             "Papua New Guinea",
             "Paraguay",
             "Peru",
             "Philippines",
             "Poland",
             "Portugal",
             "Qatar",
             "Romania",
             "Russia",
             "Rwanda",
             "Saint Kitts and Nevis",
             "Saint Lucia",
             "Saint Vincent and the Grenadines",
             "Samoa",
             "San Marino",
             "Sao Tome and Principe",
             "Saudi Arabia",
             "Senegal",
             "Serbia",
             "Seychelles",
             "Sierra Leone",
             "Singapore",
             "Slovakia",
             "Slovenia",
             "Solomon Islands",
             "Somalia",
             "South Africa",
             "South Korea",
             "South Sudan",
             "Spain",
             "Sri Lanka",
             "Sudan",
             "Suriname",
             "Swaziland (renamed to Eswatini)",
             "Sweden",
             "Switzerland",
             "Syria",
             "Taiwan",
             "Tajikistan",
             "Tanzania",
             "Thailand",
             "Timor-Leste",
             "Togo",
             "Tonga",
             "Trinidad and Tobago",
             "Tunisia",
             "Turkey",
             "Turkmenistan",
             "Tuvalu",
             "Uganda",
             "Ukraine",
             "United Arab Emirates (UAE)",
             "United Kingdom (UK)",
             "United States of America (USA)",
             "Uruguay",
             "Uzbekistan",
             "Vanuatu",
             "Vatican City (Holy See)",
             "Venezuela",
             "Vietnam",
             "Yemen",
             "Zambia",
             "Zimbabwe"
        ]*/
        
        
        
        
       
        
        
        
        
        
        
        dropDown.width = 300

        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.countryTextField.text = item
        }

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        let info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let keyboardHeight: CGFloat = keyboardSize.height
        let duration = info[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        UIView.animate(withDuration: duration, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.scrollview.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
        }, completion: nil)
    }
    
    func setUITextfieldUI(_ textField:UITextField) {
        let myColor = UIColor.gray
        textField.layer.borderColor = myColor.cgColor
        textField.layer.borderWidth = 1.0
        
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.rightViewMode = .always
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        let info = notification.userInfo!
        let duration = info[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        UIView.animate(withDuration: duration, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.scrollview.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }, completion: nil)
    }
    
    @IBAction func registerAction(_ sender: Any) {
        
        guard let name = studentNameTextField.text, let email = studentEmailTextField.text , let country = countryTextField.text else {
            print("Form is not valid")
            return
        }
        
        
        
        if (name.isEmpty || email.isEmpty || country.isEmpty)  {
            let alert = UIAlertController(title: "Error", message: "Please enter Student Details ", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        loder.show(in: self.view)

        if updateUserInfo {
            
            let originalEmail = DataManager.sharedManager.getUser()?.email
            Auth.auth().signIn(withEmail: originalEmail!, password: "12345678") { (result, error) in
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
                
                result?.user.updateEmail(to: email, completion: { (error) in
                    if let error = error {
                        print(error)
                        self.loder.dismiss()
                        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        
                        return
                        
                    } else {
                        //successfully authenticated user
                        let ref = Database.database().reference()
                        let uid =  Auth.auth().currentUser?.uid
                        let usersReference = ref.child("users").child(uid!)
                        var values = ["name": name, "email": email, "country" : country]
                        
                      
                        
                        values["level"] = DataManager.sharedManager.getUser()?.level
                        values["totalAppUsage"] = "0"
                        values["totalDaysUsageTime"] = "0-0"
                        values["correctAns"] = "0"

                        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                            
                            self.loder.dismiss()
                            
                            if let err = err {
                                print(err)
                                return
                            }
                            
                            let alert = UIAlertController(title: "Success", message: "Student info updated Successfully, Try login once again!", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                                DispatchQueue.main.async {
                                    
                                    let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                                    
                                    self.navigationController?.viewControllers = [loginVC]
                                }
                            }))
                            self.present(alert, animated: true, completion: nil)
                            

                            print("Saved user successfully into Firebase db")
                            
                        })
                    }
                })
            }
        } else {
            Auth.auth().createUser(withEmail: email, password: "12345678") { (result, error) in
                
                
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
                
                //successfully authenticated user
                let ref = Database.database().reference()
                let usersReference = ref.child("users").child(uid)
                var values = ["name": name, "email": email]
                
                
                values["level"] = ""
                values["totalAppUsage"] = "0"
                values["totalDaysUsageTime"] = "0-0"
                values["country"] = country
                values["correctAns"] = "0"

                usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                    
                    self.loder.dismiss()
                    
                    if let err = err {
                        print(err)
                        return
                    }
                    
                    let alert = UIAlertController(title: "Success", message: "Student Registered Successfully, Try login!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        DispatchQueue.main.async {
                            
                            let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                            
                            self.navigationController?.viewControllers = [loginVC]
                        }
                    }))
                    self.present(alert, animated: true, completion: nil)

                    print("Saved user successfully into Firebase db")
                    
                })
            }
        }

        
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK :- UITextField delegate
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == countryTextField {
            dropDown.show()
            return false
        }
        dropDown.hide()
        return true
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == studentNameTextField {
            studentEmailTextField.becomeFirstResponder()
        } else if textField == studentEmailTextField {
            studentEmailTextField.resignFirstResponder()
        }
        return true
    }

}



