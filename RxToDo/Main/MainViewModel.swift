//
//  MainViewModel.swift
//  RxTableView
//
//  Created by Milkyo on 29/07/2019.
//  Copyright © 2019 MilKyo. All rights reserved.
//

import CoreData
import Foundation

class MainViewModel: SendDataDelegate {
    var mainData = MainDataManager.sharedMainData
    var coreData = CoreDataManager.sharedCoreData

    func sendNewData(_ data: ToDoData) {
        self.mainData.memo.append(data)
    }

    init() {
        if let loadToDoData = coreData.loadSaveData() {
            self.mainData.memo = loadToDoData
        }
    }
}
