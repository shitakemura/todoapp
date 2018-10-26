//
//  TodoItem.swift
//  TodoApp
//
//  Created by Shintaro Takemura on 2018/10/25.
//  Copyright © 2018 Shintaro Takemura. All rights reserved.
//

import Foundation

class TodoItem: Codable {
    var id: Int?
    let title: String
    
    init(title: String) {
        self.title = title
    }
}
