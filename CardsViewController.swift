//
//  CardsViewController.swift
//  DateUp
//
//  Created by Janan Rajaratnam on 7/8/15.
//  Copyright (c) 2015 Janan Rajaratnam. All rights reserved.
//

import UIKit

class CardsViewController: UIViewController, SwipeViewDelegate {

    
    struct Card
    {
        let cardView : CardView
        let swipeView : SwipeView
        let user: User
    
    }
    
    
    let frontCardTopMargin : CGFloat = 0
    let backCardTopMargin : CGFloat = 10
    
    @IBOutlet weak var cardStackView: UIView!
    
    //IBOutlets
    
    @IBOutlet weak var nahButton: UIButton!
    @IBOutlet weak var yeahButton: UIButton!
    
//    var backCard : SwipeView?
//    var frontCard : SwipeView?
    
    var backCard : Card?
    var frontCard : Card?
    
    //The array of users
    var users : [User]?
    
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "nav-header"))
        
        let leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav-back-button"), style: UIBarButtonItemStyle.Plain, target: self, action: "gotoProfile:")
        
        self.navigationItem.setLeftBarButtonItem(leftBarButtonItem, animated: true)
        
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.cardStackView.backgroundColor = UIColor.clearColor()
        
        self.nahButton.setImage(UIImage(named: "nah-button-pressed"), forState: UIControlState.Highlighted)
        self.yeahButton.setImage(UIImage(named: "yeah-button-pressed"), forState: UIControlState.Highlighted)
        
        
//        self.backCard = SwipeView(frame: self.createCardFrame(self.backCardTopMargin))
//        self.backCard!.delegate = self
//        self.cardStackView.addSubview(self.backCard!)
        
        
        //Add the backCard to the stack before you add the frontCard
        
//        self.backCard = self.createCard(backCardTopMargin)
//        self.cardStackView.addSubview(self.backCard!.swipeView)
        
        
//        self.frontCard = SwipeView(frame: self.createCardFrame(self.frontCardTopMargin))
//        self.frontCard!.delegate = self
//        self.cardStackView.addSubview(self.frontCard!)
        
//        self.frontCard = self.createCard(frontCardTopMargin)
//        self.cardStackView.addSubview(self.frontCard!.swipeView)
        
        
        fetchUnViewedUsers({
            returnedUsers in
            self.users = returnedUsers
//            println(self.users)
            
            if let card = self.popCard()
            {
                self.frontCard = card
                self.cardStackView.addSubview(self.frontCard!.swipeView)
                
            }
            
            if let card = self.popCard()
            {
                self.backCard = card
                self.backCard!.swipeView.frame = self.createCardFrame(self.backCardTopMargin)
                self.cardStackView.insertSubview(self.backCard!.swipeView, belowSubview: self.frontCard!.swipeView)
            }
            
        })
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - IBAction Functions
    
    @IBAction func nahButtonPressed(sender: UIButton)
    {
      if let card = self.frontCard
      {
        card.swipeView.swipe(SwipeView.Direction.Left)
      }
        
    }
    
    @IBAction func yeahButtonPressed(sender: UIButton)
    {
        if let card = self.frontCard
        {
            card.swipeView.swipe(SwipeView.Direction.Right)
        }
    }
    

    // MARK: - Helper Function
    private func createCardFrame(topMargin : CGFloat) -> CGRect
    {
        return CGRect(x: 0, y: topMargin, width: self.cardStackView.frame.width, height: self.cardStackView.frame.height)
        
        
    }
    
    //Legacy createCard function which accepts a topMargin parameter instead of a user
    
//    private func createCard(topMargin : CGFloat) -> Card
//    {
//        let cardView = CardView()
//        let swipeView = SwipeView(frame: self.createCardFrame(topMargin))
//        
//        swipeView.delegate = self
//        swipeView.innerView = cardView
//        
//        return Card(cardView: cardView, swipeView: swipeView)
//    }
    
    
    private func createCard(user: User) -> Card
    {
        let cardView = CardView()
        cardView.name = user.name
        user.getPhoto({
            image in
            cardView.image = image
        })
        
        
        let swipeView = SwipeView(frame: self.createCardFrame(0))
        
        swipeView.delegate = self
        swipeView.innerView = cardView
        
        return Card(cardView: cardView, swipeView: swipeView, user:user)
    }
    
    
    private func popCard() -> Card?
    {
        if self.users != nil && self.users?.count > 0
        {
            return self.createCard(users!.removeLast())
        }
        return nil
    }
    
    
    private func switchCards()
    {
        if let card = self.backCard
        {
            self.frontCard = card
            UIView.animateWithDuration(0.2, animations: {
                self.frontCard!.swipeView.frame = self.createCardFrame(self.frontCardTopMargin)
            })
        }
        if let card = self.popCard()
        {
            self.backCard = card
            self.backCard!.swipeView.frame = self.createCardFrame(self.backCardTopMargin)
            self.cardStackView.insertSubview(self.backCard!.swipeView, belowSubview: self.frontCard!.swipeView)
        }
    }
    
    // MARK: - SwipeViewDelegate functions
    func swipedLeft()
    {
        println("Left")
        
        println("self.cardStackView.subviews.count \(self.cardStackView.subviews.count)")

        
        if let frontCard = self.frontCard
        {
//            frontCard.removeFromSuperview()
            frontCard.swipeView.removeFromSuperview()
            
            saveSkip(frontCard.user)
            
            self.switchCards()
            
        }
        
        println("self.cardStackView.subviews.count \(self.cardStackView.subviews.count)")
        
    }
    
    func swipedRight()
    {
        println("Right")
        
        println("self.cardStackView.subviews.count \(self.cardStackView.subviews.count)")

        if let frontCard = self.frontCard
        {
//            frontCard.removeFromSuperview()
            frontCard.swipeView.removeFromSuperview()
            
            saveLike(frontCard.user)
            
            self.switchCards()
        }
        
        println("self.cardStackView.subviews.count \(self.cardStackView.subviews.count)")

    }
    
    
    //MARK:- leftBarButtonItem selector method
    func gotoProfile(button: UIBarButtonItem)
    {
        pageController.gotoPreviousVC()
    }
    
}
