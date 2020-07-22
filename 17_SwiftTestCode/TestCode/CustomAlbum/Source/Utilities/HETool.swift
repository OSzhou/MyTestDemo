//
//  Tool.swift
//  SwiftPhotoSelector
//
//  Created by heyode on 2018/9/26.
//  Copyright (c) 2018 heyode <1025335931@qq.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.


import Foundation
import Photos
import UIKit

public class HETool: NSObject {
    
    var AssetGridThumbnailSize = CGSize(width: 80, height: 80)
    var customScreenScale: CGFloat = 2.0
    
    var photoPreviewMaxWidth: CGFloat = screenWidth {
        didSet {
            if photoPreviewMaxWidth > 800 {
                photoPreviewMaxWidth = 800
            } else if photoPreviewMaxWidth < 500 {
                photoPreviewMaxWidth = 500
            }
        }
    }
    
    static func canAccessPhotoLib() -> Bool {
        return PHPhotoLibrary.authorizationStatus() == .authorized
    }
    
    static func openIphoneSetting() {
        UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
    }
    static func requestAuthorizationForPhotoAccess(authorized: @escaping () -> Void, rejected: @escaping () -> Void) {
        PHPhotoLibrary.requestAuthorization { status in
            DispatchQueue.main.async {
                if status == .authorized {
                    authorized()
                } else {
                    rejected()
                }
            }
        }
    }
    
}

extension HETool {
    /// 同步加载图片
    public static func heRequestImage(for asset: PHAsset, targetSize: CGSize, contentMode: PHImageContentMode, resultHandler: @escaping (UIImage?, [AnyHashable : Any]?) -> Void) {
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        options.isNetworkAccessAllowed = true
        _ = heRequestImage(for: asset, targetSize: targetSize, contentMode: contentMode, options: options, resultHandler: resultHandler)
    }
    
    private static func heRequestImage(for asset: PHAsset, targetSize: CGSize, contentMode: PHImageContentMode, options: PHImageRequestOptions?, resultHandler: @escaping (UIImage?, [AnyHashable : Any]?) -> Void) -> PHImageRequestID{
        return PHCachingImageManager.default().requestImage(for:asset,
                                                            targetSize: targetSize,
                                                            contentMode: contentMode,
                                                            options: options, resultHandler:  resultHandler)
    }
    // column: 列数；margin: item之间的间距
    private func configScaleAndThumbnailSize(_ column: NSInteger, margin: CGFloat) {
        if screenWidth > 700 {
            customScreenScale = 1.5
        }
        let w = (screenWidth - CGFloat(column - 1) * margin) / CGFloat(column)
        AssetGridThumbnailSize = CGSize(width: w, height: w)
    }
    
    func wb_GetPhotoWithAsset(_ asset: PHAsset,
                              photoWidth: CGFloat,
                              networkAccessAllowed: Bool,
                              completion: @escaping ((UIImage?, [AnyHashable : Any]?, Bool) -> Void),
                              progressHandler: ((Double, Error?, Bool, [AnyHashable : Any]?) -> Void)?) {
        
        var imageSize = CGSize(width: 80, height: 80)
        if photoWidth < screenWidth && photoWidth < photoPreviewMaxWidth {
            imageSize = AssetGridThumbnailSize
        } else {
            
            let aspectRatio: CGFloat = CGFloat(asset.pixelWidth) / CGFloat(asset.pixelHeight)
            var pixelWidth: CGFloat = screenWidth * customScreenScale
            // 超宽图片
            if aspectRatio > 1.8 {
                pixelWidth = pixelWidth * aspectRatio
            }
            // 超高图片
            if aspectRatio < 0.2 {
                pixelWidth = pixelWidth * 0.5
            }
            
            let pixelHeight = pixelWidth / aspectRatio
            imageSize = CGSize(width: pixelWidth, height: pixelHeight)
        }
        
        HETool.wb_GetPhotoWithAsset(asset, targetSize: imageSize, networkAccessAllowed: networkAccessAllowed, completion: completion, progressHandler: progressHandler)
        
    }
    
