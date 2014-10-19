//
//  ViewController.swift
//  PhotoFilters
//
//  Created by Bradley Johnson on 10/13/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

import UIKit
import CoreImage
import CoreData
import OpenGLES
import AssetsLibrary



class ViewController: UIViewController, GalleryDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!

    @IBOutlet weak var imageView: UIImageView!
    var context : CIContext?
    var originalThumbnail : UIImage?
    let imageQueue = NSOperationQueue()
    var filterThumbnails = [FilterThumbnail]()
    var filters = [Filter]()
    var networkController : NetworkController!
    
    @IBOutlet weak var imageViewToSuperViewHeightMultiplier: NSLayoutConstraint!

    @IBOutlet weak var imageViewToSuperViewWidthMultiplier: NSLayoutConstraint!
    
    @IBOutlet weak var filterViewHeightConstant: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // var image = UIImage(named: "photo2.jpg")
        var appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
//        var testFilter = NSEntityDescription.insertNewObjectForEntityForName("Filter", inManagedObjectContext: appDelegate.managedObjectContext!) as Filter
//        testFilter.name = "CIColorInvert"
        self.generateThumbnail()
        var options = [kCIContextWorkingColorSpace : NSNull()]
        var myEAGLContext = EAGLContext(API: EAGLRenderingAPI.OpenGLES2)
        self.context = CIContext(EAGLContext: myEAGLContext, options: options)
        self.imageView.contentMode  = UIViewContentMode.ScaleAspectFit
        
        
       // var appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        var seeder = CoreDataSeeder(context: appDelegate.managedObjectContext!)
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        seeder.seedCoreData()
        self.fetchFilters()
        self.resetFilterThumbnails()
//        self.filters.append("CISepiaTone")
//        self.filters.append("CIGaussianBlur")
//        self.filters.append("CIGammaAdjust")
//        self.filters.append("CIGlassDistortion")
        
        
    }
    
    
    func enterFilterMode() {

           self.filterViewHeightConstant.constant = 0
   
        UIView.animateWithDuration(0.4, animations: { () -> Void in
                  self.view.layoutIfNeeded()
                })
        
                var doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: "exitFilteringMode")
                self.navigationItem.rightBarButtonItem = doneButton
            }
    
        func exitFilteringMode () {
        
                //reset the contraints back to normal values
                //remove the Done button
                self.navigationItem.rightBarButtonItem = nil
            self.filterViewHeightConstant.constant = -200
            
            UIView.animateWithDuration(0.4, animations: { () -> Void in
                self.view.layoutIfNeeded()
            })
           }
    
    func generateThumbnail(){
            let size = CGSize(width: 100, height: 100)
            UIGraphicsBeginImageContext(size)
            self.imageView.image?.drawInRect(CGRect(x: 0, y: 0, width: 100, height: 100))
            self.originalThumbnail = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SHOW_GALLERY" {
            let destinationVC = segue.destinationViewController as GalleryViewController
            destinationVC.delegate = self
           // destinationVC.myParentViewController = self
        }
        else if segue.identifier == "SHOW_PHOTO_FRAMEWORK" {
            let destinationVC = segue.destinationViewController as PhotoFrameworkViewController
            destinationVC.delegate = self
            // destinationVC.myParentViewController = self
        }
    }
    @IBAction func menuPressed(sender: AnyObject) {
        
        let alertController = UIAlertController(title: nil, message: "Choose an option", preferredStyle: UIAlertControllerStyle.ActionSheet)
        let galleryAction = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.Default) { (action) -> Void in
            self.performSegueWithIdentifier("SHOW_GALLERY", sender: self)}
        let filterAction = UIAlertAction(title: "Filters", style: UIAlertActionStyle.Default) {(action) -> Void in self.enterFilterMode()}
        let photoFrameWorkAction = UIAlertAction(title: "Photo Frame Work", style: UIAlertActionStyle.Default) {(action) -> Void in self.performSegueWithIdentifier("SHOW_PHOTO_FRAMEWORK", sender: self)}
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (action) -> Void in
        }
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default) { (action) -> Void in
            let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = true
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
                
            }
            imagePicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
            imagePicker.delegate = self
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
        let savePhotoAction = UIAlertAction(title: "Save Photo", style: UIAlertActionStyle.Default) {(action) -> Void in self.savePhotoMode()}
        alertController.addAction(galleryAction)
        alertController.addAction(cancelAction)
        alertController.addAction(cameraAction)
        alertController.addAction(filterAction)
        alertController.addAction(photoFrameWorkAction)
        alertController.addAction(savePhotoAction)
          self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        self.imageView.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func didTapOnPicture(image : UIImage) {
        println("did tap on picture")
        self.imageView.image = image
        self.generateThumbnail()
        self.resetFilterThumbnails()
        self.collectionView.reloadData()
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.filters.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("FILTER_CELL", forIndexPath: indexPath) as filterCellCollectionViewCell
        var filterThumbnail = self.filterThumbnails[indexPath.row]
        //lazing loading
        if filterThumbnail.filteredThumbnail != nil {
            cell.filterImageView.image = filterThumbnail.filteredThumbnail
        } else {
            cell.filterImageView.image = filterThumbnail.originalThumbnail
            filterThumbnail.generateThumbnail({ (image) -> Void in
                
                if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? filterCellCollectionViewCell {
                    cell.filterImageView.image = image
                }
            })
        }
        //        var filterThumbnail = FilterThumbnail(name: self.filterNames[indexPath.row], thumbnail: self.originalThumbnail!, queue: self.imageQueue, context: self.context!)
        //        filterThumbnail.generateThumbnail { (image) -> Void in
        //            cell.imageView.image = image
        //
        //cell.imageView.image = self.originalThumbnail
        return cell
    }
    
    func fetchFilters() {
        var fetchRequest = NSFetchRequest(entityName: "Filter")
        
        var appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        var context = appDelegate.managedObjectContext
        
        var error: NSError?
        let fetchResults = context?.executeFetchRequest(fetchRequest, error: &error)
        if let filters = fetchResults as? [Filter] {
            println("filters: \(filters.count)")
            self.filters = filters
        }
    }
    
    func resetFilterThumbnails () {
        var newFilters = [FilterThumbnail]()
        for var index = 0; index < self.filters.count; ++index {
            var filter = self.filters[index]
            var filterName = filter.name
            var thumbnail = FilterThumbnail(name: filterName, thumbnail: self.originalThumbnail!, queue: self.imageQueue, context: self.context!)
            newFilters.append(thumbnail)
        }
        self.filterThumbnails = newFilters
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        var chosenFilter = filterThumbnails[indexPath.row]
        self.imageView.image = chosenFilter.filteredThumbnail
    }
    
    func savePhotoMode () {
        let imageToSave = self.imageView.image?.CGImage
        let library = ALAssetsLibrary()
        library.writeImageToSavedPhotosAlbum(imageToSave, metadata: nil, completionBlock: nil)
        let photoSavedAlert = UIAlertView(title: "", message: "Photo successfully saved", delegate: nil, cancelButtonTitle: "OK")
        photoSavedAlert.show()
        //TO-DO: Write a checking/error handeling mechanism to ensure photo save actually does happen 
    }
    
    func postPhotoToFaceBook () {
        //TO-DO Create function to call network Controller to post image to FB wall
    }

}

