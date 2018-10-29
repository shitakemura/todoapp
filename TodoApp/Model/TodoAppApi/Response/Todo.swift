//
//  Todo.swift
//  TodoApp
//
//  Created by Shintaro Takemura on 2018/10/25.
//  Copyright © 2018 Shintaro Takemura. All rights reserved.
//

final class Todo: Codable {
    private(set) var id: Int?
    private(set) var taskName: String
    private(set) var isDone = false
    
    init(taskName: String) {
        self.taskName = taskName
    }
    
    func set(taskName: String) {
        self.taskName = taskName
    }
    
    func set(isDone: Bool) {
        self.isDone = isDone
    }
}
