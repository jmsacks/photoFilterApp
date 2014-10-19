//
//  PhotoFrameworkViewController.swift
//  PhotoFilters
//
//  Created by Joshua M. Sacks on 10/15/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

import UIKit
import Photos

protocol PhotoFrameworkGalleryDelegate : class {
    func didTapOnPicture(image : UIImage)
}

class PhotoFrameworkViewController: UIViewController, UICollectionViewDataSource {

    @IBOutlet var photoFrameWorkCollectionVew: UICollectionView!
    var assetFetchResults: PHFetchResult!
    var assetCollection: PHAssetCollection!
    var imageManager: PHCachingImageManager!
    var assetCellSize: CGSize!
    var assetLargeImageSize: CGSize?
    weak var delegate: GalleryDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Get image image, asset fetch results
        self.imageManager = PHCachingImageManager()
        
        // Pass nil, fetch all assets
        self.assetFetchResults = PHAsset.fetchAssetsWithOptions(nil)
        println("View did load FetchResults are \(self.assetFetchResults.count)")
        
        // Determine device scale, adjust asset cell size
        var scale = UIScreen.mainScreen().scale
        var flowLayout = self.photoFrameWorkCollectionVew.collectionViewLayout as UICollectionViewFlowLayout
        
        var cellSize = flowLayout.itemSize
        self.assetCellSize = CGSizeMake(cellSize.width * scale, cellSize.height * scale)
    }
    
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
                let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PHOTOS_CELL", forIndexPath: indexPath) as PhotoFrameworkCollectionViewCell
                var currentTag = cell.tag + 1
                cell.tag = currentTag
        
                var asset = self.assetFetchResults[indexPath.row] as PHAsset
        
    self.imageManager.requestImageForAsset(asset, targetSize: self.assetCellSize, contentMode: PHImageContentMode.AspectFill, options: nil) { (image, info) -> Void in
        
                    if cell.tag == currentTag {
                        cell.imageView.image = image
                    }
                }
              //  self.imageManager.
                return cell
    }
    
    
    func collectionView(photoFrameWorkCollectionVew: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        println("FetchResults are \(self.assetFetchResults.count)")
        return self.assetFetchResults.count
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
               println("indexpath: \(indexPath)")
        //let cell = collectionView.cellForItemAtIndexPath(indexPath) as PhotoFrameworkCollectionViewCell
        //var scale = UIScreen.mainScreen().scale
        var asset = self.assetFetchResults[indexPath.row] as PHAsset
        
        self.imageManager.requestImageForAsset(asset, targetSize: self.assetCellSize, contentMode: PHImageContentMode.AspectFill, options: nil) { (image, info) -> Void in
           //var placeholder = image
            println("anything1")
           // let image = UIImage (named: "photo2.jpg")
            self.delegate?.didTapOnPicture(image)
        }
            // cell.imageView.image = image }
            
            
            
        //self.delegate?.didTapOnPicture(cell.imageView.image!)}
        self.navigationController?.popViewControllerAnimated(true)
        //dismissViewControllerAnimated(true, completion: nil)
    }

}

