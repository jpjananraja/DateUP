//
//  SwipeView.swift
//  DateUp
//
//  Created by Janan Rajaratnam on 7/8/15.
//  Copyright (c) 2015 Janan Rajaratnam. All rights reserved.
//

import Foundation
import UIKit

class SwipeView : UIView
{
    enum Direction
    {
        case None
        case Left
        case Right
    }
    //Delegate property
    weak var delegate: SwipeViewDelegate?
    
    
    
    let overlay: UIImageView = UIImageView()
    
    // Direction in which the swipeView is swiping
    var direction : Direction?
    
    
//    private let card : CardView = CardView()
    
    
    
    //The CardView property used as an innerView
    var innerView : UIView? {
        
//If the CardView is set in the CardsViewController class then do the following
        
        didSet
        {
            if let v = innerView
            {
                self.insertSubview(v, belowSubview: self.overlay)
//                self.addSubview(v)
                v.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
            }
        }
        
    }
        
    
    
    private var originalPoint : CGPoint?
    
    
    
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.initialize()
    }
    
    override init()
    {
        super.init()
        self.initialize()
    }
    
    private func initialize()
    {
//        self.backgroundColor = UIColor.clearColor()
//        self.backgroundColor = UIColor.redColor()
          self.backgroundColor = UIColor.clearColor()
        
//        self.addSubview(card)
        
        
          self.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "dragged:"))
        
//        self.card.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        
//        self.originalPoint = self.center //Moved to switch statement in dragged(...)
        
//        self.card.setTranslatesAutoresizingMaskIntoConstraints(false)

//        self.setConstraints()
        
        //The overlay's frame should be the same size as the swipeView
        self.overlay.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        
        self.addSubview(self.overlay)
        
        
    }
    
    
    
//    private func setConstraints()
//    {
//        self.addConstraint(NSLayoutConstraint(item: card, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0))
//        
//        self.addConstraint(NSLayoutConstraint(item: card, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0))
//        
//        self.addConstraint(NSLayoutConstraint(item: card, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: 0))
//        
//        self.addConstraint(NSLayoutConstraint(item: card, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Trailing, multiplier: 1.0, constant: 0))
//        
//        
//    }
    
    
    
    
    // MARK: - UIPanGestureRecognizer action argument method
    func dragged(gestureRecognizer : UIPanGestureRecognizer)
    {
        let distance = gestureRecognizer.translationInView(self)
        println("Distance X: \(distance.x)  Distance Y: \(distance.y)")
        
//        println("self.superview!.frame.width/2 is \(self.superview!.frame.width/2)")
        
        
        switch gestureRecognizer.state
        {
        
        case UIGestureRecognizerState.Began :
                    self.originalPoint = self.center
        
       
        case UIGestureRecognizerState.Changed :
            
                    let rotationPercentage = min(distance.x/(self.superview!.frame.width/2) , 1)
                    
                    let rotationAngle = (CGFloat(2 * M_PI/16) * rotationPercentage)
                    
//                    println("rotationPercentage \(rotationPercentage)")
                    
//                    self.transform = CGAffineTransformRotate(self.transform, rotationAngle)
                    self.transform = CGAffineTransformMakeRotation(rotationAngle)
                    
//                    println("rotationAngle \(rotationAngle)")
                    
                    self.center = CGPointMake(self.originalPoint!.x + distance.x, self.originalPoint!.y + distance.y)
            
                    self.updateOverlay(distance.x)
        
       
        case UIGestureRecognizerState.Ended :
            
            if abs(distance.x) < self.frame.width/4
            {
                self.resetViewPositionAndTransformations()
            }
            else
            {
                self.swipe(distance.x > 0 ? Direction.Right : Direction.Left)
                
            }
            
            
//            self.resetViewPositionAndTransformations()
        default :
            println("Default triggered for GestureRecognizer")
            break
        }
        
        
//        self.center = CGPointMake(self.originalPoint!.x + distance.x, self.originalPoint!.y + distance.y)  //moved to the above switch statement
        
    }
    
    
    
    
    //MARK:- Helper Functions
    func swipe(s:Direction)
    {
        if s == Direction.None
        {
            return
        }
        
        //Get the parent view's width.   The parentWidth has +ve value if s == Direction.Right
        var parentWidth = self.superview!.frame.width
        
        
        
        if s == Direction.Left
        {
            parentWidth *= -1
        }
        
        UIView.animateWithDuration(0.5, animations: {
            self.center.x = self.frame.origin.x + parentWidth
            
            println("self.frame.origin.x \(self.frame.origin.x)")
            println("parentWidth \(parentWidth)")
            println("self.center.x \(self.center.x)")
            
            
            //the following code aids in the yeah and nah appearing only when the buttons are clicked as oppossed to swiping them left or right
            self.updateOverlay(self.center.x)
            
            
            }, completion: {
                success in
                if let d = self.delegate
                {
                    s == Direction.Right ? d.swipedRight() : d.swipedLeft()
                }
        })
        
        
//        UIView.animateWithDuration(0.2, animations: { () -> Void in
//            
//            self.center.x = self.frame.origin.x + parentWidth
//        })
        
        
    }
    
    
    
    private func updateOverlay(distance : CGFloat)
    {
//        println("distance value is: \(distance)")

        
        var newDirection : Direction
        newDirection = distance < 0 ? Direction.Left : Direction.Right
        
//        println("newDirection value is: \(newDirection.hashValue)")

        
        
        if newDirection != self.direction
        {
            self.direction = newDirection
            
//            println("Direction is: \(self.direction!)")
            
            self.overlay.image = self.direction == Direction.Right ? UIImage(named: "yeah-stamp") : UIImage(named: "nah-stamp")
        }
        self.overlay.alpha = abs(distance) / (self.superview!.frame.width/2)
        
    }
    
    
    
    
    private func resetViewPositionAndTransformations()
    {
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.center = self.originalPoint!
            self.transform = CGAffineTransformMakeRotation(0)
            
            self.overlay.alpha = 0
        })
    }
    
    
}


//MARK:- SwipeViewDelegate protocol

protocol SwipeViewDelegate: class
{
    func swipedLeft()
    func swipedRight()
    
}
