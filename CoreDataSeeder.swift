//
//  CoreDataSeeder.swift
//  PhotoFilters
//
//  Created by Joshua M. Sacks on 10/14/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

import Foundation
import CoreData

class CoreDataSeeder {
    var managedObjectContext: NSManagedObjectContext!
    var error: NSError?
    
    init(context: NSManagedObjectContext) {
        self.managedObjectContext = context
    }
    
    func seedCoreData() {
        var fetchRequest = NSFetchRequest(entityName: "Filter")
        if let filters = self.managedObjectContext.executeFetchRequest(fetchRequest, error: &error) as? [Filter]
        {

        if (filters.isEmpty) {
        
        println("Seeding Core Data")
        var sepia = NSEntityDescription.insertNewObjectForEntityForName("Filter", inManagedObjectContext: self.managedObjectContext) as Filter
        sepia.name = "CISepiaTone"
        
        var gaussianBlur = NSEntityDescription.insertNewObjectForEntityForName("Filter", inManagedObjectContext: self.managedObjectContext) as Filter
        gaussianBlur.name = "CIGaussianBlur"
        gaussianBlur.favorited = true
        
        var colorInvert = NSEntityDescription.insertNewObjectForEntityForName("Filter", inManagedObjectContext: self.managedObjectContext!) as Filter
        colorInvert.name = "CIColorInvert"
        

            var cIPixellate = NSEntityDescription.insertNewObjectForEntityForName("Filter", inManagedObjectContext: self.managedObjectContext!) as Filter
            cIPixellate.name =  "CIPixellate"
            var gammaAdjust = NSEntityDescription.insertNewObjectForEntityForName("Filter", inManagedObjectContext: self.managedObjectContext!) as Filter
            gammaAdjust.name = "CIGammaAdjust"
            var exposureAdjust = NSEntityDescription.insertNewObjectForEntityForName("Filter", inManagedObjectContext: self.managedObjectContext!) as Filter
            exposureAdjust.name = "CIExposureAdjust"
            var chromeEffect = NSEntityDescription.insertNewObjectForEntityForName("Filter", inManagedObjectContext: self.managedObjectContext!) as Filter
            chromeEffect.name = "CIPhotoEffectChrome"
            var instantEffect = NSEntityDescription.insertNewObjectForEntityForName("Filter", inManagedObjectContext: self.managedObjectContext!) as Filter
            instantEffect.name = "CIPhotoEffectInstant"
            var monoEffect = NSEntityDescription.insertNewObjectForEntityForName("Filter", inManagedObjectContext: self.managedObjectContext!) as Filter
            monoEffect.name = "CIPhotoEffectMono"
            var noirEffect = NSEntityDescription.insertNewObjectForEntityForName("Filter", inManagedObjectContext: self.managedObjectContext!) as Filter
            noirEffect.name = "CIPhotoEffectNoir"
            var tonalEffect = NSEntityDescription.insertNewObjectForEntityForName("Filter", inManagedObjectContext: self.managedObjectContext!) as Filter
            tonalEffect.name = "CIPhotoEffectTonal"
            var transferEffect = NSEntityDescription.insertNewObjectForEntityForName("Filter", inManagedObjectContext: self.managedObjectContext!) as Filter
            transferEffect.name = "CIPhotoEffectTransfer"
        
        var fetchRequest = NSFetchRequest(entityName: "filter")
        //var error: NSError?
        
        self.managedObjectContext?.save(&error)
        
        if error != nil {
            println(error?.localizedDescription)
            }
        }
        }
    }
}

