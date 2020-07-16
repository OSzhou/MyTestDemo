//
//  UITableVIew.swift
//  TestCode
//
//  Created by Zhouheng on 2020/7/16.
//  Copyright © 2020 tataUFO. All rights reserved.
//
import UIKit

extension UITableView {

    /// 适配iOS11
    func fitIOS11() {
        fitIOS11(nil)
    }

    /// 适配iOS11
    func fitIOS11(_ callback: (() -> Void)? ) {
        if #available(iOS 11.0, *) {
            self.contentInsetAdjustmentBehavior = .never
            self.estimatedRowHeight = 0
            self.estimatedSectionFooterHeight = 0
            self.estimatedSectionHeaderHeight = 0

            guard let callBack = callback else {
                return
            }

            callBack()
        }
    }

    /// 适配iPhoneX
    func fitIPhoneX() {
        if UIDevice.current.iPhoneX(){
            contentInset = UIEdgeInsets(top: 0, left: 0, bottom: Constants.BottomSafeMargin, right: 0)
        }
    }

    func reloadData(_ completion: @escaping () -> ()) {
        UIView.animate(withDuration: 0, animations: {
            self.reloadData()
        }, completion: { _ in
            completion()
        })
    }

    func reloadRows(_ rows: [IndexPath]) {
        //更新 rows
        UIView.setAnimationsEnabled(false)
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        self.beginUpdates()
        self.reloadRows(at: rows, with: .none)
        self.endUpdates()
        CATransaction.commit()
        UIView.setAnimationsEnabled(true)
    }

    func deleteRows(_ rows: [IndexPath]) {
        // 删除rows
        UIView.setAnimationsEnabled(false)
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        self.beginUpdates()
        self.deleteRows(at: rows, with: .none)
        self.endUpdates()
        CATransaction.commit()
        UIView.setAnimationsEnabled(true)
    }

    func insertRowsAtBottom(_ rows: [IndexPath]) {
        //保证 insert row 不闪屏
        UIView.setAnimationsEnabled(false)
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        self.beginUpdates()
        self.insertRows(at: rows, with: .none)
        self.endUpdates()
        CATransaction.commit()
        UIView.setAnimationsEnabled(true)
    }

    func insertRowsAtBottomAndScroll(_ rows: [IndexPath]) {
        //保证 insert row 不闪屏
        UIView.setAnimationsEnabled(false)
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        self.beginUpdates()
        self.insertRows(at: rows, with: .none)
        self.endUpdates()
        self.scrollToRow(at: rows[0], at: .bottom, animated: false)
        CATransaction.commit()
        UIView.setAnimationsEnabled(true)
    }

    func totalRows() -> Int {
        var i = 0
        var rowCount = 0
        while i < self.numberOfSections {
            rowCount += self.numberOfRows(inSection: i)
            i += 1
        }
        return rowCount
    }

    var lastIndexPath: IndexPath? {
        if (self.totalRows()-1) > 0 {
            return IndexPath(row: self.totalRows()-1, section: 0)
        } else {
            return nil
        }
    }

    //插入数据后调用
    func scrollBottomWithoutFlashing() {
        guard let indexPath = self.lastIndexPath else {
            return
        }
        UIView.setAnimationsEnabled(false)
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        self.scrollToRow(at: indexPath, at: .bottom, animated: false)
        CATransaction.commit()
        UIView.setAnimationsEnabled(true)
    }

    //键盘动画结束后调用
    func scrollBottomToLastRow() {
        guard let indexPath = self.lastIndexPath else {
            return
        }
        self.scrollToRow(at: indexPath, at: .bottom, animated: false)
    }

    func scrollToBottom(animated: Bool) {
        let bottomOffset = CGPoint(x: 0, y: self.contentSize.height - self.bounds.size.height)
        self.setContentOffset(bottomOffset, animated: animated)
    }
}
