//
//  AddTodoViewController.swift
//  TodoApp
//
//  Created by Shintaro Takemura on 2018/10/24.
//  Copyright © 2018 Shintaro Takemura. All rights reserved.
//

import UIKit

final class AddTodoViewController: UIViewController {
    @IBOutlet private weak var taskNameTextField: UITextField!
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var addTodoButton: UIButton!
    
    private let apiClient: TodoAppApiClient

    init(apiClient: TodoAppApiClient) {
        self.apiClient = apiClient
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
    }
}

// MARK: - Private method
extension AddTodoViewController {
    private func setupButton() {
        closeButton.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
        addTodoButton.addTarget(self, action: #selector(didTapAddTodo), for: .touchUpInside)
    }
}

// MARK: - Action method
extension AddTodoViewController {
    @objc private func didTapClose(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapAddTodo(_ sender: UIButton) {
        guard let taskName = taskNameTextField.text else { return }
        let todo = Todo(taskName: taskName)
        
        // Todo追加リクエスト送信
        let request = TodoAppApi.AddTodo(todo: todo)
        apiClient.send(request: request) { result in
            switch result {
            case let .success(response):
                print("Todo追加成功 response: \(response)")
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
                
            case let .failure(error):
                DispatchQueue.main.async {
                    self.present(self.apiClient.errorAlert(with: error.message), animated: true, completion: nil)
                }
            }
        }
    }
}
