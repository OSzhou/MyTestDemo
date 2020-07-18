//
//  WBImageTitleDetailAlertView.swift
//  ACN_Wallet
//
//  Created by Zhouheng on 2020/6/19.
//  Copyright © 2020 TTC. All rights reserved.
//

import UIKit

class WBImageTitleDetailAlertView: UIView {

    var closeClick:(() -> ())?
    /// 确定
    var confirmClick:(() -> ())?
    /// 此刻弹框是否正在展示中
    static private(set) var showing: Bool = false
    
    init(frame: CGRect = UIScreen.main.bounds, image: UIImage?, title: String?, detail: String?, confirmTitle: String?, cancelTitle: String?) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        addSubview(contentView)
       
        
        if let img = image {
            contentView.addSubview(icon)
            icon.image = image
            icon.snp.makeConstraints { (make) in
                make.top.equalTo(contentView)
                make.centerX.equalTo(contentView)
                make.width.equalTo(img.size.width)
                make.height.equalTo(img.size.height)
            }
            
            midLabelLayout(title, detail: detail, markView: icon, offset: 12)
            
        } else {
            midLabelLayout(title, detail: detail, markView: contentView, offset: 30)
        }
        
        contentView.addSubview(confirmButton)
        var confirmW: CGFloat = screenWidth - 105
        if let confirmT = confirmTitle {
            confirmButton.setTitle(confirmT, for: .normal)
        }
        
        var markView = contentView
        if let _ = detail {
            markView = detailLabel
        } else if let _ = title {
            markView = titleLabel
        }
        
        if let cancelT = cancelTitle {
            confirmW = (screenWidth - 105) / 2.0
            contentView.addSubview(cancelButton)
            cancelButton.setTitle(cancelT, for: .normal)
            cancelButton.snp.makeConstraints { (make) in
                make.top.equalTo(confirmButton)
                make.left.bottom.equalTo(0)
                make.width.equalTo(confirmW)
                make.height.equalTo(50)
            }
        }

        confirmButton.snp.makeConstraints { (make) in
            make.top.equalTo(markView.snp.bottom).offset(30)
            make.right.equalTo(0)
            make.width.equalTo(confirmW)
            make.height.equalTo(50)
            make.bottom.equalTo(0)
        }
        
        contentView.snp.makeConstraints { (make) in
            make.width.equalTo(screenWidth - 105)
            make.center.equalTo(self)
        }
    }
    
    private func midLabelLayout(_ title: String?, detail: String?, markView: UIView, offset: CGFloat) {
        if let t = title {
            contentView.addSubview(titleLabel)
            titleLabel.text = t
            
            titleLabel.snp.makeConstraints { (make) in
                make.left.equalTo(30)
                make.right.equalTo(-30)
                make.top.equalTo(markView.snp.bottom).offset(offset)
            }
            
            if let d = detail {
                contentView.addSubview(detailLabel)
                detailLabel.text = d
                
                detailLabel.snp.makeConstraints { (make) in
                    make.left.right.equalTo(titleLabel)
                    make.top.equalTo(titleLabel.snp.bottom).offset(4)
                }
            }
        } else {
            if let d = detail {
                contentView.addSubview(detailLabel)
                detailLabel.text = d
                
                detailLabel.snp.makeConstraints { (make) in
                    make.left.equalTo(30)
                    make.right.equalTo(-30)
                    make.top.equalTo(markView.snp.bottom).offset(offset)
                }
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// MARK: --- action
    @objc func buttonClick(_ sender: UIButton) {
        dismiss(completion: {
            self.confirmClick?()
        })
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
        
        guard !WBImageTitleDetailAlertView.showing else { return false }
        guard let superView = superview ?? UIApplication.shared.windows.first else { return false }
        alpha = 0
        superView.addSubview(self)
        
        WBImageTitleDetailAlertView.showing = true
        UIView.animate(withDuration: 0.25) {
            self.alpha = 1
        }
        
        return true
    }
    
    func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
        
        let finish = { [weak self] (finish: Bool) in
            self?.removeFromSuperview()
            WBImageTitleDetailAlertView.showing = false
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
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var icon: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.black
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    lazy var detailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.black
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    lazy var confirmButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .gray
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitle("确认", for: .normal)
        button.addTarget(self, action: #selector(buttonClick(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .gray
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitle("取消", for: .normal)
        button.addTarget(self, action: #selector(cancelButtonClick(_:)), for: .touchUpInside)
        return button
    }()
    
}
