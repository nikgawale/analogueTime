//
//  DayAppUsage.swift
//  AnalogueTimeApp
//
//  Created by Pravin Gawale on 04/10/18.
//  Copyright © 2018 Anita Smith. All rights reserved.
//

import UIKit
import CoreData

class DayAppUsageObj: NSObject {
    var totalDayAppUsageTime =  ""
    var uploaded: Bool = false
    var day = ""

    func mapDayAppUsage(totalDayAppUsageTime: String, uploaded:Bool, day:String) {
        self.totalDayAppUsageTime = totalDayAppUsageTime
        self.uploaded = uploaded
        self.day = day
    }
}


public class DayAppUsage: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<DayAppUsage> {
        return NSFetchRequest<DayAppUsage>(entityName: "DayAppUsage");
    }
    
    @NSManaged public var totalDayAppUsageTime: String
    @NSManaged public var uploaded: Bool
    @NSManaged public var day: String

    func fillObject(_ obj:DayAppUsageObj) {
        self.totalDayAppUsageTime = obj.totalDayAppUsageTime
        self.day = obj.day
        self.uploaded = obj.uploaded
    }

}
