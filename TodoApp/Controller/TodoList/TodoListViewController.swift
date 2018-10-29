//
//  TodoListViewController.swift
//  TodoApp
//
//  Created by Shintaro Takemura on 2018/10/24.
//  Copyright © 2018 Shintaro Takemura. All rights reserved.
//

import UIKit

final class TodoListViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var addTodoButton: UIButton!
    
    private let apiClient: TodoAppApiClient
    private(set) var todos: [Todo]
    
    init(apiClient: TodoAppApiClient, todos: [Todo]) {
        self.apiClient = apiClient
        self.todos = todos
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
        fetchTodos()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.isEditing = editing
    }
}

// MARK: - Private method
extension TodoListViewController {
    private func setupNavigation() {
        title = "Todo一覧"
        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "全削除", style: .plain, target: self, action: #selector(didTapClearTodos))
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 70
        tableView.register(cellType: TodoTableViewCell.self)
    }
    
    private func setupButton() {
        addTodoButton.layer.borderWidth = 1.0
        addTodoButton.layer.borderColor = UIColor.blue.cgColor
        addTodoButton.layer.masksToBounds = true
        addTodoButton.layer.cornerRadius = addTodoButton.frame.width * 0.5
        addTodoButton.addTarget(self, action: #selector(didTapAddTodo), for: .touchUpInside)
    }
    
    private func fetchTodos() {
        // 全Todo取得リクエスト送信
        let request = TodoAppApi.fetchTodos()
        apiClient.send(request: request) { result in
            switch result {
            case let .success(response):
                print("全Todo取得処理： 成功")
                self.todos = response
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
extension TodoListViewController {
    @objc private func didTapAddTodo(_ sender: UIButton) {
        let addTodoViewController = AddTodoViewController(apiClient: apiClient)
        present(addTodoViewController, animated: true) {
            // tableViewが編集モードになっている場合は、画面遷移した後に通常モードに戻しておく
            if self.tableView.isEditing {
                self.setEditing(false, animated: false)
            }
        }
    }
    
    @objc private func didTapClearTodos(_ sender: UIButton) {
        if todos.isEmpty { return }
        
        // Todo削除確認アラートOK押下時: 全Todo削除リクエスト送信
        let clearTodos: ((UIAlertAction) -> Void)? = { _ in
            let request = TodoAppApi.clearTodos()
            self.apiClient.send(request: request) { result in
                switch result {
                case let .success(response):
                    print("全Todo削除成功 response: \(response)")
                    DispatchQueue.main.async {
                        self.fetchTodos()
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
                .addAction(title: "OK", style: .default, handler: clearTodos)
                .addAction(title: "キャンセル", style: .cancel, handler: nil)
            return alertController
        }()
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDelegate
extension TodoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let todo = todos[indexPath.row]
        let editTodoViewController = EditTodoViewController(apiClient: apiClient, todo: todo)
        navigationController?.pushViewController(editTodoViewController, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension TodoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(with: TodoTableViewCell.self, for: indexPath) else { return UITableViewCell() }
        
        let todo = todos[indexPath.row]
        cell.bind(todo: todo)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle != .delete { return }
        
        // 編集モードで削除ボタン押下時: Todo削除リクエスト送信
        let request = TodoAppApi.deleteTodo(todo: todos[indexPath.row])
        apiClient.send(request: request) { result in
            switch result {
            case let .success(response):
                print("Todo削除成功 response: \(response)")
                DispatchQueue.main.async {
                    self.fetchTodos()
                }
            case let .failure(error):
                DispatchQueue.main.async {
                    self.present(self.apiClient.errorAlert(with: error.message), animated: true, completion: nil)
                }
            }
        }
    }
}

// MARK: - TodoTableViewCellDelegate
extension TodoListViewController: TodoTableViewCellDelegate {
    // TableViewCell.todo変更時: Todo更新リクエスト送信
    func todoTableViewCell(_ todoTableViewCell: TodoTableViewCell, didChangeTodo: Todo) {
        let request = TodoAppApi.updateTodo(todo: didChangeTodo)
        apiClient.send(request: request) { result in
            switch result {
            case let .success(response):
                print("Todo更新成功 response: \(response)")
                DispatchQueue.main.async {
                    self.fetchTodos()
                }
            case let .failure(error):
                DispatchQueue.main.async {
                    self.present(self.apiClient.errorAlert(with: error.message), animated: true, completion: nil)
                }
            }
        }
    }
}
