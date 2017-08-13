//
//  MomentsViewController.swift
//  PhotoBrowser
//
//  Created by JiongXing on 2017/3/9.
//  Copyright © 2017年 JiongXing. All rights reserved.
//

import UIKit
import SDWebImage
import JXPhotoBrowser

class MomentsViewController: UIViewController {
    
    fileprivate lazy var thumbnailImageUrls: [String] = {
        return ["http://wx1.sinaimg.cn/thumbnail/bfc243a3gy1febm7n9eorj20i60hsann.jpg",
                "http://wx3.sinaimg.cn/thumbnail/bfc243a3gy1febm7nzbz7j20ib0iek5j.jpg",
                "http://wx1.sinaimg.cn/thumbnail/bfc243a3gy1febm7orgqfj20i80ht15x.jpg",
                "http://wx2.sinaimg.cn/thumbnail/bfc243a3gy1febm7pmnk7j20i70jidwo.jpg",
                "http://wx3.sinaimg.cn/thumbnail/bfc243a3gy1febm7qjop4j20i00hw4c6.jpg",
                "http://wx4.sinaimg.cn/thumbnail/bfc243a3gy1febm7rncxaj20ek0i74dv.jpg",
                "http://wx2.sinaimg.cn/thumbnail/bfc243a3gy1febm7sdk4lj20ib0i714u.jpg",
                "http://wx4.sinaimg.cn/thumbnail/bfc243a3gy1febm7tekewj20i20i4aoy.jpg",
                "http://wx3.sinaimg.cn/thumbnail/bfc243a3gy1febm7usmc8j20i543zngx.jpg",]
    }()
    
    fileprivate lazy var highQualityImageUrls: [String] = {
        return ["http://wx1.sinaimg.cn/large/bfc243a3gy1febm7n9eorj20i60hsann.jpg",
                "http://wx3.sinaimg.cn/large/bfc243a3gy1febm7nzbz7j20ib0iek5j.jpg",
                "http://wx1.sinaimg.cn/large/bfc243a3gy1febm7orgqfj20i80ht15x.jpg",
                "http://wx2.sinaimg.cn/large/bfc243a3gy1febm7pmnk7j20i70jidwo.jpg",
                "http://wx3.sinaimg.cn/large/bfc243a3gy1febm7qjop4j20i00hw4c6.jpg",
                "http://wx4.sinaimg.cn/large/bfc243a3gy1febm7rncxaj20ek0i74dv.jpg",
                "http://wx2.sinaimg.cn/large/bfc243a3gy1febm7sdk4lj20ib0i714u.jpg",
                "http://wx4.sinaimg.cn/large/bfc243a3gy1febm7tekewj20i20i4aoy.jpg",
                "http://wx3.sinaimg.cn/large/bfc243a3gy1febm7usmc8j20i543zngx.jpg",]
    }()
    
    weak fileprivate var selectedCell: MomentsPhotoCollectionViewCell?
    
    fileprivate var collectionView: UICollectionView?
    
    deinit {
        #if DEBUG
            print("deinit:\(self)")
        #endif
    }
    
    override func viewDidLoad() {
        let colCount = 3
        let rowCount = 3
        
        let xMargin: CGFloat = 60.0
        let interitemSpacing: CGFloat = 10.0
        let width: CGFloat = self.view.bounds.size.width - xMargin * 2
        let itemSize: CGFloat = (width - 2 * interitemSpacing) / CGFloat(colCount)
        
        let lineSpacing: CGFloat = 10.0
        let height = itemSize * CGFloat(rowCount) + lineSpacing * 2
        let y: CGFloat = 60.0
        
        let frame = CGRect(x: xMargin, y: y, width: width, height: height)
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = lineSpacing
        layout.minimumInteritemSpacing = interitemSpacing
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        layout.scrollDirection = .vertical
        
        let cv = UICollectionView(frame: frame, collectionViewLayout: layout)
        cv.register(MomentsPhotoCollectionViewCell.self, forCellWithReuseIdentifier: MomentsPhotoCollectionViewCell.defalutId)
        
        view.addSubview(cv)
        
        cv.dataSource = self
        cv.delegate = self
        cv.backgroundColor = UIColor.white
        collectionView = cv
    }
}

extension MomentsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return thumbnailImageUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MomentsPhotoCollectionViewCell.defalutId, for: indexPath) as! MomentsPhotoCollectionViewCell
        cell.imageView.sd_setImage(with: URL(string: thumbnailImageUrls[indexPath.row]))
        return cell
    }
}

extension MomentsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? MomentsPhotoCollectionViewCell else {
            return
        }
        selectedCell = cell
        // 调起图片浏览器
        let vc = PhotoBrowser(showByViewController: self, delegate: self)
        // 装配PageControl，提供了两种PageControl实现，若需要其它样式，可参照着自由定制
        if arc4random_uniform(2) % 2 == 0 {
            vc.pageControlDelegate = PhotoBrowserDefaultPageControlDelegate(numberOfPages: thumbnailImageUrls.count)
        } else {
            vc.pageControlDelegate = PhotoBrowserNumberPageControlDelegate(numberOfPages: thumbnailImageUrls.count)
        }
        vc.show(index: indexPath.item)
    }
}

// 实现浏览器代理协议
extension MomentsViewController: PhotoBrowserDelegate {
    func numberOfPhotos(in photoBrowser: PhotoBrowser) -> Int {
        return thumbnailImageUrls.count
    }
    
    /// 缩放起始视图
    func photoBrowser(_ photoBrowser: PhotoBrowser, thumbnailViewForIndex index: Int) -> UIView? {
        return collectionView?.cellForItem(at: IndexPath(item: index, section: 0))
    }
    
    /// 图片加载前的placeholder
    func photoBrowser(_ photoBrowser: PhotoBrowser, thumbnailImageForIndex index: Int) -> UIImage? {
        let cell = collectionView?.cellForItem(at: IndexPath(item: index, section: 0)) as? MomentsPhotoCollectionViewCell
        // 取thumbnailImage
        return cell?.imageView.image
    }
    
    /// 高清图
    func photoBrowser(_ photoBrowser: PhotoBrowser, highQualityUrlForIndex index: Int) -> URL? {
        return URL(string: highQualityImageUrls[index])
    }
    
    /// 最高清图，原图
    func photoBrowser(_ photoBrowser: PhotoBrowser, rawUrlForIndex index: Int) -> URL? {
        return nil
//        // 测试
//        return index == 2 ? URL(string: "https://b-ssl.duitang.com/uploads/item/201501/28/20150128173439_RK4XS.jpeg") : nil
    }
    
    func photoBrowser(_ photoBrowser: PhotoBrowser, didLongPressForIndex index: Int, image: UIImage) {
        print("长按，图片size:\(image.size)")
    }
}


