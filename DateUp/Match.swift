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
    PFQuery(className: "Action")
        .whereKey("byUser", equalTo: PFUser.currentUser().objectId)
        .whereKey("type", equalTo: "matched").findObjectsInBackgroundWithBlock({
        objects, error in
        
        if let matches = objects as? [PFObject]
        {
            let matchedUsers = matches.map({
                (object) -> (matchID: String, userID: String)
                in
                (object.objectId, object.objectForKey("toUser") as String)
            })
            
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