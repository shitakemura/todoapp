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
    
    private let client: TodoAppApiClientProtocol
    private let todoItem: TodoItem
    
    init(client: TodoAppApiClientProtocol, todoItem: TodoItem) {
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
    }
}

extension EditTodoItemViewController {
    @objc private func didTapUpdate(_ sender: UIButton) {
        guard let title = titleTextField.text else { return }
        todoItem.set(title: title)
        
        client.update(todoItem: todoItem) { [weak self] todoListItem in
            self?.navigationController?.popViewController(animated: true)
        }
    }
}
