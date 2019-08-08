//
//  Delegate.swift
//  RxTableView
//
//  Created by Milkyo on 06/08/2019.
//  Copyright © 2019 MilKyo. All rights reserved.
//

import Foundation

/**
 특정 동작이 완료되었을 특정 동작을 수행

 ## 예시
 새로운 ToDo를 생성하고 뷰가 닫힐 때 메인뷰에서 새로 추가된 데이터 추가

 */
protocol CompleteDelegate {
    func complete()
}
