//
//  ManagedTaskItem.swift
//  ToDo
//
//  Created by Vika on 19.05.2024.
//
//

import Foundation
import CoreData

@objc(ManagedTaskItem)
public class ManagedTaskItem: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var title: String
    @NSManaged public var isCompleted: Bool
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedTaskItem> {
        return NSFetchRequest<ManagedTaskItem>(entityName: "ManagedTaskItem")
    }
}
