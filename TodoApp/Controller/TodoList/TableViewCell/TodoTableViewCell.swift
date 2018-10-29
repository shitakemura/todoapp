//
//  TodoTableViewCell.swift
//  TodoApp
//
//  Created by Shintaro Takemura on 2018/10/24.
//  Copyright © 2018 Shintaro Takemura. All rights reserved.
//

import UIKit

protocol TodoTableViewCellDelegate: class {
    func todoTableViewCell(_ todoTableViewCell: TodoTableViewCell, didChangeTodo: Todo)
}

final class TodoTableViewCell: UITableViewCell {
    @IBOutlet private weak var checkmarkView: CheckmarkView!
    @IBOutlet private weak var taskNameLabel: UILabel!
    
    weak var delegate: TodoTableViewCellDelegate?
    private(set) var todo: Todo?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }    
}

// MARK: - Internal function
extension TodoTableViewCell {
    func bind(todo: Todo) {
        self.todo = todo
        taskNameLabel.text = todo.taskName
        checkmarkView.set(checkmark: todo.isDone)
        checkmarkView.delegate = self
    }
}

// MARK: - CheckmarkViewDelegate
extension TodoTableViewCell: CheckmarkViewDelegate {
    // CheckmarkViewのチェックマーク更新: todoを更新し、TodoListViewControllerに通知
    func checkmarkView(_ checkmarkView: CheckmarkView, didChecked: Bool) {
        todo?.set(isDone: didChecked)
        guard let todo = todo else { return }
        delegate?.todoTableViewCell(self, didChangeTodo: todo)
    }
}
