//
//  MonsterImg.swift
//  littleMonster
//
//  Created by Georgios Georgiou on 16/02/16.
//  Copyright © 2016 gig.com. All rights reserved.
//

import Foundation
import UIKit

class MonsterImg: UIImageView{

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        playWaitingNewGameAnimation()
    }
    
    func playWaitingNewGameAnimation(){
        self.image = UIImage (named:"idle1.png")
        self.animationImages = nil
    }

    func playIdleAnimation(){
        
        self.image = UIImage (named:"idle1.png")
        self.animationImages = nil
        
        var imgArray = [UIImage]()
        for var i = 1; i<5; i++ {
            let img = UIImage(named: "idle\(i).png")
            imgArray.append(img!)
        }
        self.animationImages = imgArray
        self.animationDuration = 0.8
        self.animationRepeatCount = 0 //infinite animation
        self.startAnimating()
    }

    func playDeathAnimation(){
        
        self.image = UIImage (named:"dead5.png")
        self.animationImages = nil
        
        var imgArray = [UIImage]()
        for var i = 1; i<6; i++ {
            let img = UIImage(named: "dead\(i).png")
            imgArray.append(img!)
        }
        self.animationImages = imgArray
        self.animationDuration = 0.8
        self.animationRepeatCount = 1 //animate once and stop
        self.startAnimating()
    }
}