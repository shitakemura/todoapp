//
//  TodoItemListViewController.swift
//  TodoApp
//
//  Created by Shintaro Takemura on 2018/10/24.
//  Copyright © 2018 Shintaro Takemura. All rights reserved.
//

import UIKit

final class TodoItemListViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var addTodoButton: UIButton!
    
    private let apiClient: TodoAppApiClient
    private(set) var todoItems: [TodoItem]
    
    init(apiClient: TodoAppApiClient, todoItems: [TodoItem]) {
        self.apiClient = apiClient
        self.todoItems = todoItems
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupTableView()
        setupButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchTodoItems()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.isEditing = editing
    }
}

// MARK: - Private method
extension TodoItemListViewController {
    private func setupNavigation() {
        title = "Todo一覧"
        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "全削除", style: .plain, target: self, action: #selector(didTapClearTodos))
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 70
        tableView.register(cellType: TodoItemTableViewCell.self)
    }
    
    private func setupButton() {
        addTodoButton.layer.borderWidth = 1.0
        addTodoButton.layer.borderColor = UIColor.blue.cgColor
        addTodoButton.layer.masksToBounds = true
        addTodoButton.layer.cornerRadius = addTodoButton.frame.width * 0.5
        addTodoButton.addTarget(self, action: #selector(didTapAddTodo), for: .touchUpInside)
    }
    
    private func fetchTodoItems() {
        // 全TodoItem取得リクエスト送信
        let request = TodoAppApi.fetchTodoItems()
        apiClient.send(request: request) { result in
            switch result {
            case let .success(response):
                print("全TodoItem取得処理： 成功")
                self.todoItems = response
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case let .failure(error):
                DispatchQueue.main.async {
                    self.present(self.apiClient.errorAlert(with: error.message), animated: true, completion: nil)
                }
            }
        }
    }
}

// MARK: - Action method
extension TodoItemListViewController {
    @objc private func didTapAddTodo(_ sender: UIButton) {
        let addTodoItemViewController = AddTodoItemViewController(apiClient: apiClient)
        present(addTodoItemViewController, animated: true) {
            // tableViewが編集モードになっている場合は、画面遷移した後に通常モードに戻しておく
            if self.tableView.isEditing {
                self.setEditing(false, animated: false)
            }
        }
    }
    
    @objc private func didTapClearTodos(_ sender: UIButton) {
        if todoItems.isEmpty { return }
        
        // 全削除確認アラートOK押下時: 全TodoItem削除リクエスト送信
        let clearTodoItems: ((UIAlertAction) -> Void)? = { _ in
            let request = TodoAppApi.clearTodoItems()
            self.apiClient.send(request: request) { result in
                switch result {
                case let .success(response):
                    print("TodoItems全削除成功 response: \(response)")
                    DispatchQueue.main.async {
                        self.fetchTodoItems()
                    }
                case let .failure(error):
                    DispatchQueue.main.async {
                        self.present(self.apiClient.errorAlert(with: error.message), animated: true, completion: nil)
                    }
                }
            }
        }

        let alertController: UIAlertController = {
            let alertController = UIAlertController(title: "全てのTodoを削除します", message: "よろしいですか？", preferredStyle: .alert)
                .addAction(title: "OK", style: .default, handler: clearTodoItems)
                .addAction(title: "キャンセル", style: .cancel, handler: nil)
            return alertController
        }()
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDelegate
extension TodoItemListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let todoItem = todoItems[indexPath.row]
        let editTodoItemViewController = EditTodoItemViewController(apiClient: apiClient, todoItem: todoItem)
        navigationController?.pushViewController(editTodoItemViewController, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension TodoItemListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(with: TodoItemTableViewCell.self, for: indexPath) else { return UITableViewCell() }
        
        let todoItem = todoItems[indexPath.row]
        cell.bind(todoItem: todoItem)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle != .delete { return }
        
        // 編集モードで削除ボタン押下時: TodoItem削除リクエスト送信
        let request = TodoAppApi.deleteTodoItem(todoItem: todoItems[indexPath.row])
        apiClient.send(request: request) { result in
            switch result {
            case let .success(response):
                print("TodoItem削除成功 response: \(response)")
                DispatchQueue.main.async {
                    self.fetchTodoItems()
                }
            case let .failure(error):
                DispatchQueue.main.async {
                    self.present(self.apiClient.errorAlert(with: error.message), animated: true, completion: nil)
                }
            }
        }
    }
}

// MARK: - TodoItemTableViewCellDelegate
extension TodoItemListViewController: TodoItemTableViewCellDelegate {
    // TableViewCell.todoItemが変更時: TodoItem更新リクエスト送信
    func todoItemTableViewCell(_ todoItemTableViewCell: TodoItemTableViewCell, didChangeTodoItem: TodoItem) {
        let request = TodoAppApi.updateTodoItem(todoItem: didChangeTodoItem)
        apiClient.send(request: request) { result in
            switch result {
            case let .success(response):
                print("TodoItem更新成功 response: \(response)")
                DispatchQueue.main.async {
                    self.fetchTodoItems()
                }
            case let .failure(error):
                DispatchQueue.main.async {
                    self.present(self.apiClient.errorAlert(with: error.message), animated: true, completion: nil)
                }
            }
        }
    }
}
