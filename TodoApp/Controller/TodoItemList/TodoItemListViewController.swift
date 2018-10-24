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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupTableView()
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
}

extension TodoItemListViewController {
    @objc private func didTapAddTodo(_sender: UIBarButtonItem) {
        let addTodoItemViewController = AddTodoItemViewController()
        present(addTodoItemViewController, animated: true, completion: nil)
    }
}

extension TodoItemListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("TableViewCell選択")
    }
}

extension TodoItemListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(with: TodoItemTableViewCell.self, for: indexPath) else { return UITableViewCell() }
        
        return cell
    }
}
