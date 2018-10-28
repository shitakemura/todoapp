//
//  EditTodoItemViewController.swift
//  TodoApp
//
//  Created by Shintaro Takemura on 2018/10/26.
//  Copyright © 2018 Shintaro Takemura. All rights reserved.
//

import UIKit

final class EditTodoItemViewController: UIViewController {
    @IBOutlet private weak var titleTextField: UITextField!
    @IBOutlet private weak var updateButton: UIButton!
    
    private let apiClient: TodoAppApiClient
    private let todoItem: TodoItem
    
    init(apiClient: TodoAppApiClient, todoItem: TodoItem) {
        self.apiClient = apiClient
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

// MARK: - Private method
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

// MARK: - Action method
extension EditTodoItemViewController {
    @objc private func didTapUpdate(_ sender: UIButton) {
        guard let title = titleTextField.text else { return }
        todoItem.set(title: title)
        
        // TodoItem更新リクエスト送信
        let request = TodoAppApi.updateTodoItem(todoItem: todoItem)
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
