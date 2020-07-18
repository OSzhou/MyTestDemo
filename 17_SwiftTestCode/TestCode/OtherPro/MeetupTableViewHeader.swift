//
//  MeetupTableViewHeader.swift
//  TestCode
//
//  Created by Zhouheng on 2020/7/16.
//  Copyright © 2020 tataUFO. All rights reserved.
//

import UIKit
import SnapKit

class MeetupTableViewHeader: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    private func setupUI() {
        addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(0)
            make.left.equalTo(15)
            make.right.equalTo(-15)
        }
        
        containerView.addSubview(icon)
        icon.snp.makeConstraints { (make) in
            make.top.equalTo(20)
            make.left.equalTo(0)
            make.height.width.equalTo(17)
        }
        
        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(icon.snp.right).offset(4)
            make.centerY.equalTo(icon)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// MARK: --- lazy loading
    lazy var containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var icon: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "btn-check-selected")
        return iv
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .black
        label.text = "test string"
        return label
    }()
}
