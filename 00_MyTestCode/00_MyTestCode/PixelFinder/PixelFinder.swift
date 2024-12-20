//
//  PixelFinder.swift
//  SwiftTest
//
//  Created by Zh on 2022/3/4.
//

import UIKit
import WebKit

enum WebviewLoadingStatus {
    case normal // 正常
    case error // 白屏
    case pend // 待决
    case scanPixelError(String) // 像素分析失败
}

public enum PixelResult<Value> {
    case success(Value)
    case failure(String)

    /// Returns `true` if the result is a success, `false` otherwise.
    public var isSuccess: Bool {
        switch self {
        case .success:
            return true
        case .failure:
            return false
        }
    }

    /// Returns `true` if the result is a failure, `false` otherwise.
    public var isFailure: Bool {
        return !isSuccess
    }

    /// Returns the associated value if the result is a success, `nil` otherwise.
    public var value: Value? {
        switch self {
        case .success(let value):
            return value
        case .failure:
            return nil
        }
    }

    /// Returns the associated error value if the result is a failure, `nil` otherwise.
    public var error: String? {
        switch self {
        case .success:
            return nil
        case .failure(let error):
            return error
        }
    }
}

class PixelFinder: NSObject {
    typealias handler = (PixelResult<Bool>) -> Void
    var zipScale: CGFloat = 1.0
    /// -----截取当前屏幕全屏-----
    func snapshotCurrentFullScreen() -> UIImage? {
        // 判断是否为retina屏, 即retina屏绘图时有放大因子
        guard let window = UIApplication.shared.windows.first else { return nil }
        if UIScreen.main.scale >= 2 {
            UIGraphicsBeginImageContextWithOptions(UIScreen.main.bounds.size, false, UIScreen.main.scale)
        } else {
            UIGraphicsBeginImageContext(UIScreen.main.bounds.size)
        }
        
        guard let content = UIGraphicsGetCurrentContext() else { return nil }
        window.layer.render(in: content)
        
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        
        UIGraphicsEndImageContext()

        // 保存到相册
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        return image
    }
    
    /// -----截取屏幕指定区域view-----
    public func snapshotScreenInView(contentView: UIView, targetRect: CGRect? = nil) -> CGImage? {
//        let size = contentView.bounds.size
//        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 300, height: 200))
        let targetBounds = targetRect ?? contentView.bounds
        let renderer = UIGraphicsImageRenderer(bounds: targetBounds)
//        let image = renderer.image { ctx in
////            let bounds = areaFrame ?? contentView.bounds
//            let bounds = contentView.bounds
//            contentView.drawHierarchy(in: bounds, afterScreenUpdates: true)
//        }
//        let cImage = cropImage(image) //image.cropToSize(rect: areaFrame ?? .zero)
        
//        let imgData = renderer.jpegData(withCompressionQuality: 0.2) { ctx in
//            let bounds = contentView.bounds
//            contentView.drawHierarchy(in: bounds, afterScreenUpdates: true)
//        }
//
//        guard let provider = CGDataProvider(data: imgData as CFData) else { return nil }
//        guard let cgImg = CGImage(jpegDataProviderSource: provider, decode: nil, shouldInterpolate: false, intent: .defaultIntent) else { return nil }
        
        let imgData = renderer.pngData { ctx in
            contentView.drawHierarchy(in: contentView.bounds, afterScreenUpdates: true)
        }
        guard let provider = CGDataProvider(data: imgData as CFData) else { return nil }
        guard let cgImg = CGImage(pngDataProviderSource: provider, decode: nil, shouldInterpolate: false, intent: .defaultIntent) else { return nil}
        
        let cImage = UIImage(cgImage: cgImg)
        UIImageWriteToSavedPhotosAlbum(cImage, nil, nil, nil)
        return cgImg
        
//        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
//        guard let content = UIGraphicsGetCurrentContext() else { return nil }
//        contentView.layer.render(in: content)
//        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
//        UIGraphicsEndImageContext()
//        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
//        return image
         
    }
    
