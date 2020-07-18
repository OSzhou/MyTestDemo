//
//  HFBaseViewController.swift
//  TTC_Wallet_iOS
//
//  Created by zhangliang on 2018/7/2.
//  Copyright © 2018 tataufo. All rights reserved.
//

import UIKit

class HFBaseViewController: UIViewController {

    var navigationBarHidden: Bool = true

    var statusBarLight: Bool = false
    var statusBarHidden: Bool = false

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarLight ? .lightContent : .default
    }

    override var prefersStatusBarHidden: Bool {
        return statusBarHidden ? true : false
    }

    /// 不显示titleview
    func hiddenNaviTitleView() {
        navigationItem.titleView = UIView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        automaticallyAdjustsScrollViewInsets = false

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if navigationBarHidden {
            navigationController?.isNavigationBarHidden = true
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        if navigationBarHidden {
            navigationController?.isNavigationBarHidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    deinit {
//        logger.debug("\(self.debugDescription)")
    }
}
