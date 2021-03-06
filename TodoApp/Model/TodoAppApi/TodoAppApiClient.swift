//
//  TodoAppApiClient.swift
//  TodoApp
//
//  Created by Shintaro Takemura on 2018/10/28.
//  Copyright © 2018 Shintaro Takemura. All rights reserved.
//

import UIKit
import SVProgressHUD

final class TodoAppApiClient {
    private let session: URLSession = {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        return session
    }()
    
    func send<Request : TodoAppApiRequest>(
        request: Request,
        completion: @escaping (Result<Request.Response, TodoAppApiClientError>) -> Void) {
        
        let urlRequest = request.buildURLRequest()
        
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
        
        let task = session.dataTask(with: urlRequest) { data, response, error in
            switch (data, response, error) {
            case (_, _, let error?):
                completion(Result(error: .connectionError(error)))
                
            case (let data?, let response?, _):
                do {
                    let response = try request.response(from: data, urlResponse: response)
                    completion(Result(value: response))
                } catch let error as TodoAppApiError {
                    completion(Result(error: .apiError(error)))
                } catch {
                    completion(Result(error: .responseParseError(error)))
                }
                
            default:
                fatalError("invalid response combination \(String(describing: data)), \(String(describing: response)), \(String(describing: error)).")
            }
            
            SVProgressHUD.dismiss()
        }
        task.resume()
    }
    
    func errorAlert(with title: String) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: "", preferredStyle: .alert).addAction(title: "OK", style: .default, handler: nil)
        return alertController
    }
}
