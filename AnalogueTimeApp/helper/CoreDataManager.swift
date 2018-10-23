//
//  CoreDataManager.swift
//  AnalogueTimeApp
//
//  Created by Pravin Gawale on 30/09/18.
//  Copyright © 2018 Anita Smith. All rights reserved.
//

import CoreData

class CoreDataManager:NSObject {

    public static var shared: CoreDataManager = {
        return CoreDataManager()
    }()
    
    override init() {
        super.init()
    }

    public func updateStausForDayUsage (_ obj: DayAppUsageObj) {
        persistentContainer.performBackgroundTask { (context) in
            let fetchRequest = NSFetchRequest<DayAppUsage>(entityName: "DayAppUsage")
            do {
                let filesArray = try context.fetch(fetchRequest)
                if let file = filesArray.first {
                    file.day = obj.day
                    file.uploaded = obj.uploaded
                    file.totalDayAppUsageTime = obj.totalDayAppUsageTime
                    do {
                        try context.save()
                    } catch {
                        print("Failed saving")
                    }
                } else {
                    print("Failed saving")
                }
                
            } catch {
                print("Failed saving")
            }
        }
    }
    public func deleteDaysAppUsage(completion:@escaping (Bool)-> Void) {
        persistentContainer.performBackgroundTask { (context) in
            let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "DayAppUsage")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
            
            do {
                try context.execute(deleteRequest)
                try context.save()
                completion(true)
            } catch {
                print ("There was an error")
                completion(false)
            }
        }
    }
    
    public func saveDaysAppUsage(_ obj:DayAppUsageObj) {
        persistentContainer.performBackgroundTask { (context) in
            let entity = NSEntityDescription.entity(forEntityName: "DayAppUsage", in: context)
            let newUser = NSManagedObject(entity: entity!, insertInto: context) as! DayAppUsage
            newUser.fillObject(obj)
            do {
                try context.save()
            } catch {
                print("Failed saving")
            }
        }
    }
    
    public func getDaysAppUsage() -> DayAppUsageObj? {
        let context = persistentContainer.newBackgroundContext()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DayAppUsage")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            if result.count > 0 {
                let results = DayAppUsageObj()
                let data = result.first as! DayAppUsage
                results.mapDayAppUsage(totalDayAppUsageTime: data.totalDayAppUsageTime, uploaded: data.uploaded, day: data.day)
            }
            return nil
        } catch {
            print("Failed")
        }
        return nil
    }
    
    func deleteAppUsageInfo(completion:@escaping (Bool)-> Void) {
        persistentContainer.performBackgroundTask { (context) in
            let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "AppUsageInfo")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
            
            do {
                try context.execute(deleteRequest)
                try context.save()
                completion(true)
            } catch {
                print ("There was an error")
                completion(false)
            }
        }
    }
    
    public func saveAppUsageInfo(_ obj:AppUsageInfoObj) {
        persistentContainer.performBackgroundTask { (context) in
            let entity = NSEntityDescription.entity(forEntityName: "AppUsageInfo", in: context)
            let newUser = NSManagedObject(entity: entity!, insertInto: context) as! AppUsageInfo
            newUser.fillObject(obj)
            do {
                try context.save()
            } catch {
                print("Failed saving")
            }
        }
    }
    
    public func getAppUsageInfo() -> AppUsageInfoObj? {
        let context = persistentContainer.newBackgroundContext()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "AppUsageInfo")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            if result.count > 0 {
                let results = AppUsageInfoObj()
                let data = result.first as! AppUsageInfo
                results.mapAppUsageInfo(totalUsageTime: data.totalUsageTime, uploaded: data.uploaded)
            }
            return nil
        } catch {
            print("Failed")
        }
        return nil
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "AnalogueTimeApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
