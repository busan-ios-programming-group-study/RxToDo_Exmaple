//
//  AddToDoView.swift
//  RxTableView
//
//  Created by Milkyo on 05/08/2019.
//  Copyright © 2019 MilKyo. All rights reserved.
//

import CoreData
import RxCocoa
import RxSwift
import UIKit

class DetailTodoView: UIViewController {
    var addToDoViewModel = AddToDoViewModel()
    var disposeBag = DisposeBag()

    var addOwnView: DetailToDoLayout {
        return self.view as! DetailToDoLayout
    }

    func dissmissView() {
        self.disposeBag = DisposeBag()
        self.dismiss(animated: true)
    }

    /// TextField의 값이 존재하면 rightBarButtonItem을 바꾼다.
    /// -> TextField의 값이 없으면 rightBarButtonItem을 없애고 있으면 버튼을 표시한다.
    ///
    /// - Parameter isEmptyTextField: TextField가 비어있는 지 아닌 지 넘겨받는 값
    func activateButton(isEmptyTextField: Bool) {
        if isEmptyTextField != true {
            self.navigationItem.rightBarButtonItem = nil
        } else {
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: nil)
            self.navigationItem.rightBarButtonItem = doneButton

            doneButton.rx.tap.asDriver()
                .do(onNext: self.addToDoViewModel.sendSaveData)
                .drive(onNext: self.dissmissView)
                .disposed(by: self.disposeBag)
        }
    }

    /// 기본적인 leftBarButtonItem을 생성한다.
    func bindNavigationButton() {
        let dismissButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: nil)
        self.navigationItem.leftBarButtonItem = dismissButton
        dismissButton.rx.tap.asDriver()
            .drive(onNext: self.dissmissView)
            .disposed(by: self.disposeBag)
    }

    /// toDoTitleTextFiled의 값의 변화에 따라 TextFiled값을 넘겨주거나 TextFiled의 값이 비어있는지 체크한다.
    func bindTextField() {
        self.addOwnView.toDoTitleTextFiled.rx.text.orEmpty
            .bind(to: self.addToDoViewModel.textFieldData)
            .disposed(by: self.disposeBag)

        self.addToDoViewModel.isEmptyTextField
            .bind(onNext: self.activateButton)
            .disposed(by: self.disposeBag)
    }

    /// addDateButton와 액션을 bind한다.
    func bindDateButton() {
        self.addOwnView.addDateButton.rx.tap
            .bind(onNext: self.addDate)
            .disposed(by: self.disposeBag)
    }

    /// ToDo에 날짜를 지정한다.
    func addDate() {
        let alert = DatePickerAlertController(title: "날짜 지정", message: "날짜를 지정해주세요", preferredStyle: .actionSheet)
        let okAction: UIAlertAction = UIAlertAction(title: "확인", style: .default) { [weak self] _ in

            let selectedDate = alert.dateConvertToString()
            self?.addOwnView.addDateButton.setTitle(selectedDate, for: .normal)

            Observable.just(selectedDate)
                .filter { _ in self != nil }
                .bind(to: self!.addToDoViewModel.todoDateData)
                .disposed(by: self!.disposeBag)
        }

        alert.addAction(okAction)

        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(cancelAction)

        self.present(alert, animated: true, completion: nil)
    }

    func inputData() {
        let selectedData = self.addToDoViewModel.dataManager.toDo.filter { $0.id == addToDoViewModel.currentDataID }

        if selectedData.count > 0 {
            self.navigationItem.title = "Modify"
            self.addToDoViewModel.textFieldData.onNext(selectedData.first!.title)
            self.addOwnView.toDoTitleTextFiled.text = selectedData.first?.title
            self.addOwnView.addDateButton.setTitle(selectedData.first?.date, for: .normal)
        }
    }

    override func loadView() {
        let view = DetailToDoLayout()
        self.view = view
    }

    override func viewDidLoad() {
        self.navigationItem.title = "Add"
        self.bindNavigationButton()
        self.bindTextField()
        self.bindDateButton()
        self.inputData()
    }
}
