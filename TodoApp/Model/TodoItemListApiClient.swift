//
//  TodoItemListApiClient.swift
//  TodoApp
//
//  Created by Shintaro Takemura on 2018/10/25.
//  Copyright © 2018 Shintaro Takemura. All rights reserved.
//

import Foundation

protocol TodoItemListApiClientProtocol {
    func fetch(completion: @escaping (([TodoItem]?) -> Void))
}

struct TodoItemListApiClient: TodoItemListApiClientProtocol {
    func fetch(completion: @escaping (([TodoItem]?) -> Void)) {
        guard let url = URL(string: "http://localhost:8080/todos") else { return }
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            let todoItemList = try? JSONDecoder().decode([TodoItem].self, from: data)
            DispatchQueue.main.async {
                completion(todoItemList)
            }
        }.resume()
    }
}
