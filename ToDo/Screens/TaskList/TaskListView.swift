//
//  TaskListView.swift
//  ToDo
//
//  Created by Vika on 19.05.2024.
//

import UIKit

final class TaskListView: UIView {
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let allTaskCompletedButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 15
        
        var config = UIButton.Configuration.filled()
        config.contentInsets = NSDirectionalEdgeInsets(
            top: 10,
            leading: 20,
            bottom: 10,
            trailing: 20
        )
        
        config.title = "All tasks are completed"
        
        button.configuration = config
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let completedButtonHeight: CGFloat = 40
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(tableView)
        addSubview(allTaskCompletedButton)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            allTaskCompletedButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            allTaskCompletedButton.heightAnchor.constraint(equalToConstant: completedButtonHeight),
            allTaskCompletedButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}
