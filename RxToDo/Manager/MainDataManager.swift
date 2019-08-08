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
    var toDoData = BehaviorRelay<[SectionOfToDoData]>(value: [])

    var toDo = [ToDoData]() {
        didSet(oldValue) {
            if oldValue != self.toDo {
                self.toDoData.accept([SectionOfToDoData(items: self.toDo)])
            }
        }
    }

    /**
     새로운 ToDo를 만들때 ID를 생성한다.

     ## ID값을 생성하는 방법
     저장된 ToDoData를 sort해서 마지막 값이 가진 ID값에 +1를 한다.

     - Returns: 생성된 ID값
     */
    func makeNewID() -> Int {
        let sortToDO = self.toDo.sorted { (lhs, rhs) -> Bool in
            lhs.id < rhs.id
        }

        if let lastID = sortToDO.last?.id {
            return lastID + 1
        }

        return 0
    }

    private init() {}
}
