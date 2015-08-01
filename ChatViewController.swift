//
//  ChatViewController.swift
//  DateUp
//
//  Created by Janan Rajaratnam on 7/28/15.
//  Copyright (c) 2015 Janan Rajaratnam. All rights reserved.
//

import Foundation




class ChatViewController : JSQMessagesViewController
{
    
    //Bruce's properties for avatars
    var senderAvatar: UIImage!
    var recipientAvatar: UIImage!
    /////////////////////////////////
    
    
    var messages : [JSQMessage] = []
    
    var matchID : String?
    
    var messageListener: MessageListener?
    
    
    let outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleBlueColor())
    
    let incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleGreenColor())
    
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        
//        self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero
//        self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero
        
        if let id = self.matchID
        {
            fetchMessages(id, {
                messages in
                
                for aMessage in messages
                {
                    self.messages.append(JSQMessage(senderId: aMessage.senderID, senderDisplayName: aMessage.senderID, date: aMessage.date, text: aMessage.message))
                }
                self.finishReceivingMessage()
            })
        }
        
    }
    
    override func viewWillAppear(animated: Bool)
    {
        
        
        if let id = self.matchID
        {
            self.messageListener = MessageListener(matchID: id, startDate: NSDate(), callback: {
                    message in
                self.messages.append(JSQMessage(senderId: message.senderID, senderDisplayName: message.senderID, date: message.date, text: message.message))
                
                self.finishReceivingMessage()
                
            })
        }
        
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        
        self.messageListener?.stop()
    }
    
    //Getter Method for the senderDisplayName property in JSQMessagesViewController
    func senderDisplayName() -> String!
    {
        return currentUser()!.id
        
    }
    
    //Getter Method for the senderId property in JSQMessagesViewController
    func senderId() -> String!
    {
        return currentUser()!.id
    }
    
    
    
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData!
    {
        var data = self.messages[indexPath.row]
        
        return data
        
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
     
        return self.messages.count
        
    }
    
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource!
    {
        var data = self.messages[indexPath.row]
        
        if data.senderId == PFUser.currentUser().objectId
        {
            return self.outgoingBubble
        }
        else
        {
            return self.incomingBubble
        }
        
        
    }
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!)
    {
        let message = JSQMessage(senderId: senderId, senderDisplayName: senderDisplayName, date: date, text: text)
        
//        self.messages.append(message)
        
        //If a value for self.matchID has been set
        if let id = self.matchID
        {
            saveMessage(id, Message(message: text, senderID: senderId, date: date))
        }
        
        self.finishSendingMessage()
    }
    
    
    
    //MARK:- Bruce's code
    //Code extracted from Bruce at BitFountain
    /////////////////////////////////////////////////////////////////////////////////
    func updateAvatarImageForIndexPath( indexPath: NSIndexPath, avatarImage: UIImage)
    {
        
        
        let cell: JSQMessagesCollectionViewCell = self.collectionView.cellForItemAtIndexPath(indexPath) as JSQMessagesCollectionViewCell
        cell.avatarImageView.image = JSQMessagesAvatarImageFactory.circularAvatarImage( avatarImage, withDiameter: 60 )
    }
    
    
//    func updateAvatarForUser( indexPath: NSIndexPath, user: User )
//    {
//        user.getPhoto({ image in
//            self.updateAvatarImageForIndexPath( indexPath, avatarImage: image)
//        })
//    }
    
    
    //Replacement for the above code
    func updateAvatarForRecipient( indexPath: NSIndexPath, user: User )
    {
        user.getPhoto({
            image in
            self.recipientAvatar = image
            self.updateAvatarImageForIndexPath( indexPath, avatarImage: image)
        })
    }
    
    
    
//    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource!
//    {
//        var imgAvatar = JSQMessagesAvatarImage.avatarWithImage( JSQMessagesAvatarImageFactory.circularAvatarImage( UIImage(named: "profile-header"), withDiameter: 60 ) )

//        if (self.messages[indexPath.row].senderId == self.senderId)
//        {
//            currentUser()!.getPhoto({ (image) -> () in
//                self.updateAvatarImageForIndexPath( indexPath, avatarImage: image)
//            })
//        }
//        else
//        {
//            getUserAsync( self.messages[indexPath.row].senderId,
//                {
//                    user in
//                    self.updateAvatarForUser( indexPath, user: user
//                )}
//            )
//        }
//        return imgAvatar
//    }
    
    //the above method keeps on downloading the respective avatar images for everytime collectionView avatarImageDataForItemAtIndexPath is called
    //In a slow inter net connection, it takes time for the images to keep on getting updated
    
    //The code below executes the downloading of the respective avatar images once and then sets them as properties that can be accessed. Doesn't require to be downloaded everytime the collectionView avatarImageDataForItemAtIndexPath is called
    
    //Replacement for the above code
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource!
    {
        //the default avatar image if no avatar image is set by the sender nor recipient
        var imgAvatar = JSQMessagesAvatarImage.avatarWithImage( JSQMessagesAvatarImageFactory.circularAvatarImage( UIImage(named: "profile-header"), withDiameter: 60 ) )
        
        
        
        //If the sender is the current user
        if (self.messages[indexPath.row].senderId == self.senderId)
        {
            //And if senderAvatar is set  then...
            if (self.senderAvatar != nil)
            {
                imgAvatar = JSQMessagesAvatarImage.avatarWithImage( JSQMessagesAvatarImageFactory.circularAvatarImage( self.senderAvatar, withDiameter: 60 ) )
            }
            else //if senderAvatar is not set  then....
            {
                currentUser()!.getPhoto({ (image) -> () in
                    self.senderAvatar = image
                    self.updateAvatarImageForIndexPath( indexPath, avatarImage: image)
                })
            }
        }
        else //If the sender is not the current user
        {
            //And if recipientAvatar is set  then...
            if (self.recipientAvatar != nil)
            {
                imgAvatar = JSQMessagesAvatarImage.avatarWithImage( JSQMessagesAvatarImageFactory.circularAvatarImage( self.recipientAvatar, withDiameter: 60 ) )
            }
            else //if recipientAvatar is not set  then...
            {
                getUserAsync( self.messages[indexPath.row].senderId, { (user) -> () in
                    self.updateAvatarForRecipient( indexPath, user: user ) } )
            }
        }
        return imgAvatar
    }
    /////////////////////////////////////////////////////////////////////////////////
    
}

