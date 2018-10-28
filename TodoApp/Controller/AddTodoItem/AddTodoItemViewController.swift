//
//  AddTodoItemViewController.swift
//  TodoApp
//
//  Created by Shintaro Takemura on 2018/10/24.
//  Copyright © 2018 Shintaro Takemura. All rights reserved.
//

import UIKit

class AddTodoItemViewController: UIViewController {
    @IBOutlet private weak var titleTextField: UITextField!
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var addTodoItemButton: UIButton!
    
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

extension AddTodoItemViewController {
    private func setupButton() {
        closeButton.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
        addTodoItemButton.addTarget(self, action: #selector(didTapAddItem), for: .touchUpInside)
    }
}

extension AddTodoItemViewController {
    @objc private func didTapClose(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapAddItem(_ sender: UIButton) {
        guard let title = titleTextField.text else { return }
        let todoItem = TodoItem(title: title)
        
        let request = TodoAppApi.addTodoItem(todoItem: todoItem)
        apiClient.send(request: request) { result in
            switch result {
            case let .success(response):
                print("追加成功 response: \(response)")
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
                
            case let .failure(error):
                print("エラーが発生しました: \(error)") // エラー詳細を出力
            }
        }
    }
}
