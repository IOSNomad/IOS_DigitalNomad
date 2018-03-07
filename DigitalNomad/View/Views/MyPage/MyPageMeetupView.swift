//
//  MyPageMeetupView.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 3. 6..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import UIKit

class MyPageMeetupView: UIView {

    @IBOutlet var buttonMeetup: UIButton!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var occupation: UILabel!
    @IBOutlet var days: UILabel!
    @IBOutlet var message: UILabel!
    @IBOutlet var distance: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 2
        imageView.layer.masksToBounds = false
        imageView.layer.cornerRadius = imageView.frame.height / 2
        imageView.clipsToBounds = true
        buttonMeetup.layer.cornerRadius = 5
    }
    
    class func instanceFromXib() -> UIView {
        return UINib(nibName: "MyPageMeetupView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! UIView
    }
    
    @IBAction func requestMeetup(_ sender: UIButton) {
        let popup = PopupView.instanceFromXib() as! PopupView
        popup.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        popup.frame = (self.parentViewController()?.view.frame)!
        popup.view.alpha = 0
        UIView.animate(withDuration: 0.3, animations: {
            popup.view.alpha = 1
        }) { _ in
            self.parentViewController()?.view.addSubview(popup)
        }
        
    }
    
    @IBAction func showNextPerson(_ sender: UIButton) {
    }
    
}