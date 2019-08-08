//
//  AddTodoLayout.swift
//  RxTableView
//
//  Created by Milkyo on 05/08/2019.
//  Copyright © 2019 MilKyo. All rights reserved.
//

import UIKit

/// AddToDo 뷰를 그려준다
class DetailToDoLayout: UIView {
    let toDoTitleTextFiled: UITextField = {
        let toDotitleTextField = UITextField()
        toDotitleTextField.placeholder = "Input Ttile"
        toDotitleTextField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10.0, height: 2.0))
        toDotitleTextField.leftViewMode = .always
        toDotitleTextField.borderStyle = UITextField.BorderStyle.roundedRect
        return toDotitleTextField
    }()

    let addDateButton: UIButton = {
        let addDateButton = UIButton()
        addDateButton.setTitleColor(UIColor(named: "AzureRadiance"), for: .normal)
        addDateButton.setTitle("날짜 지정", for: .normal)
        addDateButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        return addDateButton
    }()

    func makeToDoTitleTextFieldConstraint() {
        self.toDoTitleTextFiled.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toDoTitleTextFiled.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            toDoTitleTextFiled.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            toDoTitleTextFiled.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            toDoTitleTextFiled.heightAnchor.constraint(equalToConstant: 40),
        ])
    }

    func makeAddDateButtonConstraint() {
        self.addDateButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addDateButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            addDateButton.topAnchor.constraint(equalTo: toDoTitleTextFiled.bottomAnchor, constant: 30),
            addDateButton.heightAnchor.constraint(equalToConstant: 20),
        ])
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(self.toDoTitleTextFiled)
        addSubview(self.addDateButton)
        self.makeToDoTitleTextFieldConstraint()
        self.makeAddDateButtonConstraint()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
