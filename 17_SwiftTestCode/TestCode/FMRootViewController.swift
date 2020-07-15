//
//  FMRootViewController.swift
//  TestCode
//
//  Created by Zhouheng on 2020/6/3.
//  Copyright © 2020 tataUFO. All rights reserved.
//

import UIKit

// MARK: 屏幕高度
let screenHeight: CGFloat = UIScreen.main.bounds.height
// MARK: 屏幕宽度
let screenWidth: CGFloat = UIScreen.main.bounds.width

class FMRootViewController: UIViewController {
    
    var selectedModel = [HEPhotoAsset]()
    var visibleImages = [UIImage](){
        didSet{
            if oldValue != visibleImages {
//                collectionView.reloadData()
            }
        }
    }
    
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
        view.addSubview(popButton)
    }

    /// MARK: --- action
    @objc private func toMagnifyView(_ sender: UIButton) {
        self.navigationController?.pushViewController(FMMagnifyViewController(), animated: true)
    }
    
    @objc private func customCamera(_ sender: UIButton) {
        self.navigationController?.pushViewController(FMCustomCameraViewController(), animated: true)
    }
    
    @objc private func customAlbum(_ sender: UIButton) {
        
        let options = HEPickerOptions.init()
//        options.ascendingOfCreationDateSort = true
        
        options.singlePicture = true//pickturSwitch.isOn
//        options.singleVideo = videoSwitch.isOn

            options.mediaType = .image

//            options.mediaType = .video
//
//            options.mediaType = .imageAndVideo
//
//            options.mediaType = .imageOrVideo

        options.defaultSelections = nil
        
        options.maxCountOfImage = 1
//        options.maxCountOfVideo = videoCount
        let picker = HEPhotoPickerViewController.init(delegate: self, options: options)
        hePresentPhotoPickerController(picker: picker, animated: true)
        
    }
    
    @objc private func other(_ sender: UIButton) {
        self.navigationController?.pushViewController(MeetupContainerViewController(), animated: true)
    }
    
    @objc private func popAction(_ sender: UIButton) {
        
        let imageName = "play-btn"
        let title = "恭喜！连续工作加成提升至啦~"
        let detail =  "现在工作可以获得更多的工资啦，连续工作天数越多，对应的加成越高"
        let confirmTitle = "确认"
        
        let view = WBImageTitleDetailAlertView(image: UIImage(named: imageName),
                                               title: title,
                                               detail: detail,
                                               confirmTitle: confirmTitle,
                                               cancelTitle: "取消")
        view.confirmClick = { [weak self] in
            guard let self = self else { return }
        }
        
        view.show()
    }
    
    /// MARK: --- lazy loading
    lazy var magnifyButton: UIButton = {
        let button = UIButton(frame: CGRect(x: (screenWidth - 200) / 2, y: 88 + 50, width: 200, height: 50))
        button.setTitle("取景框", for: .normal)
        button.addTarget(self, action: #selector(toMagnifyView(_:)), for: .touchUpInside)
        button.backgroundColor = .gray
        return button
    }()
    
    lazy var cameraButton: UIButton = {
        let button = UIButton(frame: CGRect(x: (screenWidth - 200) / 2, y: 88 + 110, width: 200, height: 50))
        button.setTitle("自定义相机", for: .normal)
        button.addTarget(self, action: #selector(customCamera(_:)), for: .touchUpInside)
        button.backgroundColor = .gray
        return button
    }()
    
    lazy var albumButton: UIButton = {
        let button = UIButton(frame: CGRect(x: (screenWidth - 200) / 2, y: 88 + 170, width: 200, height: 50))
        button.setTitle("自定义相册", for: .normal)
        button.addTarget(self, action: #selector(customAlbum(_:)), for: .touchUpInside)
        button.backgroundColor = .gray
        return button
    }()
    
    lazy var otherButton: UIButton = {
        let button = UIButton(frame: CGRect(x: (screenWidth - 200) / 2, y: 88 + 230, width: 200, height: 50))
        button.setTitle("其它", for: .normal)
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
}

extension FMRootViewController : HEPhotoPickerViewControllerDelegate{
    func pickerController(_ picker: UIViewController, didFinishPicking selectedImages: [UIImage],selectedModel:[HEPhotoAsset]) {
        // 实现多次累加选择时，需要把选中的模型保存起来，传给picker
        self.selectedModel = selectedModel
        self.visibleImages = selectedImages
   
    }
    func pickerControllerDidCancel(_ picker: UIViewController) {
        // 取消选择后的一些操作
    }
    
}

//extension FMRootViewController: HEPhotoBrowserAnimatorPushDelegate {
//
//    public func imageViewRectOfAnimatorStart(at indexPath: IndexPath) -> CGRect {
//        // 获取指定cell的laout
//        let cellLayout = collectionView.layoutAttributesForItem(at: indexPath)
//        let homeFrame =  UIApplication.shared.keyWindow?.convert(cellLayout?.frame ??  CGRect.zero, from: collectionView) ?? CGRect.zero
//        //返回具体的尺寸
//        return homeFrame
//    }
//    public func imageViewRectOfAnimatorEnd(at indexPath: IndexPath) -> CGRect {
//        //取出cell
//        let cell = (collectionView.cellForItem(at: indexPath))! as! MasterCell
//        //取出cell中显示的图片
//        let image = cell.imageView.image
//        let x: CGFloat = 0
//        let width: CGFloat = kScreenWidth
//        let height: CGFloat = width / (image!.size.width) * (image!.size.height)
//        var y: CGFloat = 0
//        if height < kScreenHeight {
//            y = (kScreenHeight -   height) * 0.5
//        }
//        //计算方法后的图片的frame
//        return CGRect(x: x, y: y, width: width, height: height)
//
//    }
//    public func imageView(at indexPath: IndexPath) -> UIImageView {
//        //创建imageView对象
//        let imageView = UIImageView()
//        //取出cell
//        let cell = (collectionView.cellForItem(at: indexPath))! as! MasterCell
//        //取出cell中显示的图片
//        let image = cell.imageView.image
//        //设置imageView相关属性(拉伸模式)
//        imageView.contentMode = .scaleAspectFit
//        //设置图片
//        imageView.image = image
//        //将多余的部分裁剪
//        imageView.clipsToBounds = true
//        //返回图片
//        return imageView
//    }
//}
