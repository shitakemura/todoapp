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
    struct fetchTodos: TodoAppApiRequest {
        typealias Response = [Todo]

        var method: HTTPMethod {
            return .get
        }
        
        var path: String {
            return "/todos"
        }
        
        var requestBody: Data? {
            return nil
        }
    }
    
    // Todo追加
    struct addTodo: TodoAppApiRequest {
        typealias Response = Todo
        let todo: Todo
        
        var method: HTTPMethod {
            return .post
        }
        
        var path: String {
            return "/todos"
        }
        
        var requestBody: Data? {
            return try? JSONEncoder().encode(todo)
        }
    }
    
    // Todo更新
    struct updateTodo: TodoAppApiRequest {
        typealias Response = Todo
        let todo: Todo
        
        var method: HTTPMethod {
            return .put
        }

        var path: String {
            guard let id = todo.id else { return "" }
            return "/todos/\(id)"
        }
        
        var requestBody: Data? {
            return try? JSONEncoder().encode(todo)
        }
    }
    
    // Todo削除
    struct deleteTodo: TodoAppApiRequest {
        typealias Response = EmptyData
        let todo: Todo

        var method: HTTPMethod {
            return .delete
        }
        
        var path: String {
            guard let id = todo.id else { return "" }
            return "/todos/\(id)"
        }
        
        var requestBody: Data? {
            return nil
        }
    }
    
    // Todo全削除
    struct clearTodos: TodoAppApiRequest {
        typealias Response = EmptyData
        
        var method: HTTPMethod {
            return .delete
        }
        
        var path: String {
            return "/todos"
        }
        
        var requestBody: Data? {
            return nil
        }        
    }
}


