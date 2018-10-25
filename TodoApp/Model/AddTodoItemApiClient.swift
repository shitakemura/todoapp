//
//  AddTodoItemApiClient.swift
//  TodoApp
//
//  Created by Shintaro Takemura on 2018/10/25.
//  Copyright © 2018 Shintaro Takemura. All rights reserved.
//

import Foundation

protocol AddTodoItemApiClientProtocol {
    func add(todoItem: TodoItem, completion: @escaping (([TodoItem]?) -> Void))
}

struct AddTodoItemApiClient: AddTodoItemApiClientProtocol {
    func add(todoItem: TodoItem, completion: @escaping (([TodoItem]?) -> Void)) {
        guard let url = URL(string: "http://localhost:8080/todos") else { return }
        
        let urlRequest: URLRequest = {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try? JSONEncoder().encode(todoItem)
            return request
        }()
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard let data = data else { return }            
            let todoItemList = try? JSONDecoder().decode([TodoItem].self, from: data)
            DispatchQueue.main.async {
                completion(todoItemList)
            }
        }.resume()
    }
}
