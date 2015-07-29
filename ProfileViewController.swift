//
//  ProfileViewController.swift
//  DateUp
//
//  Created by Janan Rajaratnam on 7/16/15.
//  Copyright (c) 2015 Janan Rajaratnam. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "profile-header"))
        let rightBarButtonitem = UIBarButtonItem(image: UIImage(named: "nav-back-button"), style: UIBarButtonItemStyle.Plain, target: self, action: "gotoCards:")
        self.navigationItem.setRightBarButtonItem(rightBarButtonitem, animated: true)
        
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.nameLabel.text = currentUser()?.name
        currentUser()?.getPhoto({
            image in
            self.imageView.layer.masksToBounds = true
            self.imageView.contentMode = UIViewContentMode.ScaleAspectFill
            self.imageView.image = image 
            
        })
        
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - RightBarButtonItem selector method
    func gotoCards(button : UIBarButtonItem)
    {
        pageController.gotoNextVC()
    }

}
