//
//  UITableView+Extensions.swift
//  demo
//
//  Created by Quan Nguyen on 13/07/2022.
//

import UIKit

protocol ReuseID {
    static var kReuseID: String { get }
}

extension ReuseID {
    static var kReuseID: String {
        String(describing: Self.self)
    }
}

protocol TableViewCellProtocol: AnyObject, ReuseID {
    associatedtype ViewModel

    func config(with viewModel: ViewModel, indexPath: IndexPath)
}

extension UITableView {
    func dequeue<Cell>(type: Cell.Type, for indexPath: IndexPath) -> Cell where Cell: ReuseID, Cell: UITableViewCell {
        let id = Cell.kReuseID
        guard let cell = dequeueReusableCell(withIdentifier: id, for: indexPath) as? Cell else {
            fatalError("Dequeue failed for: \(id), at indexPath: \(indexPath.description)")
        }
        return cell
    }

    func dequeue<Cell>(type: Cell.Type) -> Cell where Cell: ReuseID, Cell: UITableViewCell {
        guard let cell = dequeueReusableCell(withIdentifier: Cell.kReuseID) as? Cell else {
            fatalError("Dequeue failed for: \(Cell.kReuseID)")
        }
        return cell
    }

    func dequeue<Cell>(type: Cell.Type) -> Cell where Cell: ReuseID, Cell: UITableViewHeaderFooterView {
        guard let cell = dequeueReusableHeaderFooterView(withIdentifier: Cell.kReuseID) as? Cell else {
            fatalError("HeaderFooter dequeue failed for: \(Cell.kReuseID)")
        }
        return cell
    }
}

extension UITableView {
    func createCell<Cell, ViewModel>(_ type: Cell.Type, _ viewModel: ViewModel, _ indexPath: IndexPath) -> Cell
        where Cell: UITableViewCell, Cell: TableViewCellProtocol, Cell.ViewModel == ViewModel {
        let cell = dequeue(type: Cell.self, for: indexPath)
        cell.config(with: viewModel, indexPath: indexPath)
        return cell
    }

    func register<Cell>(type: Cell.Type, identifier: String? = nil, nibName: String? = nil, bundle: Bundle = .main) {
        let cellName = String(describing: type)
        let cellIdentifier = identifier ?? cellName
        let cellNibName = nibName ?? cellName
        register(UINib(nibName: cellNibName, bundle: bundle), forCellReuseIdentifier: cellIdentifier)
    }
}
