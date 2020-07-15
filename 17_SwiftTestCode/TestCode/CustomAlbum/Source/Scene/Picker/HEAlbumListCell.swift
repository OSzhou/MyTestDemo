//
//  HEAlbumListCell.swift
//  HEPhotoPicker
//
//  Created by heyode on 2018/10/25.
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



import UIKit
import Photos
class HEAlbumListCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(albumImageView)
        contentView.addSubview(titleLab)
        contentView.addSubview(countLab)
    }
    
    var album : HEAlbum!{
        didSet{
            titleLab.text = album.title
            countLab.text = String.init(format: "%d", album.count)
            let scale = UIScreen.main.scale / 2
            let size = CGSize.init(width: albumImageView.frame.width * scale, height:albumImageView.frame.height * scale)
            guard let asset = album.fetchResult.firstObject else{return}
            HETool.heRequestImage(for:asset,
                                                  targetSize: size,
                                                  contentMode: .aspectFill, resultHandler:  { image, _ in
                                                    self.albumImageView.image = image
            })
          
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        albumImageView.frame = CGRect(x: 20, y: (self.frame.height - 50) / 2, width: 50, height: 50)
        titleLab.frame = CGRect(x: albumImageView.frame.maxX + 10, y: (self.frame.height - 20) / 2, width: kScreenWidth / 2.0, height: 20)
        countLab.frame = CGRect(x: titleLab.frame.maxX + 10, y: (self.frame.height - 20) / 2, width: kScreenWidth / 2.0, height: 20)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    /// MARK: --- lazy loading
    lazy var countLab: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14.0)
        return label
    }()
    
    lazy var titleLab: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18.0)
        return label
    }()
    
    lazy var albumImageView: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
}
