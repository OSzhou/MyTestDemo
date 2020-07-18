//
//  Constants.swift
//  TTC_Wallet_iOS
//
//  Created by zhangliang on 2018/7/2.
//  Copyright © 2018 tataufo. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    ///MARK: -- App发布版本号
    static let ReleaseNumber: Int32 = 19
    /// 每次提交时更新此值，设为可能审核结束的那天中午，一般按照两天算 !!!
    static let VerifyingExpireTimeStamp: TimeInterval = 1587787539 // 2020-04-25 12:05:39

    static let Version: String = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String

    /// App Store 下载地址
    static let AppStoreURL: String = "https://itunes.apple.com/us/app/hey-five/id1459094367?l=zh&ls=1&mt=8"

    /// 分享二维码地址
    static let ShareQRURL: String = "http://heyfive.cn/download"

    /// 关于地址
    static let AboutAppURL: String = "http://heyfive.cn/version_introduction?version=\(Version)"
    
    static let UniversalLinkHost: String = "apple-app-hf.tataufo.com"

    // MARK: - - 宽高
    // MARK: 屏幕高度
    static let ScreenHeight: CGFloat = UIScreen.main.bounds.height
    // MARK: 屏幕宽度
    static let ScreenWidth: CGFloat = UIScreen.main.bounds.width
    // MARK: 比例
    static let ScreenScale: CGFloat = UIScreen.main.scale
    
    // MARK: nav下面的view的高度
    static let NavBottomHeight: CGFloat = 52
    
    static let LeftRightMargin: CGFloat = 28
    
    static let BottomMargin: CGFloat = 30
    
    static let AuditCardWidth: CGFloat = Constants.ScreenWidth - Constants.LeftRightMargin * 2
    
    static let AuditCardHeight: CGFloat = Constants.ScreenHeight - CGFloat(Constants.StatusBarHeight) - Constants.BottomMargin - 60
    // profile页滚动headerView的高度
    static let ScrollHeaderHeight: CGFloat = Constants.ScreenWidth
    
    static let BottomSafeMargin: CGFloat = UIDevice.current.iPhoneX() ? 34.0 :0.0
    
    static let NavAndStatusBarHeight: CGFloat = UIDevice.current.iPhoneX() ? 88.0 : 64.0
    
    static let StatusBarHeight: CGFloat = UIDevice.current.iPhoneX() ? 44.0 : 20.0
    // avatar最低限制
    static let AvatarCount = 1
    
    // MARK: - 与环境相关的常量
    enum API {
        case account
        case imc
        case image
        case po
        case env

        var host: String {
            switch self {
            case .account:
                return ServerURL.Account
            case .imc:
                return ServerURL.Imc
            case .image:
                return ServerURL.Image
            case .po:
                return ServerURL.Po
            case .env:
                return ServerURL.Env
            }
        }
    }
    
    private struct ServerURL {
        #if DEV

        static let Account: String = "http://dev.heyfive.cn:10000/v1"
        static let Imc: String = "http://dev.heyfive.cn:11000/v1"
        static let Image: String = "http://pmszbn9yo.bkt.clouddn.com"
        static let Po: String = "http://dev.heyfive.cn:12000/v1"
        static let Env: String = "http://dev.heyfive.cn:13000/v1"

        #elseif TEST

        static let Account: String = "http://dev.heyfive.cn:10000/v1"
        static let Imc: String = "http://dev.heyfive.cn:11000/v1"
        static let Image: String = "http://pmszbn9yo.bkt.clouddn.com"
        static let Po: String = "http://dev.heyfive.cn:12000/v1"
        static let Env: String = "http://dev.heyfive.cn:13000/v1"

        #else

        static let Account: String = "http://prod6.heyfive.cn:10000/v1"
        static let Imc: String = "http://prod6.heyfive.cn:11000/v1"
        static let Image: String = "http://imagecloud.heyfive.cn"
        static let Po: String = "http://prod6.heyfive.cn:12000/v1"
        static let Env: String = "http://prod6.heyfive.cn:13000/v1"

        #endif
    }

    // MARK: - 个推相关
    struct GeTui {
        #if DEV

        static let AppId: String = "98nuzhfbQ7810VfUA8aK11"
        static let AppKey: String = "eBNtwMkmrF7ZtVjs9xI7n"
        static let AppSecret: String = "WSTbEulO6z5bEJLg0E0HP1"

        #elseif TEST

        static let AppId: String = "ziSIIIC9q79WqzOqakT40A"
        static let AppKey: String = "pcXkhH0WWg8vzAN07pNXS3"
        static let AppSecret: String = "u4d7dZih1o9zCc1p8MT2i8"

        #else

        static let AppId: String = "Kx7in64mf09ML61BAPnch8"
        static let AppKey: String = "ewSdp2pw4b78AbX962YEz8"
        static let AppSecret: String = "5uWxzzgcWbAYFV2cOTnHG3"

        #endif
    }

    // MARK: - 友盟相关
    struct Umeng {
        #if DEV

        static let AppKey: String = "5c88c30761f564975f000951"
        static let Channel: String = "App Store"

        #elseif TEST

        static let AppKey: String = "5c88c30761f564975f000951"
        static let Channel: String = "App Store"

        #else

        static let AppKey: String = "5c88c30761f564975f000951"
        static let Channel: String = "App Store"

        #endif
    }

    //MARK: - Leancloud相关
    struct LeanCloud {
        #if DEV

        static let AppID = "0xaVWBW6VNIp5juPEkhArH5X-gzGzoHsz"
        static let AppKey = "Ytl5gVFi8TSep5sXjVc4mi4T"
        
        static let APIServerURL = "https://dev-leanapi.heyfive.cn"

        #elseif TEST

        static let AppID = "0xaVWBW6VNIp5juPEkhArH5X-gzGzoHsz"
        static let AppKey = "Ytl5gVFi8TSep5sXjVc4mi4T"
        
        static let APIServerURL = "https://dev-leanapi.heyfive.cn"

        #else

        static let AppID = "23xQMdNUEbGSSWtLe4KsWLjo-gzGzoHsz"
        static let AppKey = "RjqVkooE2dCTTfYYOIyoFcN0"
        
        static let APIServerURL = "https://prod-leanapi.heyfive.cn"

        #endif
    }

    struct App {
        #if DEV

        /// 用户协议
        static let Agreement = "http://dev.heyfive.cn:10000/user_agreement/"
        /// 隐私政策
        static let PrivacyPolicy = "http://dev.heyfive.cn:10000/privacy_policy/"
        /// 图片指南
        static let PhotoIntroduce = "http://dev.heyfive.cn:10000/photo_introduce/"

        #elseif TEST

        static let Agreement = "http://dev.heyfive.cn:10000/user_agreement/"
        static let PrivacyPolicy = "http://dev.heyfive.cn:10000/privacy_policy/"
        static let PhotoIntroduce = "http://dev.heyfive.cn:10000/photo_introduce/"

        #else

        static let Agreement = "http://prod6.heyfive.cn:10000/user_agreement/"
        static let PrivacyPolicy = "http://prod6.heyfive.cn:10000/privacy_policy/"
        static let PhotoIntroduce = "http://prod6.heyfive.cn:10000/photo_introduce/"

        #endif
    }
}
