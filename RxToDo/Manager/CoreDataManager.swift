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

    /**
     저장된 ToDoData들을 불러온다.

     - Returns: 저장된 ToDoData
     */
    func loadSaveData() -> [ToDoData]? {
        var loadToDo = [ToDoData]()

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

                loadToDo.append(ToDoData(id: id, title: title, date: date, isCheck: isCheck))
            }

        } catch {
            print(error.localizedDescription)
        }

        return loadToDo
    }

    /**
     ToDo에 체크를 하면 체크한 값을 저장한다.

     - Parameter index: 체크한 Cell의 ID 값
     */
    func chagneCheckData(_ index: Int) {
        guard let context = context else {
            return
        }

        do {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ToDo")
            let toDoData = try context.fetch(fetchRequest)

            for content in toDoData {
                if index == content.value(forKey: "id") as? Int {
                    content.setValue(self.mainData.toDo[index].isCheck, forKey: "isCheck")
                }
            }

            try context.save()

        } catch {
            context.rollback()
        }
    }

    /**
     저장된 ToDoData Array에 값을 삭제한다.

     - Parameter removeIndex: 체크한 Cell의 IndexPath.row
     */
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

    /**
     ToDoData Array에 값을 저장한다.

     - Parameter newToDoData: 저장할 ToDoData
     */
    func saveData(newToDoData: ToDoData) {
        self.removeData(newToDoData.id)
        if let context = context {
            let object = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: context)
            object.setValue(newToDoData.id, forKey: "id")
            object.setValue(newToDoData.title, forKey: "title")
            object.setValue(newToDoData.date, forKey: "date")
            object.setValue(newToDoData.isCheck, forKey: "isCheck")

            do {
                try context.save()
            } catch {
                context.rollback()
            }
        }
    }

    /// 저장된 ToDoData를 전부 삭제하고 새로 저장한다.
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

        self.mainData.toDo.forEach { saveTargetData in
            saveData(newToDoData: saveTargetData)
        }
    }

    private init() {}
}
