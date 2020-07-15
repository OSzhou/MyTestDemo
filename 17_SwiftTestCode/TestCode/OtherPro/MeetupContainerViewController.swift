//
//  MeetupContainerViewController.swift
//  TestCode
//
//  Created by Zhouheng on 2020/7/14.
//  Copyright © 2020 tataUFO. All rights reserved.
//

import UIKit

class MeetupContainerViewController: UIViewController {
    let headerH: CGFloat = 88 + 52.5
    let childVCCount: Int = 3
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        self.extendedLayoutIncludesOpaqueBars = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.isTranslucent = false
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        scrollViewDidEndScrollingAnimation(horizontalScrollView)
    }
    
    private func setupUI() {
        let vc0 = MeetupChildViewController()
//        vc0.view.backgroundColor = .blue
        addChild(vc0)
        
        let vc1 = MeetupChildViewController()
//        vc1.view.backgroundColor = .green
        addChild(vc1)
        
        let vc2 = MeetupChildViewController()
//        vc2.view.backgroundColor = .black
        addChild(vc2)
        
        view.addSubview(horizontalScrollView)
        view.addSubview(headerView)
    }
    
    /// MARK: --- lazy loading
    private lazy var horizontalScrollView: UIScrollView = {
        let sv = UIScrollView(frame: CGRect(x: 0, y: headerH, width: screenWidth, height: screenHeight - headerH))
        sv.bounces = false
        sv.alwaysBounceHorizontal = true
        sv.showsHorizontalScrollIndicator = false
        sv.isPagingEnabled = true
        sv.contentSize = CGSize(width: screenWidth * CGFloat(childVCCount), height: 0)
        sv.delegate = self
        
        if #available(iOS 11.0, *) {
            sv.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        sv.backgroundColor = .gray
        return sv
    }()
    
    private lazy var headerView: MeetupContainerHeaderView = {
        let view = MeetupContainerHeaderView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: headerH))
        view.currentSelectedButton = { [weak self] _, index in
            guard let self = self else { return }
            var offsetP = self.horizontalScrollView.contentOffset
            offsetP.x = screenWidth * CGFloat(index)
            self.horizontalScrollView.setContentOffset(offsetP, animated: true)
        }
        return view
    }()
    
}

extension MeetupContainerViewController: UIScrollViewDelegate {
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        let index: Int = Int(offsetX / screenWidth)
        headerView.changeSelectedButton(index)
        let willShowVC = self.children[index]
        if willShowVC.isViewLoaded { return }
        willShowVC.view.frame = CGRect(x: offsetX, y: 0, width: screenWidth, height: screenHeight - headerH)
        scrollView.addSubview(willShowVC.view)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDidEndScrollingAnimation(scrollView)
    }
}
