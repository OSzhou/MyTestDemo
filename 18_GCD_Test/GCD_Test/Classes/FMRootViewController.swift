//
//  FMRootViewController.swift
//  GCD_Test
//
//  Created by Zhouheng on 2020/8/5.
//  Copyright © 2020 tataUFO. All rights reserved.
//

import UIKit

// MARK: 屏幕高度
let screenHeight: CGFloat = UIScreen.main.bounds.height
// MARK: 屏幕宽度
let screenWidth: CGFloat = UIScreen.main.bounds.width

class FMRootViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .gray
        setupUI()
    }

    private func setupUI() {
        
        view.addSubview(magnifyButton)
        view.addSubview(cameraButton)
        view.addSubview(albumButton)
        view.addSubview(otherButton)
//        view.addSubview(popButton)
//        view.addSubview(reminderButton)
        
    }

    /// MARK: --- action
    @objc private func toMagnifyView(_ sender: UIButton) {
        self.navigationController?.pushViewController(FMQuestionsViewController(), animated: true)
    }
    
    @objc private func customCamera(_ sender: UIButton) {
        self.navigationController?.pushViewController(FMPrintViewController(), animated: true)
    }
    
    @objc private func customAlbum(_ sender: UIButton) {
        self.navigationController?.pushViewController(FMGroupViewController(), animated: true)
    }
    
    @objc private func other(_ sender: UIButton) {
        self.navigationController?.pushViewController(FMBarrierViewController(), animated: true)
    }
    
    @objc private func popAction(_ sender: UIButton) {
    
    }
    
    @objc private func reminderAction(_ sender: UIButton) {
//        self.navigationController?.pushViewController(FMCalendarAndReminderViewController(), animated: true)
    }
    
    /// MARK: --- lazy loading
    lazy var magnifyButton: UIButton = {
        let button = UIButton(frame: CGRect(x: (screenWidth - 200) / 2, y: 88 + 50, width: 200, height: 50))
        button.setTitle("? ? ?", for: .normal)
        button.addTarget(self, action: #selector(toMagnifyView(_:)), for: .touchUpInside)
        button.backgroundColor = .gray
        return button
    }()
    
    lazy var cameraButton: UIButton = {
        let button = UIButton(frame: CGRect(x: (screenWidth - 200) / 2, y: 88 + 110, width: 200, height: 50))
        button.setTitle("print", for: .normal)
        button.addTarget(self, action: #selector(customCamera(_:)), for: .touchUpInside)
        button.backgroundColor = .gray
        return button
    }()
    
    lazy var albumButton: UIButton = {
        let button = UIButton(frame: CGRect(x: (screenWidth - 200) / 2, y: 88 + 170, width: 200, height: 50))
        button.setTitle("group", for: .normal)
        button.addTarget(self, action: #selector(customAlbum(_:)), for: .touchUpInside)
        button.backgroundColor = .gray
        return button
    }()
    
    lazy var otherButton: UIButton = {
        let button = UIButton(frame: CGRect(x: (screenWidth - 200) / 2, y: 88 + 230, width: 200, height: 50))
        button.setTitle("barrier", for: .normal)
        button.addTarget(self, action: #selector(other(_:)), for: .touchUpInside)
        button.backgroundColor = .gray
        return button
    }()
    
    lazy var popButton: UIButton = {
        let button = UIButton(frame: CGRect(x: (screenWidth - 200) / 2, y: 88 + 290, width: 200, height: 50))
        button.setTitle("弹框", for: .normal)
        button.addTarget(self, action: #selector(popAction(_:)), for: .touchUpInside)
        button.backgroundColor = .gray
        return button
    }()
    
    lazy var reminderButton: UIButton = {
        let button = UIButton(frame: CGRect(x: (screenWidth - 200) / 2, y: 88 + 360, width: 200, height: 50))
        button.setTitle("提醒", for: .normal)
        button.addTarget(self, action: #selector(reminderAction(_:)), for: .touchUpInside)
        button.backgroundColor = .gray
        return button
    }()
}