    static func wb_GetPhotoWithAsset(_ asset: PHAsset,
                                            targetSize: CGSize,
                                            networkAccessAllowed: Bool,
                                            completion: @escaping ((UIImage?, [AnyHashable : Any]?, Bool) -> Void),
                                            progressHandler: ((Double, Error?, Bool, [AnyHashable : Any]?) -> Void)?) -> PHImageRequestID {
        let option = PHImageRequestOptions()
        option.resizeMode = .fast
        let requestID = heRequestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: option, resultHandler: { (image, info) in
            guard let dict = info else { return }
            let downloadFinined = dict[PHImageCancelledKey] == nil && dict[PHImageErrorKey] == nil
            if downloadFinined, let result = image {
                completion(result, info, dict[PHImageResultIsDegradedKey] as! Bool)
            }
            // Download image from iCloud / 从iCloud下载图片
            if (dict[PHImageResultIsInCloudKey] != nil), image == nil, networkAccessAllowed {
                let options = PHImageRequestOptions()
                options.isNetworkAccessAllowed = true
                options.resizeMode = .fast
                options.progressHandler = { (progress, error, stop, info) in
                    DispatchQueue.main.async {
                        print("iCloud error -- \(String(describing: error)) progress --- \(progress)" )
                        progressHandler?(progress, error, stop.pointee.boolValue, info)
                    }
                }
                PHImageManager.default().requestImageData(for: asset, options: options) { (imageData, _, _, info) in
                    if let data = imageData {
                        if let resultImage = UIImage(data: data, scale: 0.1) {
                            let realImage = scaleImage(resultImage, size: targetSize)//.fixOrientation()
                            completion(realImage, info, false)
                        }
                    }
                }
            }
        })
        return requestID
    }
    
    static func scaleImage(_ image: UIImage, size: CGSize) -> UIImage {
        if image.size.width > size.width {
            UIGraphicsBeginImageContext(size)
            image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            if let  newImage = UIGraphicsGetImageFromCurrentImageContext() {
                return newImage
            }
            UIGraphicsEndImageContext()
            return image
        } else {
            return image
        }
    }
    // 获取封面
    static func wb_GetPostPhotoWithAsset(_ asset: PHAsset,
                                         targetSize: CGSize,
                                         networkAccessAllowed: Bool = true,
                                         completion: @escaping ((UIImage?, [AnyHashable : Any]?, Bool) -> Void)) -> PHImageRequestID {
        return wb_GetPhotoWithAsset(asset, targetSize: targetSize, networkAccessAllowed: networkAccessAllowed, completion: completion, progressHandler: nil)
    }
    
    // data: image data, bool: 是否小于2kb (异步)
    public static func wb_RequestImageDataAsync(_ asset: PHAsset, resultHandler: @escaping (Data?, Bool) -> Void){
        wb_RequestImageData(asset, options: nil, resultHandler: resultHandler)
    }
    
    // data: image data, bool: 是否小于2kb (同步)
    public static func wb_RequestImageDataSync(_ asset: PHAsset, resultHandler: @escaping (Data?, Bool) -> Void){
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        options.isNetworkAccessAllowed = true
        wb_RequestImageData(asset, options: options, resultHandler: resultHandler)
    }
    
    private static func wb_RequestImageData(_ asset: PHAsset, options: PHImageRequestOptions?, resultHandler: @escaping (Data?, Bool) -> Void){
            //图片大小: 过滤 小于 2kb的图片
            PHCachingImageManager.default().requestImageData(for: asset, options: options) { (imageData, _, _, _) in
                if let data = imageData, data.count < 2048 {
                    resultHandler(imageData, true)
                    print("image data length less than 2kb --- \(data.count)")
                } else {
                    resultHandler(imageData, false)
                }
    //            logger.debug("image data length --- \(imageData?.count)")
            }
        }
    
}
