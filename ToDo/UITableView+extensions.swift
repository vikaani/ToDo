//
//  UITableView+extensions.swift
//  ToDo
//
//  Created by Vika on 21.05.2024.
//

import UIKit

extension UITableView {
    func register<T: UITableViewCell>(cellType: T.Type) {
        let className = String(describing: cellType)
        self.register(cellType, forCellReuseIdentifier: className)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        let className = String(describing: T.self)
        guard let cell = self.dequeueReusableCell(withIdentifier: className, for: indexPath) as? T else {
            fatalError("Error: Could not dequeue cell with identifier: \(className)")
        }
        return cell
    }
}


