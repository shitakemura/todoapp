//
//  EditTodoItemApiClient.swift
//  TodoApp
//
//  Created by Shintaro Takemura on 2018/10/26.
//  Copyright © 2018 Shintaro Takemura. All rights reserved.
//

import Foundation

protocol EditTodoItemApiClientProtocol {
    func update(todoItem: TodoItem, completion: @escaping (([TodoItem]?) -> Void))
    func delete(todoItem: TodoItem, completion: @escaping (() -> Void))
}

struct EditTodoItemApiClient: EditTodoItemApiClientProtocol {
    func update(todoItem: TodoItem, completion: @escaping (([TodoItem]?) -> Void)) {
        guard let id = todoItem.id else { return }
        guard let url = URL(string: "http://localhost:8080/todos/\(id)") else { return }
        print("url: \(url)")
        
        let urlRequst: URLRequest = {
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try? JSONEncoder().encode(todoItem)
            return request
        }()
        
        URLSession.shared.dataTask(with: urlRequst) { (data, response, error) in
            guard let data = data else { return }
            let todoItemList = try? JSONDecoder().decode([TodoItem].self, from: data)
            DispatchQueue.main.async {
                completion(todoItemList)
            }
        }.resume()
    }
    
    func delete(todoItem: TodoItem, completion: @escaping (() -> Void)) {
        guard let id = todoItem.id else { return }
        guard let url = URL(string: "http://localhost:8080/todos/\(id)") else { return }
        print("url: \(url)")
        
        let urlRequest: URLRequest = {
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            return request
        }()
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard let response = response else { return }
            print("response: \(response)")
            
            DispatchQueue.main.async {
                completion()
            }
        }.resume()
    }
}
