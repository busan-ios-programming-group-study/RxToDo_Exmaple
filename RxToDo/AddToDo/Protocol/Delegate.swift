//
//  Delegate.swift
//  RxTableView
//
//  Created by Milkyo on 06/08/2019.
//  Copyright © 2019 MilKyo. All rights reserved.
//

import Foundation

/// 추가할 데이터를 넘겨주는 프로토콜
protocol SendDataDelegate {
    /// 추가할 데이터를 넘겨준다
    ///
    /// - Parameter data: 추가될 ToDo List
    func complete()
}
