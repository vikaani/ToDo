//
//  CoreDataTaskItemStore.swift
//  ToDo
//
//  Created by Vika on 18.05.2024.
//

import Foundation
import CoreData

final class CoreDataTaskItemStore: TaskItemStore {
    private let persistanceContainer: NSPersistentContainer
    
    init() {
        persistanceContainer = NSPersistentContainer(name: "TaskItemStore")
        persistanceContainer.loadPersistentStores { _, error in
            if let error {
                print(error.localizedDescription)
            }
        }
    }
    
    func retrieve() throws -> [TaskItem] {
        let request = ManagedTaskItem.fetchRequest()
        let managedTaskItems = try persistanceContainer.viewContext.fetch(request)
        let taskItems = managedTaskItems.map { managedTaskItem in
            TaskItem(id: managedTaskItem.id, title: managedTaskItem.title, isCompleted: managedTaskItem.isCompleted)
        }
        
        return taskItems
    }
    
    func save(taskItem: TaskItem) throws {
        let managedTaskItem = ManagedTaskItem(context: persistanceContainer.viewContext)
        managedTaskItem.id = taskItem.id
        managedTaskItem.title = taskItem.title
        managedTaskItem.isCompleted = taskItem.isCompleted
        try persistanceContainer.viewContext.save()
    }
    
    func update(taskItem: TaskItem) throws {
        let request = ManagedTaskItem.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", taskItem.id.uuidString)
        let managedTaskItems = try persistanceContainer.viewContext.fetch(request)
        guard let firstManagedTaskItem = managedTaskItems.first else { return }
        firstManagedTaskItem.title = taskItem.title
        firstManagedTaskItem.isCompleted = taskItem.isCompleted
        try persistanceContainer.viewContext.save()
    }
    
    func removeTaskItem(byID id: UUID) throws {
        let request = ManagedTaskItem.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id.uuidString)
        let managedTaskItems = try persistanceContainer.viewContext.fetch(request)
        guard let firstManagedTaskItem = managedTaskItems.first else { return }
        persistanceContainer.viewContext.delete(firstManagedTaskItem)
        try persistanceContainer.viewContext.save()
    }
    
    func removeAll() throws {
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: ManagedTaskItem.fetchRequest())
        try persistanceContainer.viewContext.execute(deleteRequest)
        try persistanceContainer.viewContext.save()
    }
}
