//
//  WBAlertBaseView.swift
//  ACN_Wallet
//
//  Created by Zhouheng on 2020/5/11.
//  Copyright © 2020 TTC. All rights reserved.
//

import UIKit

class WBAlertBaseView: UIView {
    
    var closeClick:(() -> ())?
    
    /// 此刻弹框是否正在展示中
    static private(set) var showing: Bool = false
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect = UIScreen.main.bounds) {
        
        super.init(frame: frame)
        
        setupSubviews()
    }
    
    private func setupSubviews() {
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(customView)
        contentView.addSubview(comfirmButton)
        contentView.addSubview(cancelButton)
         
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(24)
            make.right.equalTo(-8)
            make.top.equalTo(20)
        }
        
        customView.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.bottom.equalTo(comfirmButton.snp.top).offset(-8)
            make.height.equalTo(100)
            make.width.equalTo(screenWidth - 80)
        }
        
        comfirmButton.snp.makeConstraints { (make) in
            make.width.equalTo(75)
            make.height.equalTo(36)
            make.right.bottom.equalTo(-8)
        }
        
        cancelButton.snp.makeConstraints { (make) in
            make.width.equalTo(75)
            make.height.equalTo(36)
            make.right.equalTo(comfirmButton.snp.left).offset(-8)
            make.bottom.equalTo(-8)
        }
        
        contentView.snp.makeConstraints { (make) in
            make.left.right.equalTo(customView)
            make.center.equalTo(self)
        }
    }
    
    /// MARK: --- action
    @objc func buttonClick(_ sender: UIButton) {
        
    }
    
    @objc private func cancelButtonClick(_ sender: UIButton) {
        
        dismiss(completion: {
            self.cancel()
        })
    }
    
    func cancel() {
        self.closeClick?()
        
    }
    
    @discardableResult
    func show(_ superview: UIView? = nil) -> Bool {
        
        guard !WBAlertBaseView.showing else { return false }
        guard let superView = superview ?? UIApplication.shared.windows.first else { return false }
        alpha = 0
        superView.addSubview(self)
        
        WBAlertBaseView.showing = true
        UIView.animate(withDuration: 0.25) {
            self.alpha = 1
        }
        
        return true
    }
    
    func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
        
        let finish = { [weak self] (finish: Bool) in
            self?.removeFromSuperview()
            WBAlertBaseView.showing = false
            completion?()
        }
        
        if animated {
            UIView.animate(withDuration: 0.25, animations: {
                self.alpha = 0
            }, completion: finish)
        } else {
            finish(true)
        }
    }

    /// MARK: --- lazy loading
    lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 2
        // shadowCode
        view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.26).cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 12)
        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = 24
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = UIColor.gray
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var customView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var comfirmButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitle("确认", for: .normal)
        button.addTarget(self, action: #selector(buttonClick(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitle("取消", for: .normal)
        button.addTarget(self, action: #selector(cancelButtonClick(_:)), for: .touchUpInside)
        return button
    }()
}
