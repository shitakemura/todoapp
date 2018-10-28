//
//  TodoAppApi.swift
//  TodoApp
//
//  Created by Shintaro Takemura on 2018/10/28.
//  Copyright © 2018 Shintaro Takemura. All rights reserved.
//

import Foundation

final class TodoAppApi {
    // Todo一覧取得
    struct fetchTodoItems: TodoAppApiRequest {
        typealias Response = [TodoItem]

        var method: HTTPMethod {
            return .get
        }
        
        var path: String {
            return ""
        }
        
        var hasRequestBody: Bool {
            return false
        }
        
        var requestBody: Data? {
            return nil
        }
    }
    
    // Todo追加
    struct addTodoItem: TodoAppApiRequest {
        typealias Response = TodoItem
        let todoItem: TodoItem
        
        var method: HTTPMethod {
            return .post
        }
        
        var path: String {
            return ""
        }
        
        var hasRequestBody: Bool {
            return true
        }
        
        var requestBody: Data? {
            return try? JSONEncoder().encode(todoItem)
        }
    }
    
    // Todo更新
    struct updateTodoItem: TodoAppApiRequest {
        typealias Response = TodoItem
        let todoItem: TodoItem
        
        var method: HTTPMethod {
            return .put
        }

        var path: String {
            guard let id = todoItem.id else { return "" }
            return "/\(id)"
        }
        
        var hasRequestBody: Bool {
            return true
        }
        
        var requestBody: Data? {
            return try? JSONEncoder().encode(todoItem)

        }
    }
    
    // Todo削除
    struct deleteTodoItem: TodoAppApiRequest {
        typealias Response = EmptyData
        let todoItem: TodoItem

        var method: HTTPMethod {
            return .delete
        }
        
        var path: String {
            guard let id = todoItem.id else { return "" }
            return "/\(id)"
        }
        
        var hasRequestBody: Bool {
            return false
        }
        
        var requestBody: Data? {
            return nil
        }
    }
    
    // Todo全削除
    struct clearTodoItems: TodoAppApiRequest {
        typealias Response = EmptyData
        
        var method: HTTPMethod {
            return .delete
        }
        
        var path: String {
            return ""
        }
        
        var hasRequestBody: Bool {
            return false
        }
        
        var requestBody: Data? {
            return nil
        }        
    }
}


