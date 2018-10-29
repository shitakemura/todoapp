//
//  EditTodoViewController.swift
//  TodoApp
//
//  Created by Shintaro Takemura on 2018/10/26.
//  Copyright © 2018 Shintaro Takemura. All rights reserved.
//

import UIKit

final class EditTodoViewController: UIViewController {
    @IBOutlet private weak var taskNameTextField: UITextField!
    @IBOutlet private weak var updateTodoButton: UIButton!
    
    private let apiClient: TodoAppApiClient
    private let todo: Todo
    
    init(apiClient: TodoAppApiClient, todo: Todo) {
        self.apiClient = apiClient
        self.todo = todo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupButton()
        set(taskName: todo.taskName)
    }
}

// MARK: - Private method
extension EditTodoViewController {
    private func setupNavigation() {
        title = "EditTodo"
    }
    
    private func set(taskName: String) {
        taskNameTextField.text = taskName
    }
    
    private func setupButton() {
        updateTodoButton.addTarget(self, action: #selector(didTapUpdateTodo), for: .touchUpInside)
    }
}

// MARK: - Action method
extension EditTodoViewController {
    @objc private func didTapUpdateTodo(_ sender: UIButton) {
        guard let taskName = taskNameTextField.text else { return }
        todo.set(taskName: taskName)
        
        // Todo更新リクエスト送信
        let request = TodoAppApi.updateTodo(todo: todo)
        apiClient.send(request: request) { result in
            switch result {
            case let .success(response):
                print("更新成功 response: \(response)")
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
                
            case let .failure(error):
                DispatchQueue.main.async {
                    self.present(self.apiClient.errorAlert(with: error.message), animated: true, completion: nil)
                }
            }
        }
    }
}
