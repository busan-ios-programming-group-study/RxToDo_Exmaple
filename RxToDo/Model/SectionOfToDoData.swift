//
//  SectionOfToDoData.swift
//  RxTableView
//
//  Created by Milkyo on 05/08/2019.
//  Copyright © 2019 MilKyo. All rights reserved.
//

import Foundation
import RxDataSources

struct SectionOfToDoData {
    var items: [Item]
}

extension SectionOfToDoData: SectionModelType {
    typealias Item = ToDoData

    init(original: SectionOfToDoData, items: [Item]) {
        self = original
        self.items = items
    }
}
