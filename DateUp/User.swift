//
//  User.swift
//  DateUp
//
//  Created by Janan Rajaratnam on 7/16/15.
//  Copyright (c) 2015 Janan Rajaratnam. All rights reserved.
//

import Foundation

struct User
{
    let id : String
//    let pictureURL : String
    let name : String
    private let pfUser : PFUser
    
    func getPhoto(callback : (UIImage) -> ())
    {
        let imageFile = pfUser.objectForKey("picture") as PFFile
        imageFile.getDataInBackgroundWithBlock({
            data , error in
            if let data = data
            {
                callback(UIImage(data: data)!)
            }
            
            
        })
    }
}

//MARK:- Private function
//private func pfUserToUser(user: PFUser) -> User
//{
////    return User(id: user.objectId, pictureURL: user.objectForKey("picture") as String, name: user.objectForKey("firstName") as String, pfUser: user)
//
//   
//    
//    //the above return statement would cause a crash since pictureURL would return a PFFILE, while on the above code we try and cast it to a string
//    
//    
//    return User(id: user.objectId, name: user.objectForKey("firstName") as String, pfUser: user)
//    
//}


//MARK:- Public functions
func pfUserToUser(user: PFUser) -> User
{
    //    return User(id: user.objectId, pictureURL: user.objectForKey("picture") as String, name: user.objectForKey("firstName") as String, pfUser: user)
    
    
    
    //the above return statement would cause a crash since pictureURL would return a PFFILE, while on the above code we try and cast it to a string
    
    
    return User(id: user.objectId, name: user.objectForKey("firstName") as String, pfUser: user)
    
}


//MARK:- Public functions

func currentUser() -> User?
{
    if let user = PFUser.currentUser()
    {
        return pfUserToUser(user)
    }
    return nil // Since we could return either a "User struct" or "nil" the return value is an optional
    
}


func fetchUnViewedUsers(callBack: ([User]) -> ())
{
    
    PFQuery(className: "Action")
        .whereKey("byUser", equalTo: PFUser.currentUser().objectId).findObjectsInBackgroundWithBlock({
            objects, error in
            
            let seenIDS = map(objects, ({$0.objectForKey("toUser")!}))
            
            PFUser.query()
                .whereKey("objectId", notEqualTo: PFUser.currentUser().objectId)
                .whereKey("objectId", notContainedIn: seenIDS)
                .findObjectsInBackgroundWithBlock({
                    objects , error in
                    
                    if let pfusers = objects as? [PFUser]
                    {
                        let users = map(pfusers, {pfUserToUser($0)})
                        callBack(users)
                        
                        
                    }
                    
                })

        
        })
    
    
    //Moved into the above PFQuery(className: "Action")

//    PFUser.query()
//        
//    .whereKey("objectId", notEqualTo: PFUser.currentUser().objectId)
//    .findObjectsInBackgroundWithBlock({
//        objects , error in
//        
//        if let pfusers = objects as? [PFUser]
//        {
//            let users = map(pfusers, {pfUserToUser($0)})
//            callBack(users)
//                
//            
//        }
//        
//    })
    
}


func saveSkip(user: User)
{
    let skip = PFObject(className: "Action")
    skip.setObject(PFUser.currentUser().objectId, forKey: "byUser")
    skip.setObject(user.id, forKey: "toUser")
    skip.setObject("skipped", forKey: "type")
    skip.saveInBackgroundWithBlock(nil)
}


//func saveLike(user: User)
//{
//    let like = PFObject(className: "Action")
//    like.setObject(PFUser.currentUser().objectId, forKey: "byUser")
//    like.setObject(user.id, forKey: "toUser")
//    like.setObject("liked", forKey: "type")
//    like.saveInBackgroundWithBlock(nil)
//}


func saveLike(user: User)
{
    PFQuery(className: "Action")
        .whereKey("byUser", equalTo: user.id)
        .whereKey("toUser", equalTo: PFUser.currentUser().objectId)
        .whereKey("type", equalTo: "liked")
        .getFirstObjectInBackgroundWithBlock({
            object, error in
            
            var matched = false
            
            if object != nil
            {
                matched = true
                object.setObject("matched", forKey: "type")
                object.saveInBackgroundWithBlock(nil)
            }
            
            let match = PFObject(className: "Action")
            match.setObject(PFUser.currentUser().objectId, forKey: "byUser")
            match.setObject(user.id, forKey: "toUser")
            match.setObject(matched ? "matched" : "liked", forKey: "type")
            match.saveInBackgroundWithBlock(nil)
        
        })
    
    
}

//MARK:- Bruce's code
//Code extracted from Bruce at BitFountain
//Method to obtain a user asynchroniously who is not the current user
//////////////////////////////////////////////////////////
func getUserAsync(userID: String, callback: (User) -> () )
{
    PFUser.query()
        .whereKey("objectId", equalTo: userID)
        .getFirstObjectInBackgroundWithBlock({
            object, error in
            if let pfUser = object as? PFUser
            {
                let user = pfUserToUser(pfUser)
                callback(user)
            }
    })
}
//////////////////////////////////////////////////////////


