//
//  MeetupPassOrRejectTableViewCell.swift
//  TestCode
//
//  Created by Zhouheng on 2020/7/16.
//  Copyright © 2020 tataUFO. All rights reserved.
//

import UIKit

enum MeetupStatusType {
    case pass
    case reject
}

class MeetupPassOrRejectTableViewCell: UITableViewCell {

    var cellType: MeetupStatusType = .pass
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    private func setupUI() {
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        containerView.addSubview(topLine)
        topLine.snp.makeConstraints { (make) in
            make.left.equalTo(63)
            make.top.right.equalTo(0)
            make.height.equalTo(0.5)
        }
        
        containerView.addSubview(icon)
        icon.snp.makeConstraints { (make) in
            make.left.equalTo(36)
            make.top.equalTo(topLine.snp.bottom).offset(10)
            make.height.width.equalTo(36)
        }
        
        containerView.addSubview(statusLabel)
        statusLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.centerY.equalTo(icon)
        }
        
        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(icon.snp.right).offset(12)
            make.centerY.equalTo(icon)
            make.right.equalTo(statusLabel.snp.left).offset(-72)
        }
        
        containerView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(12.5)
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    /// MARK: --- lazy loading
    lazy var containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var topLine: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    lazy var icon: UIImageView = {
        let iv = UIImageView()
        iv.layer.masksToBounds = true
        iv.layer.cornerRadius = 18
        iv.image = UIImage(named: "play-btn")
        return iv
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .black
        label.text = "fsafafafasfsfsfsfsfsfsfasf"
        return label
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.text = "10:10"
        return label
    }()
    
    lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.text = "已通过"
        return label
    }()
}
