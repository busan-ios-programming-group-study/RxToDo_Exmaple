//
//  ActionList.swift
//  RxTableView
//
//  Created by Milkyo on 05/08/2019.
//  Copyright © 2019 MilKyo. All rights reserved.
//

import Foundation

enum ActionList: Equatable {
    static func == (lhs: ActionList, rhs: ActionList) -> Bool {
        switch (lhs, rhs) {
        case (.checkItem, .checkItem):
            return true
        case (.moveItem, .moveItem):
            return true
        case (.deleteItem, .deleteItem):
            return true
        default:
            return false
        }
    }

    case checkItem(_ index: Int)
    case moveItem((indexList: IndexPath, destinationIndex: IndexPath))
    case deleteItem(_ index: IndexPath)
}
