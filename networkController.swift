//
//  networkController.swift
//  PhotoFilters
//
//  Created by Joshua M. Sacks on 10/19/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//


import Foundation
import Accounts
import Social

class NetworkController {
    
    var faceBookAccount : ACAccount?



    func postPhotoToFaceBook (image : UIImage) {
        let accountStore = ACAccountStore()
        let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierFacebook)

accountStore.requestAccessToAccountsWithType(accountType, options: nil) { (granted : Bool, error : NSError!) -> Void in
    if granted {
        let accounts = accountStore.accountsWithAccountType(accountType)
        self.faceBookAccount = accounts.first as ACAccount?
        
        //TO-DO set up FB call to post the image to the users timeline
        


}
}
    }






}