    // 判断是否白屏
    func judgeLoadingStatus(webview: WKWebView, naviController: UINavigationController? = nil, completionHandler: @escaping (_ status: WebviewLoadingStatus) -> Void) {
        var status: WebviewLoadingStatus = .pend
        if #available(iOS 11.0, *) {
            if webview.isKind(of: WKWebView.self) {
                let statusBarHeight = UIApplication.shared.statusBarFrame.size.height //状态栏高度
                let navigationHeight = naviController?.navigationBar.frame.size.height ?? 0 //导航栏高度
                let shotConfiguration = WKSnapshotConfiguration()
                let x: CGFloat = 0
                let y = statusBarHeight + navigationHeight
                let w = webview.bounds.size.width
                let h = webview.bounds.size.height - navigationHeight - statusBarHeight
                shotConfiguration.rect = CGRect(x: x, y: y, width: w, height: h) //仅截图检测导航栏以下部分内容
                webview.takeSnapshot(with: shotConfiguration) { [weak self] snapshotImage, error in
                    guard let self = self else { return }
                    guard let image = snapshotImage else { return }
                    self.searchEveryPixel(image: image, color: .white, percent: 0.95) { result in
                        switch result {
                        case .success(let flag):
                            status = flag ? .error : .normal
                        case .failure(let errMsg):
                            status = .scanPixelError(errMsg)
                        }
                        completionHandler(status)
                    }
                }
            }
        }
    }
    
    // 遍历像素点
    
    func searchEveryPixel(image: UIImage, color: UIColor, percent: CGFloat = 0.95, tolerance: UInt8 = 0, result: @escaping handler) {
        let rgba = color.iNeedRGBA()
        searchEveryPixel(cgImage: image.cgImage, r: rgba.r, g: rgba.g, b: rgba.b, percent: percent, tolerance: tolerance, result: result)
    }
    
    func searchEveryPixel(image: UIImage, r: UInt8, g: UInt8, b: UInt8, percent: CGFloat = 0.95, tolerance: UInt8 = 0, result: @escaping handler) {
        searchEveryPixel(cgImage: image.cgImage, r: r, g: g, b: b, percent: percent, tolerance: tolerance, result: result)
    }
    
    func searchEveryPixel(cgImage: CGImage?, color: UIColor, percent: CGFloat = 0.95, tolerance: UInt8 = 0, result: @escaping handler) {
        let rgba = color.iNeedRGBA()
        searchEveryPixel(cgImage: cgImage, r: rgba.r, g: rgba.g, b: rgba.b, percent: percent, tolerance: tolerance, result: result)
    }
    
    func searchEveryPixel(cgImage: CGImage?, r: UInt8, g: UInt8, b: UInt8, percent: CGFloat = 0.95, tolerance: UInt8 = 0, result: @escaping handler) {
        //        var cImage = image
        //        if zipScale < 1.0 {
        //            cImage = self.scaleImage(image: image)
        //            print("cImage --- \(cImage)")
        //        }
        guard let cgImg = cgImage else {
            result(.failure("cgImage is nil !!!"))
            return
        }
        DispatchQueue.global().async {
            print("current thread --- \(Thread.current)")
            let width = cgImg.width
            let height = cgImg.height
            // 每一行像素的字节数
            let bytesPerRow = cgImg.bytesPerRow // 每个像素点包含 r g b a 四个字节
            // 每个像素所占的bit数
            let bitsPerPixel = cgImg.bitsPerPixel
            
            // 获取image开始字节的pointer
            
            guard let dataProvider = cgImg.dataProvider else {
                result(.failure("get dataProvider fail !!!"))
                return
            }
            let data = dataProvider.data
            guard let buffer = CFDataGetBytePtr(data) else {
                result(.failure("get buffer byte ptr fail !!!"))
                return
            }
            
            let rRange = self.targetRange(r, tolerance: tolerance)
            let gRange = self.targetRange(g, tolerance: tolerance)
            let bRange = self.targetRange(b, tolerance: tolerance)
            
            var targetCount = 0
            var totalCount = 0
            
            for j in 0 ..< height {
                for i in 0 ..< width {
                    let pt = buffer + j * bytesPerRow + i * (bitsPerPixel / 8)
                    let red   = pt
                    let green = pt + 1
                    let blue  = pt + 2
                    //            let alpha = *(pt + 3)
                    //                    print("r --- \(red.pointee), g -- \(green.pointee), b --- \(blue.pointee)")
                    totalCount += 1
                    if tolerance == 0 {
                        if red.pointee == r, green.pointee == g, blue.pointee == b {
                            targetCount += 1
                        }
                    } else {
                        if rRange.l <= red.pointee, red.pointee <= rRange.r,
                           gRange.l <= green.pointee, green.pointee <= gRange.r,
                           bRange.l <= blue.pointee, blue.pointee <= bRange.r {
                            targetCount += 1
                        }
                    }
                }
            }
            let proportion = CGFloat(targetCount) / CGFloat(totalCount)
            #if DEBUG
            print("当前像素点数: \(totalCount), 目标颜色像素点数: \(targetCount), 占比: \(String(format: "%.2f", proportion * 100))%")
            #endif
            if proportion > percent {
                result(.success(true))
            } else {
                result(.success(false))
            }
        }
    }
    
    private func targetRange(_ base: UInt8, tolerance: UInt8) -> (l: UInt8, r: UInt8) {
        let left = tolerance > base ? 0 : base - tolerance
        let right = base + tolerance
        return (left, right)
    }
    
    /// 缩放图片
    func scaleImage(image: UIImage) -> UIImage {
        let scale = zipScale
        var newsize: CGSize = .zero
        newsize.width = floor(image.size.width * scale)
        newsize.height = floor(image.size.height * scale)
        if #available(iOS 10.0, *) {
            let render = UIGraphicsImageRenderer(size: newsize)
            return render.image { rtc in
                image.draw(in: CGRect(x: 0, y: 0, width: newsize.width, height: newsize.height))
            }
        }else{
            return image
        }
    }
    
    private func cropImage(_ image: UIImage) -> UIImage {
        guard let source = image.cgImage else { return image }
        let size = image.size
        let imageFrame = UIScreen.main.bounds
        let cropRect = CGRect(x: 50, y: 50, width: 300, height: 300)
        var rect: CGRect = .zero
        rect.origin.x = (cropRect.origin.x - imageFrame.origin.x) / imageFrame.width * size.width
        rect.origin.y = (cropRect.origin.y - imageFrame.origin.y) / imageFrame.height * size.height
        rect.size.width = size.width * cropRect.width / imageFrame.width
        rect.size.height = size.height * cropRect.height / imageFrame.height
        
        guard let resultImage = source.cropping(to: rect) else { return image }
        return UIImage(cgImage: resultImage)
    }
}

