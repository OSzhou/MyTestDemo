//
//  WBSelectGenderView.swift
//  ACN_Wallet
//
//  Created by Zhouheng on 2020/5/12.
//  Copyright © 2020 TTC. All rights reserved.
//

import UIKit

class WBSelectGenderView: WBAlertBaseView {

    /// 确定
    var confirmClick:((Int) -> ())?
    
    var selectedGender: Int = 3
    
    static var isShowed = false
    
    init() {
        super.init(frame: UIScreen.main.bounds)
        
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        
        titleLabel.text = "请选择性别"
        customView.snp.updateConstraints { (make) in
            make.height.equalTo(96)
        }
        customView.addSubview(maleButton)
        customView.addSubview(maleLabel)
        
        maleButton.snp.makeConstraints { (make) in
            make.left.top.equalTo(0)
            make.height.equalTo(48)
            make.width.equalTo(71)
        }
        maleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(maleButton.snp.right)
            make.centerY.equalTo(maleButton)
            make.right.equalTo(-24)
        }
        
        customView.addSubview(femaleButton)
        customView.addSubview(femaleLabel)
        
        femaleButton.snp.makeConstraints { (make) in
            make.left.bottom.equalTo(0)
            make.height.equalTo(48)
            make.width.equalTo(71)
        }
        femaleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(femaleButton.snp.right)
            make.centerY.equalTo(femaleButton)
            make.right.equalTo(-24)
        }
    }
    
    /// MARK: --- action
    @objc func maleButtonClick(_ sender: UIButton) {
        femaleButton.isSelected = false
        sender.isSelected = true
        selectedGender = 2
    }
    
    @objc func femaleButtonClick(_ sender: UIButton) {
        maleButton.isSelected = false
        sender.isSelected = true
        selectedGender = 1
    }
    
    @objc func maleTapClick(_ gesture: UITapGestureRecognizer) {
        femaleButton.isSelected = false
        maleButton.isSelected = true
        selectedGender = 2
    }
    
    @objc func femaleTapClick(_ gesture: UITapGestureRecognizer) {
        maleButton.isSelected = false
        femaleButton.isSelected = true
        selectedGender = 1
    }
    
    @objc override func buttonClick(_ sender: UIButton) {
        super.buttonClick(sender)
        
        dismiss(completion: {
            WBSelectGenderView.isShowed = false
            self.confirmClick?(self.selectedGender)
            
        })
    }
    @discardableResult
    override func show(_ superview: UIView? = nil) -> Bool {
        
        if WBSelectGenderView.isShowed {
            return false
        } else {
                        
            let showed = super.show(superview)
            if showed {
                WBSelectGenderView.isShowed = true
            }
            return showed
        }
    }
    
    override func cancel() {
        WBSelectGenderView.isShowed = false
        super.cancel()
    }

    /// MARK: --- lazy var
    lazy var maleButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "wb_unselect"), for: .normal)
        button.setImage(UIImage(named: "wb_select"), for: .selected)
        button.addTarget(self, action: #selector(maleButtonClick(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var maleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.black
        label.text = "男"
        
        label.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(maleTapClick(_:)))
        label.addGestureRecognizer(tap)
        
        return label
    }()
    
    lazy var femaleButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "wb_unselect"), for: .normal)
        button.setImage(UIImage(named: "wb_select"), for: .selected)
        button.addTarget(self, action: #selector(femaleButtonClick(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var femaleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize:16)
        label.textColor = UIColor.black
        label.text = "女"
        
        label.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(femaleTapClick(_:)))
        label.addGestureRecognizer(tap)
        
        return label
    }()
}
