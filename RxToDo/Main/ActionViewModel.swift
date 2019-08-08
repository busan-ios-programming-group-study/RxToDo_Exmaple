//
//  ActionViewModel.swift
//  RxTableView
//
//  Created by Milkyo on 06/08/2019.
//  Copyright © 2019 MilKyo. All rights reserved.
//

import CoreData
import Foundation
import RxCocoa
import RxSwift

class ActionViewModel {
    var mainData = MainDataManager.sharedMainData
    var coreData = CoreDataManager.sharedCoreData
    var disposebag = DisposeBag()
    var actionEvent = PublishSubject<ActionList>()

    func linkAction(action: ActionList) {
        switch action {
        case let .deleteItem(index):
            self.removeItem(index)
        case let .moveItem((sourceIndex, destinationIndex)):
            self.moveItem(sourceIndex, destinationIndex)
        case let .checkItem(index):
            self.checkItem(index)
        }
    }

    func checkItem(_ index: Int) {
        self.mainData.toDo[index].isCheck = !self.mainData.toDo[index].isCheck
        self.coreData.chagneCheckData(index)
    }

    func removeItem(_ indexPath: IndexPath) {
        let removeIndex = self.mainData.toDo[indexPath.row].id
        self.mainData.toDo.remove(at: indexPath.row)
        self.coreData.removeData(removeIndex)
    }

    func moveItem(_ sourceIndexPath: IndexPath, _ destinationIndexPath: IndexPath) {
        let targetData = self.mainData.toDo[sourceIndexPath.row]
        self.mainData.toDo.remove(at: sourceIndexPath.row)
        self.mainData.toDo.insert(targetData, at: destinationIndexPath.row)
        self.coreData.saveAllData()
    }

    init() {
        self.actionEvent
            .bind(onNext: self.linkAction)
            .disposed(by: self.disposebag)
    }
}
