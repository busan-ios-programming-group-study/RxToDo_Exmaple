//
//  ActionList.swift
//  RxTableView
//
//  Created by Milkyo on 05/08/2019.
//  Copyright © 2019 MilKyo. All rights reserved.
//

import Foundation

/**
 TableView에서 발생할 수 있는 액션

 - checkItem: 체크하는 액션
 - moveItem: 순서를 재배열하는 액션
 - deleteItem: 셀 아이템을 삭제하는 액션
 */
enum ActionList {
    case checkItem(_ index: Int)
    case moveItem((indexList: IndexPath, destinationIndex: IndexPath))
    case deleteItem(_ index: IndexPath)
}
