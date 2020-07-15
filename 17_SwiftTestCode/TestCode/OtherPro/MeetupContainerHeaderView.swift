//
//  MeetupContainerHeaderView.swift
//  TestCode
//
//  Created by Zhouheng on 2020/7/14.
//  Copyright © 2020 tataUFO. All rights reserved.
//

import UIKit

class MeetupContainerHeaderView: UIView {
    
    var currentSelectedButton: ((_ sender: UIButton, _ index: Int) -> ())?
    
    let H: CGFloat = 88 + 52.5
    var buttons: [UIButton] = []
    var selectedButton: UIButton?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    private func setupUI() {
        self.addSubview(containerView)
        containerView.addSubview(buttonsBox)
        containerView.addSubview(indicator)
    }
    
    func changeSelectedButton(_ index: Int) {
        if index < buttons.count {
            if let sBtn = selectedButton {
                sBtn.isSelected = false
            }
            let btn = buttons[index]
            btn.isSelected = true
            selectedButton = btn
            let frame = CGRect(x: btn.center.x - 4, y: buttonsBox.frame.maxY + 4, width: 8, height: 4)
            UIView.animate(withDuration: 0.25) {
                self.indicator.frame = frame
            }
        }
    }
    
    /// MARK: --- action
    @objc func buttonClick(_ sender: UIButton) {
        changeSelectedButton(sender.tag - 1000)
        self.currentSelectedButton?(sender, sender.tag - 1000)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// MARK: --- lazy loading
    private lazy var containerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: H))
        
        let path = UIBezierPath(roundedRect: view.frame, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: 30, height: 30))
        view.backgroundColor = .yellow
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.frame = view.frame
        view.layer.mask = shapeLayer
        view.layer.masksToBounds = true
        
        return view
    }()
    
    private lazy var buttonsBox: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 88 + 15.5, width: screenWidth, height: 21))
        let titles = ["待审核", "已通过", "已拒绝"]
        let w = screenWidth / 3.0
        for (i, title) in titles.enumerated() {
            let button = UIButton(frame: CGRect(x: w * CGFloat(i), y: 0, width: w, height: 21))
            button.setTitle(title, for: .normal)
            button.setTitleColor(.gray, for: .normal)
            button.setTitleColor(.black, for: .selected)
            button.tag = 1000 + i
            if i == 0 {
                selectedButton = button
                button.isSelected = true
            }
            button.addTarget(self, action: #selector(buttonClick(_:)), for: .touchUpInside)
            view.addSubview(button)
            buttons.append(button)
        }
        
        return view
    }()
    
    private lazy var indicator: UIView = {
        let x = screenWidth / 6.0 - 4
        let view = UIView(frame: CGRect(x: x, y: 88 + 40.5, width: 8, height: 4))
        view.backgroundColor = .purple
        view.layer.cornerRadius = 2
        view.layer.masksToBounds = true
        return view
    }()
}
