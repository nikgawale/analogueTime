//
//  DataManager.swift
//  AnalogueTimeApp
//
//  Created by Pravin Gawale on 13/09/18.
//  Copyright © 2018 Anita Smith. All rights reserved.
//

import UIKit

class DataManager {
    static let sharedManager = DataManager()
    var currentUser: User?
    
    func saveUser(user: User) {
        DispatchQueue.main.async {
            UserDefaults.standard.removeObject(forKey: "User")
            let userdata = NSKeyedArchiver.archivedData(withRootObject: [user])
            UserDefaults.standard.set(userdata, forKey: "User")
            UserDefaults.standard.synchronize()
        }
    }
    
    func getUser() -> User? {
        if let userdata = UserDefaults.standard.object(forKey: "User") {
            let user:[User] = NSKeyedUnarchiver.unarchiveObject(with: userdata as! Data) as! [User]
            return user.first
            
        }
        return nil
   }
    
    func removeUser() {
        DispatchQueue.main.async {
            UserDefaults.standard.removeObject(forKey: "User")
            UserDefaults.standard.synchronize()
        }
    }
}
