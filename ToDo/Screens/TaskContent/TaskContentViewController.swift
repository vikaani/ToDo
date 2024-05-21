//
//  TaskContentViewController.swift
//  ToDo
//
//  Created by Vika on 18.05.2024.
//

import UIKit

final class TaskContentViewController: UIViewController {    
    var onCompleted: ((TaskItem) -> Void)?
    var onCancel: (() -> Void)?
    
    private var taskItem: TaskItem
    private let headerTitle: String
    private let actionButtonTitle: String
    
    private let addTaskView = TaskContentView()
    
    init(taskItem: TaskItem, headerTitle: String, actionButtonTitle: String) {
        self.taskItem = taskItem
        self.headerTitle = headerTitle
        self.actionButtonTitle = actionButtonTitle
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = addTaskView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        addTaskView.textField.becomeFirstResponder()
    }
   
    @objc private func didTapCancelButton() {
        onCancel?()
    }
    
    @objc private func didTapActionButton() {
        guard let text = addTaskView.textField.text else { return }
        taskItem.title = text
        onCompleted?(taskItem)
    }
}

extension TaskContentViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        addTaskView.textField.resignFirstResponder()
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = (addTaskView.textField.text! as NSString).replacingCharacters(in: range, with: string)
        navigationItem.rightBarButtonItem?.isEnabled = !text.isEmpty
        return true
    }
}

private extension TaskContentViewController {
    func setupViews() {
        addTaskView.textField.delegate = self
        addTaskView.textField.text = taskItem.title
       
        title = headerTitle
        
        setupNavigation()
    }
    
    func setupNavigation() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Cancel",
            style: .plain,
            target: self,
            action: #selector(didTapCancelButton)
        )
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: actionButtonTitle,
            style: .done,
            target: self,
            action: #selector(didTapActionButton)
        )
        
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
}
