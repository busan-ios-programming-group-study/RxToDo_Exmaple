//
//  MemoData.swift
//  RxTableView
//
//  Created by Milkyo on 05/08/2019.
//  Copyright © 2019 MilKyo. All rights reserved.
//

import Foundation

struct ToDoData: Equatable {
    var id: Int
    var title: String
    var date: String
    var isCheck: Bool

    init(id: Int, title: String, date: String, isCheck: Bool = false) {
        self.id = id
        self.title = title
        self.date = date
        self.isCheck = isCheck
    }

    public static func == (lhs: ToDoData, rhs: ToDoData) -> Bool {
        return lhs.id == rhs.id && lhs.title == rhs.title && lhs.date == rhs.date
    }
}
