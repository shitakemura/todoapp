//
//  TodoItem.swift
//  TodoApp
//
//  Created by Shintaro Takemura on 2018/10/25.
//  Copyright © 2018 Shintaro Takemura. All rights reserved.
//

import Foundation

class TodoItem: Codable {
    private(set) var id: Int?
    private(set) var title: String
    
    init(title: String) {
        self.title = title
    }
    
    func set(title: String) {
        self.title = title
    }
}
