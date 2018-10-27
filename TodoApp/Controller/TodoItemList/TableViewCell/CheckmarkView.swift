//
//  CheckmarkView.swift
//  TodoApp
//
//  Created by Shintaro Takemura on 2018/10/28.
//  Copyright © 2018 Shintaro Takemura. All rights reserved.
//

import UIKit

protocol CheckmarkViewDelegate: class {
    func checkmarkView(_ checkmarkView: CheckmarkView, didChecked: Bool)
}

class CheckmarkView: UIView {
    @IBOutlet private weak var checkmarkLabel: UILabel!
    
    private(set) var isChecked = false
    weak var delegate: CheckmarkViewDelegate?
    
    override init(frame: CGRect){
        super.init(frame: frame)
        loadNib()
        setupLabel()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        loadNib()
        setupLabel()
    }
    
    func loadNib(){
        let view = Bundle.main.loadNibNamed(CheckmarkView.className, owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    private func setupLabel() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapCheckmark))
        checkmarkLabel.isUserInteractionEnabled = true
        checkmarkLabel.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func didTapCheckmark(_ sender: UITapGestureRecognizer) {
        isChecked.toggle()
        set(checkmark: isChecked)
        delegate?.checkmarkView(self, didChecked: isChecked)
    }
}

extension CheckmarkView {    
    func set(checkmark isChecked: Bool) {
        self.isChecked = isChecked
        checkmarkLabel.text = {
            if isChecked {
                return "☑︎"
            } else {
                return "□"
            }
        }()
    }
}
