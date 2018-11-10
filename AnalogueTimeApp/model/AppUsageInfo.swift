//
//  AppUsageInfoObj.swift
//  AnalogueTimeApp
//
//  Created by Pravin Gawale on 30/09/18.
//  Copyright © 2018 Anita Smith. All rights reserved.
//

import UIKit
import CoreData

class AppUsageInfoObj: NSObject {
    var totalUsageTime =  ""
    var uploaded: Bool = false

    func mapAppUsageInfo(totalUsageTime: String, uploaded:Bool) {
        self.totalUsageTime = totalUsageTime
        self.uploaded = uploaded
    }
}

public class AppUsageInfo: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<AppUsageInfo> {
        return NSFetchRequest<AppUsageInfo>(entityName: "AppUsage");
    }
    
    @NSManaged public var totalUsageTime: String
    @NSManaged public var uploaded: Bool

    func fillObject(_ obj:AppUsageInfoObj) {
        self.totalUsageTime = obj.totalUsageTime
        self.uploaded = obj.uploaded
    }
}
