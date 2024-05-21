//
//  TaskListViewController.swift
//  ToDo
//
//  Created by Vika on 18.05.2024.
//

import UIKit

final class TaskListViewController: UIViewController {
    private let taskListView = TaskListView()
    private let cellHeight: CGFloat = 50
    
    private let store: TaskItemStore
    private var taskItems: [TaskItem] = [] {
        didSet { updateAllTaskCompletedButton() }
    }
    
    init(store: TaskItemStore) {
        self.store = store
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = taskListView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        retrieveTaskItems()
    }
    
    @objc private func didTapAddButton() {
        let newTaskItem = TaskItem(
            id: UUID(),
            title: "",
            isCompleted: false
        )
        
        let vc = TaskContentViewController(
            taskItem: newTaskItem,
            headerTitle: "Add",
            actionButtonTitle: "Save"
        )
        
        vc.onCompleted = { [weak self] newTask in
            self?.taskItems.append(newTask)
            self?.taskListView.tableView.reloadData()
            try? self?.store.save(taskItem: newTask)
            self?.navigationController?.dismiss(animated: true)
        }
        
        vc.onCancel = { [weak self] in
            self?.navigationController?.dismiss(animated: true)
        }
        
        let detailNavigationController = UINavigationController(rootViewController: vc)
        navigationController?.present(detailNavigationController, animated: true)
    }
    
    @objc private func didTapClearButton() {
        taskItems.removeAll()
        taskListView.tableView.reloadData()
        try? store.removeAll()
    }
    
    private func retrieveTaskItems() {
        do {
            let result = try store.retrieve()
            self.taskItems = result
            taskListView.tableView.reloadData()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func removeTaskItem(at indexPath: IndexPath) {
        let taskItem = taskItems[indexPath.row]
        try? store.removeTaskItem(byID: taskItem.id)
        taskItems.remove(at: indexPath.row)
        taskListView.tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    private func openUpdateScreen(indexPath: IndexPath) {
        let taskItem = taskItems[indexPath.row]
        let vc = TaskContentViewController(
            taskItem: taskItem,
            headerTitle: "Update",
            actionButtonTitle: "Save"
        )
        
        vc.onCompleted = { [weak self] updatedTaskItem in
            self?.taskItems[indexPath.row] = updatedTaskItem
            self?.taskListView.tableView.reloadData()
            try? self?.store.update(taskItem: updatedTaskItem)
            self?.navigationController?.dismiss(animated: true)
        }
        
        vc.onCancel = { [weak self] in
            self?.navigationController?.dismiss(animated: true)
        }
        
        let detailNavigationController = UINavigationController(rootViewController: vc)
        navigationController?.present(detailNavigationController, animated: true)
    }
}

extension TaskListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        taskItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TaskItemCell = tableView.dequeueReusableCell(for: indexPath)
        
        var taskItem = taskItems[indexPath.row]
        
        if taskItem.isCompleted {
            cell.checkmarkImageView.image = .checkmarkFill
            cell.titleLabel.setStrikethroughText(taskItem.title)
            cell.titleLabel.textColor = .systemGray2
        } else {
            cell.checkmarkImageView.image = .checkmarkEmpty
            cell.titleLabel.attributedText = NSAttributedString(string: taskItem.title)
            cell.titleLabel.textColor = .label
        }
        
        cell.onTapImage = { [weak self] cell in
            guard let self else {return }
            taskItem.isCompleted.toggle()
            taskItems[indexPath.row].isCompleted = taskItem.isCompleted
            tableView.reloadRows(at: [indexPath], with: .none)
            
            try? store.update(taskItem: taskItem)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        cellHeight
    }
}

extension TaskListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _,_,_  in
            self?.removeTaskItem(at: indexPath)
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { [weak self] _,_,_ in
            self?.openUpdateScreen(indexPath: indexPath)
        }
        
        editAction.backgroundColor = .systemOrange
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        return configuration
    }
}

private extension TaskListViewController {
    func setupViews() {
        setupNavigationButtons()
        
        taskListView.tableView.dataSource = self
        taskListView.tableView.delegate = self
        taskListView.tableView.register(cellType: TaskItemCell.self)
        
        title = "ToDo"
    }
    
    func setupNavigationButtons() {
        navigationItem.rightBarButtonItem =  UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(didTapAddButton))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Clear",
            style: .plain,
            target: self, action: #selector(didTapClearButton))
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func updateAllTaskCompletedButton() {
        let isAllTaskCompleted = taskItems.allSatisfy { $0.isCompleted }
        taskListView.allTaskCompletedButton.isHidden = !isAllTaskCompleted
    }
}
