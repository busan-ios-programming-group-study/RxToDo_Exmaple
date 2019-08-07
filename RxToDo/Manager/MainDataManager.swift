//
//  Data.swift
//  RxTableView
//
//  Created by Milkyo on 06/08/2019.
//  Copyright © 2019 MilKyo. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

final class MainDataManager {
    static let sharedMainData = MainDataManager()
    var memoData = BehaviorRelay<[SectionOfMemoData]>(value: [])

    var memo = [ToDoData]() {
        didSet(oldValue) {
            if oldValue != self.memo {
                self.memoData.accept([SectionOfMemoData(items: self.memo)])
            }
        }
    }

    func makeNewID() -> Int {
        let sortMemo = self.memo.sorted { (lhs, rhs) -> Bool in
            lhs.id < rhs.id
        }

        if let lastID = sortMemo.last?.id {
            return lastID + 1
        }

        return 0
    }

    private init() {}
}
