//
//  TodoAppApiRequest.swift
//  TodoApp
//
//  Created by Shintaro Takemura on 2018/10/28.
//  Copyright © 2018 Shintaro Takemura. All rights reserved.
//

import Foundation

protocol TodoAppApiRequest {
    associatedtype Response: Decodable
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var requestBody: Data? { get }
}

extension TodoAppApiRequest {
    var baseURL: URL {
        #if DEBUG
        return URL(string: "http://localhost:8080/todos")!
        #else
        return URL(string: "https://xxxxxxxx.xxxxx.cloud/todos")!
        #endif
    }
    
    func buildURLRequest() -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        let  components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        let urlRequest: URLRequest = {
            var urlRequest = URLRequest(url: url)
            urlRequest.url = components?.url
            urlRequest.httpMethod = method.rawValue
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = requestBody
            return urlRequest
        }()
        return urlRequest
    }
    
    func response(from data: Data, urlResponse: URLResponse) throws -> Response {
        let decoder = JSONDecoder()
        if case (200..<300)? = (urlResponse as? HTTPURLResponse)?.statusCode {
            // TODO: リファクタ検討
            // DELETEリクエストは、戻りJSONデータが空のため、EmptyDataオブジェクトを返す
            if data.isEmpty { return EmptyData() as! Self.Response }
            return try decoder.decode(Response.self, from: data)
        } else {
            throw try decoder.decode(TodoAppApiError.self, from: data)
        }
    }
}