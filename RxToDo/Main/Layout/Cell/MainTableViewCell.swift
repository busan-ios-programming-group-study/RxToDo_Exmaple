//
//  MainTableViewCell.swift
//  RxTableView
//
//  Created by Milkyo on 29/07/2019.
//  Copyright © 2019 MilKyo. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class MainCell: UITableViewCell {
    var dispoaseBag = DisposeBag()

    let checkButton: UIButton = {
        let checkButton = UIButton()
        checkButton.layer.borderWidth = 1.0
        checkButton.layer.borderColor = UIColor.black.cgColor
        checkButton.layer.cornerRadius = 15
        return checkButton
    }()

    let mainTitleLabel: UILabel = {
        let mainTitleLabel = UILabel()
        mainTitleLabel.textColor = .black
        mainTitleLabel.font = UIFont.systemFont(ofSize: 16)
        return mainTitleLabel
    }()

    func makeCheckButtonConstraint() {
        self.checkButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            checkButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            checkButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            checkButton.heightAnchor.constraint(equalToConstant: 30),
        ])
    }

    func makeMainTitleLabelConstraint() {
        self.mainTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainTitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            mainTitleLabel.leadingAnchor.constraint(equalTo: checkButton.trailingAnchor, constant: 10),
            mainTitleLabel.heightAnchor.constraint(equalToConstant: 20),
        ])
    }

    func bindCellUI() {
        self.checkButton.rx.tap.asDriver()
            .do(onNext: { _ in
                if self.checkButton.backgroundColor == UIColor(named: "AzureRadiance") {
                    self.checkButton.backgroundColor = .white
                } else {
                    self.checkButton.backgroundColor = UIColor(named: "AzureRadiance")
                }
            })
            .drive(onNext: self.check)
            .disposed(by: self.dispoaseBag)
    }

    func check() {
        let actionVieModel = ActionViewModel()
        actionVieModel.actionEvent.onNext(.checkItem(self.checkButton.tag))
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.heightAnchor.constraint(equalToConstant: 45)
        contentView.addSubview(self.checkButton)
        contentView.addSubview(self.mainTitleLabel)
        self.makeCheckButtonConstraint()
        self.makeMainTitleLabelConstraint()
        self.bindCellUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
