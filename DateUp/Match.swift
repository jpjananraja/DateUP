//
//  Match.swift
//  DateUp
//
//  Created by Janan Rajaratnam on 7/28/15.
//  Copyright (c) 2015 Janan Rajaratnam. All rights reserved.
//

import Foundation

struct Match
{
    let id: String
    let user: User
    
}

func fetchMatches(callBack: ([Match]) -> ())
{
    //Obtain the objects which indicate the users the current user is matched with
    PFQuery(className: "Action")
        .whereKey("byUser", equalTo: PFUser.currentUser().objectId)
        .whereKey("type", equalTo: "matched").findObjectsInBackgroundWithBlock({
        objects, error in
        
        if let matches = objects as? [PFObject]
        {
//            let matchedUsers = matches.map({
//                (object) -> (matchID: String, userID: String)
//                in
//                (object.objectId, object.objectForKey("toUser") as String)
//            })
            //The above functioanlity only works with the hacky solution of manually changing the "matched" "type" in "Action" in parse.com
            
            
            
            //the below functionality should work with two different facebook logins liking eachother
            let matchedUsers = matches.map({
                (object)->(matchID: String, userID: String)
                in
                (object.objectForKey("matchId") as String, object.objectForKey("toUser") as String)
            })
            
            //Get the userIDs of all the users that have been matched with current user
            //.userID is extracted from the tuple above (... , userID: String)
            let userIDs = matchedUsers.map({$0.userID})
            
            PFUser.query()
            .whereKey("objectId", containedIn: userIDs)
            .findObjectsInBackgroundWithBlock({
                objects, error in
                
                if let users = objects as? [PFUser]
                {
                    var usersArray = reverse(users)
                    var m = Array<Match>() //simillar to ==> var m:[Match] = []
                    
                    for (index, user) in enumerate(usersArray)
                    {
                        m.append(Match(id: matchedUsers[index].matchID, user: pfUserToUser(user)))
                    }
                    
                    callBack(m)
                }
            
            })
        }
    })
}