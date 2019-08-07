//
//  ViewController.swift
//  RxTableView
//
//  Created by Milkyo on 29/07/2019.
//  Copyright © 2019 MilKyo. All rights reserved.
//

import RxCocoa
import RxDataSources
import RxSwift
import UIKit

class MainView: UIViewController {
    var disposeBag = DisposeBag()
    var doneButton: UIBarButtonItem?
    var editButton: UIBarButtonItem?
    let mainViewModel = MainViewModel()
    let actionViewModel = ActionViewModel()

    var mainOwnView: MainLayout {
        return self.view as! MainLayout
    }

    func addItem(clickedIndex: IndexPath? = nil) {
        let addView = AddTodoView()

        if clickedIndex == nil {
            addView.addToDoViewModel.currentDataID = self.mainViewModel.mainData.makeNewID()
        } else {
            addView.addToDoViewModel.currentDataID = self.mainViewModel.mainData.memo[clickedIndex!.row].id
        }
        addView.addToDoViewModel.delegate = self.mainViewModel
        let newNavi = UINavigationController(rootViewController: addView)
        self.present(newNavi, animated: true)
    }

    func bindUI() {
        let dataSource = RxTableViewSectionedReloadDataSource<SectionOfMemoData>(
            configureCell: { [weak self] _, _, indexPath, item in
                guard let self = self else {
                    fatalError()
                }

                let mainCell = self.mainOwnView.mainTableView.dequeueReusableCell(withIdentifier: "MainCell", for: indexPath)
                if let cell = mainCell as? MainCell {
                    cell.mainTitleLabel.text = item.title
                    cell.checkButton.tag = item.id

                    if item.isCheck == true {
                        cell.checkButton.backgroundColor = UIColor(named: "AzureRadiance")
                    } else {
                        cell.checkButton.backgroundColor = .white
                    }

                    return cell
                }
                return mainCell
            }
        )

        dataSource.canEditRowAtIndexPath = { _, _ in true }
        dataSource.canMoveRowAtIndexPath = { _, _ in true }

        self.mainViewModel.mainData.memoData.asDriver()
            .drive(self.mainOwnView.mainTableView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)

        self.mainOwnView.mainTableView.rx.itemDeleted
            .map { ActionList.deleteItem($0) }
            .bind(to: self.actionViewModel.actionEvent)
            .disposed(by: self.disposeBag)

        self.mainOwnView.mainTableView.rx.itemMoved
            .map { ActionList.moveItem($0) }
            .bind(to: self.actionViewModel.actionEvent)
            .disposed(by: self.disposeBag)

        self.mainOwnView.mainTableView.rx.itemSelected
            .do(onNext: { [weak self] in self?.mainOwnView.mainTableView.deselectRow(at: $0, animated: true) })
            .bind(onNext: self.addItem)
            .disposed(by: self.disposeBag)

        self.mainOwnView.mainTableView.rx
            .setDelegate(self)
            .disposed(by: self.disposeBag)
    }

    func bindNavigationButton() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
        editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: nil, action: nil)
        doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = addButton
        self.navigationItem.leftBarButtonItem = self.editButton

        addButton.rx.tap.asDriver()
            .drive(onNext: { _ in self.addItem() })
            .disposed(by: self.disposeBag)

        self.editButton?.rx.tap.asDriver()
            .drive(onNext: { [weak self] _ in
                self?.mainOwnView.mainTableView.setEditing(true, animated: true)
                self?.navigationItem.leftBarButtonItem = self?.doneButton
            })
            .disposed(by: self.disposeBag)

        self.doneButton?.rx.tap.asDriver()
            .drive(onNext: { [weak self] _ in
                self?.mainOwnView.mainTableView.setEditing(false, animated: true)
                self?.navigationItem.leftBarButtonItem = self?.editButton
            })
            .disposed(by: self.disposeBag)
    }

    override func viewWillDisappear(_: Bool) {
        self.disposeBag = DisposeBag()
    }

    override func viewWillAppear(_: Bool) {
        self.bindUI()
        self.bindNavigationButton()
    }

    override func loadView() {
        let view = MainLayout()
        self.view = view
    }

    override func viewDidLoad() {
        self.navigationItem.title = "ToDo"
        self.mainOwnView.mainTableView.rowHeight = 44
    }
}

extension MainView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in

            guard let dataSource = tableView.dataSource else {
                return
            }
            dataSource.tableView?(tableView, commit: .delete, forRowAt: indexPath)
        }

        return UISwipeActionsConfiguration(actions: [action])
    }

    func tableView(_: UITableView, willBeginEditingRowAt _: IndexPath) {
        self.navigationItem.leftBarButtonItem = self.doneButton
    }

    func tableView(_: UITableView, didEndEditingRowAt _: IndexPath?) {
        self.navigationItem.leftBarButtonItem = self.editButton
    }
}
