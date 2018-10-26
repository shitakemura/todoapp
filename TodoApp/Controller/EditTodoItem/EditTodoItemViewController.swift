//
//  EditTodoItemViewController.swift
//  TodoApp
//
//  Created by Shintaro Takemura on 2018/10/26.
//  Copyright © 2018 Shintaro Takemura. All rights reserved.
//

import UIKit

class EditTodoItemViewController: UIViewController {

    @IBOutlet private weak var titleTextField: UITextField!
    @IBOutlet private weak var updateButton: UIButton!
    @IBOutlet private weak var deleteButton: UIButton!
    
    private let client: EditTodoItemApiClientProtocol
    private let todoItem: TodoItem
    
    init(client: EditTodoItemApiClientProtocol, todoItem: TodoItem) {
        self.client = client
        self.todoItem = todoItem
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupButton()
        set(titleText: todoItem.title)
    }
}

extension EditTodoItemViewController {
    private func setupNavigation() {
        title = "EditTodo"
    }
    
    private func set(titleText: String) {
        titleTextField.text = titleText
    }
    
    private func setupButton() {
        updateButton.addTarget(self, action: #selector(didTapUpdate), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(didTapDelete), for: .touchUpInside)
    }
}

extension EditTodoItemViewController {
    @objc private func didTapUpdate(_ sender: UIButton) {
        guard let title = titleTextField.text else { return }
        todoItem.set(title: title)
        
        client.update(todoItem: todoItem) { [weak self] todoListItem in
            DispatchQueue.main.async {
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @objc private func didTapDelete(_ sender: UIButton) {
        client.delete(todoItem: todoItem) { [weak self] in
            DispatchQueue.main.async {
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
}