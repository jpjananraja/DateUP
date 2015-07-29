//
//  CardView.swift
//  DateUp
//
//  Created by Janan Rajaratnam on 7/5/15.
//  Copyright (c) 2015 Janan Rajaratnam. All rights reserved.
//

import Foundation
import UIKit

class CardView : UIView
{
    private let imageView : UIImageView = UIImageView()
    private let nameLabel : UILabel = UILabel()
    
    
    var name: String?
    {
        didSet{
            if let name = name
            {
                self.nameLabel.text = name
            }
        }
    }
    
    
    var image: UIImage?
    {
        didSet{
            if let image = image
            {
                self.imageView.image = image
            }
        }
        
    }
    
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
        self.imageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.imageView.backgroundColor = UIColor.redColor()
        self.addSubview(self.imageView)
        
        self.nameLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.nameLabel.textAlignment = .Center;
        self.nameLabel.backgroundColor = UIColor(red: 0.29, green: 0.56, blue: 0.89, alpha: 1.0)

        self.addSubview(self.nameLabel)
        
        self.backgroundColor = UIColor.whiteColor()
        
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        
        
        self.setConstraints()
        
    }
    
    private func setConstraints()
    {
        //constraints for imageView
        self.addConstraint(NSLayoutConstraint(item: self.imageView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0))
        
        self.addConstraint(NSLayoutConstraint(item: self.imageView, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: 0))
        
        self.addConstraint(NSLayoutConstraint(item: self.imageView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 0))
        
        self.addConstraint(NSLayoutConstraint(item: self.imageView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Height, multiplier: 1.0, constant: 0))
        
        
        //constraints for nameLabel
//        self.addConstraint(NSLayoutConstraint(item: self.nameLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.imageView, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0))
//        
//        self.addConstraint(NSLayoutConstraint(item: self.nameLabel, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: 10))
//        
//        self.addConstraint(NSLayoutConstraint(item: self.nameLabel, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Trailing, multiplier: 1.0, constant: -10))
//        
//        self.addConstraint(NSLayoutConstraint(item: self.nameLabel, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0))
        
        //Above constraints for nameLabel will not make appear the name label for the respective cardView
        
        
        //constraints for nameLabel - Modified top and bottom constraints
        self.addConstraint(NSLayoutConstraint(item: self.nameLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.imageView, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: -40))
        
        self.addConstraint(NSLayoutConstraint(item: self.nameLabel, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: 10))
        
        self.addConstraint(NSLayoutConstraint(item: self.nameLabel, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Trailing, multiplier: 1.0, constant: -10))
        
        self.addConstraint(NSLayoutConstraint(item: self.nameLabel, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: -10))
        
        
    }
    
    
}