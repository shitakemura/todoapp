//
//  TodoListViewControllerTests.swift
//  TodoAppTests
//
//  Created by Shintaro Takemura on 2018/11/02.
//  Copyright © 2018 Shintaro Takemura. All rights reserved.
//

import XCTest
@testable import TodoApp

class TodoListViewControllerTests: XCTestCase {

    var viewController: TodoListViewController!
    
    override func setUp() {
        let todos = [Todo(taskName: "Todoタスク１"), Todo(taskName: "Todoタスク２")]
        let apiClient = TodoAppApiClient()
        viewController = TodoListViewController(apiClient: apiClient, todos: todos)
    }

    func test_ナビゲーションバーにタイトルが表示されていること() {
        let window = UIWindow()
        window.rootViewController = viewController
        window.makeKeyAndVisible()

        XCTAssertEqual(viewController.title, "Todo一覧")
    }

    func test_Todoタスクの一覧が表示されていること() {
        let window = UIWindow()
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        
        guard let cell = viewController.tableView.dataSource?.tableView(viewController.tableView, cellForRowAt: IndexPath(row: 1, section: 0)) as? TodoTableViewCell else {
            XCTFail()
            return
        }
        XCTAssertEqual(cell.taskNameLabel.text, "Todoタスク２")
    }
}
