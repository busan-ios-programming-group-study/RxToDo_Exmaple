//
//  AddToDoViewModel.swift
//  RxTableView
//
//  Created by Milkyo on 05/08/2019.
//  Copyright © 2019 MilKyo. All rights reserved.
//

import CoreData
import Foundation
import RxCocoa
import RxSwift

class AddToDoViewModel {
    var disposeBag = DisposeBag()
    var currentDataID = 0
    var newToDoData: ToDoData?
    var delegate: CompleteDelegate?
    var textFieldData = PublishSubject<String>()
    var isEmptyTextField = BehaviorSubject<Bool>(value: false)
    var todoDateData = BehaviorSubject<String>(value: "날짜 지정")
    let coreData = CoreDataManager.sharedCoreData
    let dataManager = MainDataManager.sharedMainData

    /// 새로운 데이터를 저장하고 Delegate에 완료되었다고 전달
    func sendSaveData() {
        if let sendData = newToDoData {
            if !self.dataManager.toDo.contains(sendData) {
                self.coreData.saveData(newToDoData: sendData)
                self.delegate?.complete()
            }
        }
    }

    /// TextField와 Date에 새로운 데이터가 들어올 때마다 ToDoData를 생성한다.
    func combineData() {
        Observable.combineLatest(self.textFieldData,
                                 self.todoDateData,
                                 resultSelector: { str1, str2 in ToDoData(id: self.currentDataID, title: str1, date: str2) })
            .bind(onNext: { [weak self] in self?.newToDoData = $0 })
            .disposed(by: self.disposeBag)
    }

    /**
     testField에 새로운 데이터가 들어오면 isEmptyTextField를 변환한다.

      ## isEmptyTextField
      testField가 비어있는지 아닌지 나타내는 Bool Type 변수

     */
    func bindTextField() {
        self.textFieldData
            .map { $0.trimmingCharacters(in: .whitespaces) != "" }
            .bind(to: self.isEmptyTextField)
            .disposed(by: self.disposeBag)
    }

    init() {
        self.bindTextField()
        self.combineData()
    }

    deinit {
        self.disposeBag = DisposeBag()
    }
}
