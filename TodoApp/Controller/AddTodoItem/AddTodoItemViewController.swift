//
//  AddTodoItemViewController.swift
//  TodoApp
//
//  Created by Shintaro Takemura on 2018/10/24.
//  Copyright © 2018 Shintaro Takemura. All rights reserved.
//

import UIKit

class AddTodoItemViewController: UIViewController {

    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var addTodoItemButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
    }
}

extension AddTodoItemViewController {
    private func setupButton() {
        closeButton.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
        addTodoItemButton.addTarget(self, action: #selector(didTapAddItem), for: .touchUpInside)
    }
}

extension AddTodoItemViewController {
    @objc private func didTapClose(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapAddItem(_ sender: UIButton) {
        print("追加ボタンタップ")
    }
}
