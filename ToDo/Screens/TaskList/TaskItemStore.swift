//
//  TaskItemStore.swift
//  ToDo
//
//  Created by Vika on 18.05.2024.
//

import Foundation

protocol TaskItemStore {
    func retrieve() throws -> [TaskItem]
    func save(taskItem: TaskItem) throws
    func update(taskItem: TaskItem) throws
    func removeTaskItem(byID id: UUID) throws
    func removeAll() throws
}


