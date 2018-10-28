//
//  TodoAppApiClientError.swift
//  TodoApp
//
//  Created by Shintaro Takemura on 2018/10/28.
//  Copyright © 2018 Shintaro Takemura. All rights reserved.
//

enum TodoAppApiClientError : Error {
    case connectionError(Error)         // 通信失敗
    case responseParseError(Error)      // レスポンスの解釈に失敗
    case apiError(TodoAppApiError)      // APIからエラーレスポンスを受け取った
}
