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
        self.mainData.memoData.accept([SectionOfMemoData(items: mainData.memo)])
    }

    func checkItem(_ index: Int) {
        self.mainData.memo[index - 1].isCheck = !self.mainData.memo[index - 1].isCheck
        self.coreData.chagneData(index)
    }

    func removeItem(_ indexPath: IndexPath) {
        let removeIndex = self.mainData.memo[indexPath.row].id
        self.mainData.memo.remove(at: indexPath.row)
        self.coreData.removeData(removeIndex)
    }

    func moveItem(_ sourceIndexPath: IndexPath, _ destinationIndexPath: IndexPath) {
        let targetData = self.mainData.memo[sourceIndexPath.row]
        self.mainData.memo.remove(at: sourceIndexPath.row)
        self.mainData.memo.insert(targetData, at: destinationIndexPath.row)
    }

    init() {
        self.actionEvent
            .bind(onNext: self.linkAction)
            .disposed(by: self.disposebag)
    }
}
