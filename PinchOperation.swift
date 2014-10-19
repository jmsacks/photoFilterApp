//
//  PinchOperation.swift
//  PhotoFilters
//
//  Created by Joshua M. Sacks on 10/16/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

import UIKit


class PinchOperation: NSObject {

    var collectionView : UICollectionView?
    var flowLayout : UICollectionViewFlowLayout?
    
    override init() {
    }
    
    
    func pinchAction(pinch : UIPinchGestureRecognizer) {
        println ("enterd Pinch action")
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        println("ended")
        println(pinch.velocity)
        var pinchScale = pinch.scale
        self.collectionView!.performBatchUpdates({ () -> Void in
            if pinchScale > 1 {
                if (self.flowLayout!.itemSize.width * pinchScale <  screenSize.width) {
                    
                    self.flowLayout!.itemSize = CGSize(width: self.flowLayout!.itemSize.width * pinchScale, height: self.flowLayout!.itemSize.height * pinchScale) }
            } else {
                
                if self.flowLayout!.itemSize.width * pinchScale > 10 {
                    
                    self.flowLayout!.itemSize = CGSize(width: self.flowLayout!.itemSize.width * pinchScale, height: self.flowLayout!.itemSize.height * pinchScale)
                }
            } }, completion: nil )
    }

}
