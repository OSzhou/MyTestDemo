//
//  MeetupWaitingTableViewCell.swift
//  TestCode
//
//  Created by Zhouheng on 2020/7/16.
//  Copyright © 2020 tataUFO. All rights reserved.
//

import UIKit

class MeetupWaitingTableViewCell: UITableViewCell {

    var passButtonClickBlock: ((_ sender: UIButton) ->())?
    var rejectButtonClickBlock: ((_ sender: UIButton) ->())?
    
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
        
        containerView.addSubview(rejectButton)
        rejectButton.snp.makeConstraints { (make) in
            make.right.equalTo(0)
            make.centerY.equalTo(icon)
            make.height.equalTo(24)
            make.width.equalTo(40)
        }
        
        containerView.addSubview(passButton)
        passButton.snp.makeConstraints { (make) in
            make.right.equalTo(rejectButton.snp.left)
            make.centerY.equalTo(rejectButton)
            make.height.equalTo(24)
            make.width.equalTo(54)
        }
        
        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(icon.snp.right).offset(12)
            make.centerY.equalTo(icon)
            make.right.equalTo(passButton.snp.left).offset(-29)
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

    /// MARK: --- action
    @objc func passButtonClick(_ sender: UIButton) {
        self.passButtonClickBlock?(sender)
    }
    
    @objc func rejectButtonClick(_ sender: UIButton) {
        self.rejectButtonClickBlock?(sender)
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
        label.text = "fsafafafasfsfsfsfsfgagragwgrwgresfsfasf"
        return label
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.text = "10:10"
        return label
    }()

    lazy var passButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "btn-check-selected"), for: .normal)
        btn.setTitle("通过", for: .normal)
        btn.backgroundColor = .yellow
        btn.layer.cornerRadius = 12
        btn.addTarget(self, action: #selector(passButtonClick(_:)), for: .touchUpInside)
        return btn
    }()
    
    lazy var rejectButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "nav-back"), for: .normal)
        btn.addTarget(self, action: #selector(rejectButtonClick(_:)), for: .touchUpInside)
        return btn
    }()
}
