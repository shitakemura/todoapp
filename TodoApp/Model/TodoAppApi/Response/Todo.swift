//
//  Todo.swift
//  TodoApp
//
//  Created by Shintaro Takemura on 2018/10/25.
//  Copyright © 2018 Shintaro Takemura. All rights reserved.
//

final class Todo: Codable {
    private(set) var id: Int?
    private(set) var title: String
    private(set) var isDone = false
    
    init(title: String) {
        self.title = title
    }
    
    func set(title: String) {
        self.title = title
    }
    
    func set(isDone: Bool) {
        self.isDone = isDone
    }
}
