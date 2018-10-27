//
//  TodoItemListViewController.swift
//  TodoApp
//
//  Created by Shintaro Takemura on 2018/10/24.
//  Copyright © 2018 Shintaro Takemura. All rights reserved.
//

import UIKit

class TodoItemListViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var addTodoButton: UIButton!
    
    private let client: TodoItemListApiClientProtocol
    private(set) var todoItems: [TodoItem]
    
    init(client: TodoItemListApiClientProtocol, todoItems: [TodoItem]) {
        self.client = client
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
}

extension TodoItemListViewController {
    private func setupNavigation() {
        title = "Todo一覧"
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
        addTodoButton.layer.borderColor = UIColor.black.cgColor
        addTodoButton.layer.masksToBounds = true
        addTodoButton.layer.cornerRadius = addTodoButton.frame.width * 0.5
        addTodoButton.addTarget(self, action: #selector(didTapAddTodo), for: .touchUpInside)
    }
    
    private func fetchTodoItems() {
        client.fetch { [weak self] (todoItemList) in
            guard let todoItemList = todoItemList else { return }
            self?.todoItems = todoItemList
            self?.tableView.reloadData()
        }
    }
}

extension TodoItemListViewController {
    @objc private func didTapAddTodo(_ sender: UIButton) {
        let client = AddTodoItemApiClient()
        let addTodoItemViewController = AddTodoItemViewController(client: client)
        present(addTodoItemViewController, animated: true, completion: nil)
    }
    
    @objc private func didTapClearTodos(_ sender: UIButton) {
        if todoItems.isEmpty { return }
        let alertController: UIAlertController = {
            let alertController = UIAlertController(title: "全てのTodoを削除します", message: "よろしいですか？", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                self.client.clear {
                    self.fetchTodoItems()
                }
            }
            let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            return alertController
        }()
        present(alertController, animated: true, completion: nil)
    }
}

extension TodoItemListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let client = EditTodoItemApiClient()
        let todoItem = todoItems[indexPath.row]
        let editTodoItemViewController = EditTodoItemViewController(client: client, todoItem: todoItem)
        navigationController?.pushViewController(editTodoItemViewController, animated: true)
    }
}

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
}


extension TodoItemListViewController: TodoItemTableViewCellDelegate {
    func todoItemTableViewCell(_ todoItemTableViewCell: TodoItemTableViewCell, didChangeTodoItem: TodoItem) {
        client.update(todoItem: didChangeTodoItem) { [weak self] (todoItemList) in
            self?.fetchTodoItems()
        }
    }
}
