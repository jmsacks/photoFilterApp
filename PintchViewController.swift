//
//  PintchViewController.swift
//  PhotoFilters
//
//  Created by Joshua M. Sacks on 10/16/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//
//
//import UIKit
//
//class PintchViewController: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//    }
//
//    func pinchAction(pinch : UIPinchGestureRecognizer) {
//        println("hello")
//        
//        
//        if pinch.state == UIGestureRecognizerState.Ended {
//            println("ended")
//            println(pinch.velocity)
//            self.collectionView.performBatchUpdates({ () -> Void in
//                if pinch.velocity > 0 {
//                    self.flowlayout.itemSize = CGSize(width: self.flowlayout.itemSize.width * 2, height: self.flowlayout.itemSize.height * 2)
//                } else {
//                    self.flowlayout.itemSize = CGSize(width: self.flowlayout.itemSize.width * 0.5, height: self.flowlayout.itemSize.height * 0.5)
//                }
//                }, completion: nil )
//        }
//        
//    }}