//extension CGFloat {
//    func roundTo(places: Int) -> Double {
//        let divisor = pow(10.0, Double(places))
//        return (self * divisor).rounded() / divisor
//    }
//}

//————————————————
//版权声明：本文为CSDN博主「星星月亮0」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
//原文链接：https://blog.csdn.net/baidu_40537062/article/details/109643483

extension UIColor {
    // 获取某个颜色的 RGBA 值
    func iNeedRGBA() -> (r: UInt8, g: UInt8, b: UInt8, a: CGFloat) {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let red = UInt8(ceil(r * 255.0))
        let green = UInt8(ceil(g * 255.0))
        let blue = UInt8(ceil(b * 255.0))
        return (red, green, blue, a)
    }
}

extension UIImage {
    func cropToSize(rect: CGRect) -> UIImage {
        var newRect = rect
        newRect.origin.x *= self.scale
        newRect.origin.y *= self.scale
        newRect.size.width *= self.scale
        newRect.size.height *= self.scale
        let cgimage = self.cgImage?.cropping(to: newRect)
        let resultImage = UIImage(cgImage: cgimage!, scale: self.scale, orientation: self.imageOrientation)
        return resultImage
    }
}

/*
 1.截取当前屏幕全屏的实现方法

 #pragma mark  -----截取当前屏幕全屏-----
 - (UIImage *)snapshotCurrentFullScreen{
     
     // 判断是否为retina屏, 即retina屏绘图时有放大因子
     if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]){
         
         UIGraphicsBeginImageContextWithOptions(self.view.window.bounds.size, NO, [UIScreen mainScreen].scale);
         
     } else {
         
         UIGraphicsBeginImageContext(self.view.window.bounds.size);
         
     }
     
     [self.view.window.layer renderInContext:UIGraphicsGetCurrentContext()];
     
     UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
     
     UIGraphicsEndImageContext();
     
     // 保存到相册
     UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
     
     return image;
 }

 2、对指定区域view进行截取实现方法

 #pragma mark  -----截取屏幕指定区域view-----
 - (UIImage *)snapshotScreenInView:(UIView *)contentView{
     
     CGSize size = contentView.bounds.size;
     UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
     CGRect rect = contentView.frame;
     
     //  自iOS7开始，UIView类提供了一个方法-drawViewHierarchyInRect:afterScreenUpdates: 它允许你截取一个UIView或者其子类中的内容，并且以位图的形式（bitmap）保存到UIImage中
     [contentView drawViewHierarchyInRect:rect afterScreenUpdates:YES];
     
     UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
     UIGraphicsEndImageContext();
     UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
     
     return image;
 }

 作者：一滴水的生活
 链接：https://juejin.cn/post/6844903600850731022
 来源：稀土掘金
 著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。
 */

