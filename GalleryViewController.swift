//
//  GalleryViewController.swift
//  PhotoFilters
//
//  Created by Bradley Johnson on 10/13/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

import UIKit

protocol GalleryDelegate : class {
    func didTapOnPicture(image : UIImage)
}

class GalleryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
 //   @IBOutlet weak var headerViewTitle: UILabel!
 //   @IBOutlet weak var footerViewTitle: UILabel!

    @IBAction func cancelButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var delegate: GalleryDelegate?
//    var myParentViewController : ViewController?
//    var myProfileParentViewController : ProfileViewController
    
    var images = [UIImage]()
    var imageTitles = [String]()
    var flowlayout : UICollectionViewFlowLayout!
    var pinchAction = PinchOperation ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self  
        
        var image1 = UIImage(named: "photo2.jpg")
        var image1Title = String ("Image1")
        var image2 = UIImage(named: "photo3.jpg")
        var image2Title = String ("Image2")
        var image3 = UIImage(named: "photo4.jpg")
        var image3Title = String ("Image3")
        var image4 = UIImage(named: "photo5.jpg")
        var image4Title = String ("Image4")
        
        self.images.append(image1)
        self.images.append(image2)
        self.images.append(image3)
        self.images.append(image4)
        self.imageTitles.append(image1Title)
        self.imageTitles.append(image2Title)
        self.imageTitles.append(image3Title)
        self.imageTitles.append(image4Title)
        
        self.flowlayout = self.collectionView.collectionViewLayout as UICollectionViewFlowLayout
        // Do any additional setup after loading the view, typically from a nib.
        
       // var pinch = UIPinchGestureRecognizer(target: self, action: "pinchAction:")
       // self.collectionView.addGestureRecognizer(pinch)
        self.pinchAction.collectionView = self.collectionView
        self.pinchAction.flowLayout = self.flowlayout
        var pinchRecognizer = UIPinchGestureRecognizer(target: pinchAction, action: "pinchAction:")
        self.collectionView.addGestureRecognizer(pinchRecognizer)

        // Do any additional setup after loading the view.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("GALLERY_CELL", forIndexPath: indexPath) as GalleryCell
        //cell.backgroundColor = UIColor.purpleColor()
        cell.imageView.image = self.images[indexPath.row]
        cell.photoTitle.text = self.imageTitles[indexPath.row]
        return cell
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//        println("indexpath: \(indexPath)")
        self.delegate?.didTapOnPicture(self.images[indexPath.row])
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        if (kind == UICollectionElementKindSectionHeader) {
            var headerView: HeaderFooterCollectionReusableView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "headerView", forIndexPath: indexPath) as HeaderFooterCollectionReusableView
            headerView.viewTitle.text = String ("Perty Pictures")
            return headerView
        }
        
        else {
            var footerView: FooterCollectionReusableView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionFooter, withReuseIdentifier: "footerView", forIndexPath: indexPath) as FooterCollectionReusableView
            footerView.footerTitle.text = String ("Choose from \(self.images.count) photos above")
            return footerView
        }
        
        }
        }

    
    

