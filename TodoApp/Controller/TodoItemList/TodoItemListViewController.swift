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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchTodoItems()
    }
}

extension TodoItemListViewController {
    private func setupNavigation() {
        title = "TodoI一覧"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(didTapAddTodo))
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 80
        tableView.register(cellType: TodoItemTableViewCell.self)
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
    @objc private func didTapAddTodo(_sender: UIBarButtonItem) {
        let client = AddTodoItemApiClient()
        let addTodoItemViewController = AddTodoItemViewController(client: client)
        present(addTodoItemViewController, animated: true, completion: nil)
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
        print("id: \(todoItem.id)  title: \(todoItem.title)")
        cell.bind(todoItem: todoItem)
        return cell
    }
}
