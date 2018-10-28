//
//  TodoAppApiError.swift
//  TodoApp
//
//  Created by Shintaro Takemura on 2018/10/28.
//  Copyright © 2018 Shintaro Takemura. All rights reserved.
//

struct TodoAppApiError : Decodable, Error {
    struct FieldError : Decodable {
        let resource: String
        let field: String
        let code: String
    }
    
    let message: String
    let fieldErrors: [FieldError]
}
