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
    
    // data: image data, bool: 是否小于2kb
    public static func heRequestImageData(_ asset: PHAsset, resultHandler: @escaping (Data?, Bool) -> Void){
        //图片大小: 过滤 小于 2kb的图片
        PHCachingImageManager.default().requestImageData(for: asset, options: nil) { (imageData, _, _, _) in
            if let data = imageData, data.count < 2048 {
                resultHandler(imageData, true)
                print("image data length less than 2kb --- \(data.count)")
            } else {
                resultHandler(nil, false)
            }
        }
    }
}
