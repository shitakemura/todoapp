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
    
    private let todoItem: TodoItem
    
    init(todoItem: TodoItem) {
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
    }
}

extension EditTodoItemViewController {
    private func setupNavigation() {
        title = "EditTodo"
    }
    
    private func setupButton() {
        updateButton.addTarget(self, action: #selector(didTapUpdate), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(didTapDelete), for: .touchUpInside)
    }
}

extension EditTodoItemViewController {
    @objc private func didTapUpdate(_ sender: UIButton) {
        print("didTapUpdate")
    }
    
    @objc private func didTapDelete(_ sender: UIButton) {
        print("didTapDelete")
    }
}
