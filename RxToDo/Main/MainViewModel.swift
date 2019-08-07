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

    func complete() {
        if let newData = self.coreData.loadSaveData() {
            self.mainData.memo = newData
        }
    }

    init() {
        if let loadToDoData = coreData.loadSaveData() {
            self.mainData.memo = loadToDoData
        }
    }
}
