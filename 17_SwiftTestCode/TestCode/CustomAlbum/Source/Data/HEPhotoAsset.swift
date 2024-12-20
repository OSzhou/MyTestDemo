//
//  HEPhotoAsset.swift
//  SwiftPhotoSelector
//
//  Created by heyode on 2018/9/22.
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
public class HEPhotoAsset : NSObject{
    /// 是否选中
    public  var isSelected = false
    /// 是否显示可选按钮
    public var isEnableSelected = true
    /// 是否可点击
    public  var isEnable = true
    /// 图片集合
    public var asset = PHAsset()
    /// 照片在指定相册中的索引（同一张照片在不同相册中索引不同）
    public  var index : Int = 0
    /// 选中的图片时第几张
    var selecteIndex: Int = 0
    public init(asset:PHAsset) {
        self.asset = asset
    }
    public override init() {
        super.init()
    }
    
}