/*
 // 判断是否白屏
 - (void)judgeLoadingStatus:(WKWebview *)webview  withBlock:(void (^)(webviewLoadingStatus status))completionBlock{
     webviewLoadingStatus __block status = WebViewPendStatus;
     if (@available(iOS 11.0, *)) {
         if (webview && [webview isKindOfClass:[WKWebView class]]) {
             
             CGFloat statusBarHeight =  [[UIApplication sharedApplication] statusBarFrame].size.height; //状态栏高度
             CGFloat navigationHeight = webview.viewController.navigationController.navigationBar.frame.size.height; //导航栏高度
             WKSnapshotConfiguration *shotConfiguration = [[WKSnapshotConfiguration alloc] init];
             shotConfiguration.rect = CGRectMake(0, statusBarHeight + navigationHeight, webview.bounds.size.width, (webview.bounds.size.height - navigationHeight - statusBarHeight)); //仅截图检测导航栏以下部分内容
             [webview takeSnapshotWithConfiguration:shotConfiguration completionHandler:^(UIImage * _Nullable snapshotImage, NSError * _Nullable error) {
                 if (snapshotImage) {
                     CGImageRef imageRef = snapshotImage.CGImage;
                     UIImage * scaleImage = [self scaleImage:snapshotImage];
                     BOOL isWhiteScreen = [self searchEveryPixel:scaleImage];
                     if (isWhiteScreen) {
                        status = WebViewErrorStatus;
                     }else{
                        status = WebViewNormalStatus;
                     }
                 }
                 if (completionBlock) {
                     completionBlock(status);
                 }
             }];
         }
     }
 }

 // 遍历像素点 白色像素占比大于95%认定为白屏
 - (BOOL)searchEveryPixel:(UIImage *)image {
     CGImageRef cgImage = [image CGImage];
     size_t width = CGImageGetWidth(cgImage);
     size_t height = CGImageGetHeight(cgImage);
     size_t bytesPerRow = CGImageGetBytesPerRow(cgImage); //每个像素点包含r g b a 四个字节
     size_t bitsPerPixel = CGImageGetBitsPerPixel(cgImage);
     
     CGDataProviderRef dataProvider = CGImageGetDataProvider(cgImage);
     CFDataRef data = CGDataProviderCopyData(dataProvider);
     UInt8 * buffer = (UInt8*)CFDataGetBytePtr(data);
     
     int whiteCount = 0;
     int totalCount = 0;
     
     for (int j = 0; j < height; j ++ ) {
         for (int i = 0; i < width; i ++) {
             UInt8 * pt = buffer + j * bytesPerRow + i * (bitsPerPixel / 8);
             UInt8 red   = * pt;
             UInt8 green = *(pt + 1);
             UInt8 blue  = *(pt + 2);
 //            UInt8 alpha = *(pt + 3);
         
             totalCount ++;
             if (red == 255 && green == 255 && blue == 255) {
                 whiteCount ++;
             }
         }
     }
     float proportion = (float)whiteCount / totalCount ;
     NSLog(@"当前像素点数：%d,白色像素点数:%d , 占比: %f",totalCount , whiteCount , proportion );
     if (proportion > 0.95) {
         return YES;
     }else{
         return NO;
     }
 }

 //缩放图片
 - (UIImage *)scaleImage: (UIImage *)image {
     CGFloat scale = 0.2;
     CGSize newsize;
     newsize.width = floor(image.size.width * scale);
     newsize.height = floor(image.size.height * scale);
     if (@available(iOS 10.0, *)) {
         UIGraphicsImageRenderer * renderer = [[UIGraphicsImageRenderer alloc] initWithSize:newsize];
           return [renderer imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull rendererContext) {
                         [image drawInRect:CGRectMake(0, 0, newsize.width, newsize.height)];
                  }];
     }else{
         return image;
     }
 }

 作者：BBTime
 链接：https://juejin.cn/post/6885298718174609415
 来源：稀土掘金
 著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。
 */
