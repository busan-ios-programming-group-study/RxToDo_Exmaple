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

    var memo = [ToDoData]() {
        didSet {
            self.memoData.accept([SectionOfMemoData(items: self.memo)])
        }
    }

    var memoData = BehaviorRelay<[SectionOfMemoData]>(value: [])

    private init() {}
}
