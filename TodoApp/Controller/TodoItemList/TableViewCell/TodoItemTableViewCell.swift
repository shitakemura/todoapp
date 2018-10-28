//
//  TodoItemTableViewCell.swift
//  TodoApp
//
//  Created by Shintaro Takemura on 2018/10/24.
//  Copyright © 2018 Shintaro Takemura. All rights reserved.
//

import UIKit

protocol TodoItemTableViewCellDelegate: class {
    func todoItemTableViewCell(_ todoItemTableViewCell: TodoItemTableViewCell, didChangeTodoItem: TodoItem)
}

final class TodoItemTableViewCell: UITableViewCell {
    @IBOutlet private weak var checkmarkView: CheckmarkView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    weak var delegate: TodoItemTableViewCellDelegate?
    private(set) var todoItem: TodoItem?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }    
}

// MARK: - Internal function
extension TodoItemTableViewCell {
    func bind(todoItem: TodoItem) {
        self.todoItem = todoItem
        titleLabel.text = todoItem.title
        checkmarkView.set(checkmark: todoItem.isDone)
        checkmarkView.delegate = self
    }
}

// MARK: - CheckmarkViewDelegate
extension TodoItemTableViewCell: CheckmarkViewDelegate {
    // CheckmarkViewのチェックマーク更新: todoItemを更新し、TodoItemListViewControllerに通知
    func checkmarkView(_ checkmarkView: CheckmarkView, didChecked: Bool) {
        todoItem?.set(isDone: didChecked)
        guard let todoItem = todoItem else { return }
        delegate?.todoItemTableViewCell(self, didChangeTodoItem: todoItem)
    }
}
