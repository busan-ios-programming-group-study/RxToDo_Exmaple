//
//  CoreDataManager.swift
//  RxTableView
//
//  Created by Milkyo on 06/08/2019.
//  Copyright © 2019 MilKyo. All rights reserved.
//

import CoreData
import Foundation
import UIKit

final class CoreDataManager {
    static let sharedCoreData = CoreDataManager()

    var mainData = MainDataManager.sharedMainData

    lazy var context: NSManagedObjectContext? = {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext

            return context
        }

        return nil
    }()

    func loadSaveData() -> [ToDoData]? {
        var loadMemo = [ToDoData]()

        do {
            guard let context = context else {
                return nil
            }
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ToDo")
            let loadData = try context.fetch(fetchRequest)

            for index in loadData {
                guard let id = index.value(forKey: "id") as? Int else {
                    return nil
                }

                guard let title = index.value(forKey: "title") as? String else {
                    return nil
                }

                guard let date = index.value(forKey: "date") as? String else {
                    return nil
                }

                guard let isCheck = index.value(forKey: "isCheck") as? Bool else {
                    return nil
                }

                loadMemo.append(ToDoData(id: id, title: title, date: date, isCheck: isCheck))
            }

        } catch {
            print(error.localizedDescription)
        }

        return loadMemo
    }

    func chagneCheckData(_ index: Int) {
        guard let context = context else {
            return
        }

        do {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ToDo")
            let toDoData = try context.fetch(fetchRequest)

            for content in toDoData {
                if index == content.value(forKey: "id") as? Int {
                    content.setValue(self.mainData.memo[index].isCheck, forKey: "isCheck")
                }
            }

            try context.save()

        } catch {
            context.rollback()
        }
    }

    func removeData(_ removeIndex: Int) {
        guard let context = context else {
            return
        }
        let nsToDoRequest = NSFetchRequest<NSManagedObject>(entityName: "ToDo")

        do {
            let toDoData = try context.fetch(nsToDoRequest)

            for content in toDoData {
                if removeIndex == content.value(forKey: "id") as? Int {
                    context.delete(content)
                }
            }
            try context.save()

        } catch {
            context.rollback()
        }
    }

    func saveData(newMemoData: ToDoData) {
        self.removeData(newMemoData.id)
        if let context = context {
            let object = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: context)
            object.setValue(newMemoData.id, forKey: "id")
            object.setValue(newMemoData.title, forKey: "title")
            object.setValue(newMemoData.date, forKey: "date")
            object.setValue(newMemoData.isCheck, forKey: "isCheck")

            do {
                try context.save()
            } catch {
                context.rollback()
            }
        }
    }

    func saveAllData() {
        guard let context = context else {
            return
        }

        let request = NSFetchRequest<NSManagedObject>(entityName: "ToDo")

        do {
            let savedToDoData = try context.fetch(request)
            for content in savedToDoData {
                context.delete(content)
            }

            try context.save()
        } catch {
            context.rollback()
        }

        self.mainData.memo.forEach { saveTargetData in
            saveData(newMemoData: saveTargetData)
        }
    }

    private init() {}
}
