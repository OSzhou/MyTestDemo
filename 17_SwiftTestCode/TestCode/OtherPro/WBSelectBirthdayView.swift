//
//  WBSelectBirthdayView.swift
//  ACN_Wallet
//
//  Created by Zhouheng on 2020/5/12.
//  Copyright © 2020 TTC. All rights reserved.
//

import UIKit

class WBSelectBirthdayView: WBAlertBaseView {

    /// 确定
    var confirmClick:((TimeInterval) -> ())?
    
    var selectedStamp: TimeInterval = 0
    
    static var isShowed = false
    
    init() {
        super.init(frame: UIScreen.main.bounds)
        
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        
        titleLabel.text = "请选择生日"
        customView.snp.updateConstraints { (make) in
            make.height.equalTo(129)
        }
        
        customView.addSubview(datePickerView)
        datePickerView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
    }
    
    /// MARK: --- action
    @objc func dataPickerEvent(_ picker: UIDatePicker) {
        selectedStamp = picker.date.timeIntervalSince1970
//        logger.debug(" dateStamp ---> \(selectedStamp)")
    }
    
    @objc override func buttonClick(_ sender: UIButton) {
        super.buttonClick(sender)
        
        dismiss(completion: {
            WBSelectBirthdayView.isShowed = false
            self.confirmClick?(self.selectedStamp)
            
        })
    }
    @discardableResult
    override func show(_ superview: UIView? = nil) -> Bool {
        
        if WBSelectBirthdayView.isShowed {
            return false
        } else {
                        
            let showed = super.show(superview)
            if showed {
                WBSelectBirthdayView.isShowed = true
            }
            return showed
        }
    }
    
    override func cancel() {
        WBSelectBirthdayView.isShowed = false
        super.cancel()
    }

    /// MARK: --- lazy var
    lazy var datePickerView: UIDatePicker = {
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = UIDatePicker.Mode.date// 年 / 月 / 日 形式显示
        
        datePicker.addTarget(self, action: #selector(dataPickerEvent(_:)), for: UIControl.Event.valueChanged)
        
        let calendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
        let currentDate = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyy-MM-dd"
        
        let maxStr = "2006-01-01"
        let maxDate = dateFormatter.date(from: maxStr)
        
        let minStr = "1950-01-01"
        let minDate = dateFormatter.date(from: minStr)
        
        datePicker.maximumDate = maxDate
        datePicker.minimumDate = minDate
        
        let dafeultStr = "1995-01-01"
        if let defaultDate = dateFormatter.date(from: dafeultStr) {
            datePicker.setDate(defaultDate, animated: true)
            self.selectedStamp = defaultDate.timeIntervalSince1970
        }
        
        return datePicker
        
    }()

}
