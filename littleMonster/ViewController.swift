//
//  ViewController.swift
//  littleMonster
//
//  Created by Georgios Georgiou on 16/02/16.
//  Copyright © 2016 gig.com. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var monsterImage: MonsterImg!
    @IBOutlet weak var foodImg: DragImg!
    @IBOutlet weak var heartImg: DragImg!
    @IBOutlet weak var penalty1Img: UIImageView!
    @IBOutlet weak var penalty2Img: UIImageView!
    @IBOutlet weak var penalty3Img: UIImageView!
    @IBOutlet weak var newGameBtn: UIButton!
    @IBOutlet weak var trackDeathTime: UILabel!
    @IBOutlet weak var trackDeathLblLeadingConstSpace: NSLayoutConstraint!
    
    let DIM_APLHA: CGFloat = 0.1
    let OPAQUE: CGFloat = 1.0
    let MAX_PENALTY = 3
    
    var penalties = 0
    var timer: NSTimer!
    var trackTime = 4
    var monsterHappy = false
    var currentItem: UInt32 = 0
    
    var musicPlayer: AVAudioPlayer!
    var sfxBite: AVAudioPlayer!
    var sfxHeart: AVAudioPlayer!
    var sfxDeath: AVAudioPlayer!
    var sfxSkull: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        foodImg.dropTarget = monsterImage
        heartImg.dropTarget = monsterImage

        penalty1Img.alpha = DIM_APLHA
        penalty2Img.alpha = DIM_APLHA
        penalty3Img.alpha = DIM_APLHA
        trackDeathTime.text = ""

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "itemDroppedOnCharacter:", name: "onTargetDropped", object: nil)
        
        trackDeathTime.hidden = true
    }
    
    func itemDroppedOnCharacter(notif: AnyObject){
        monsterHappy = true
        trackTime = 0
        updateRemainingSecondsLabel()
        foodImg.alpha = DIM_APLHA
        foodImg.userInteractionEnabled = false
        
        heartImg.alpha = DIM_APLHA
        heartImg.userInteractionEnabled = false

        if currentItem == 0 {
            sfxHeart.play()
        }else{
            sfxBite.play()
        }
        
        let rand = arc4random_uniform(2) //0 or 1
        if rand == 0 && rand != currentItem {
            foodImg.alpha = DIM_APLHA
            foodImg.userInteractionEnabled = false
            
            heartImg.alpha = OPAQUE
            heartImg.userInteractionEnabled = true
        }else{
            foodImg.alpha = OPAQUE
            foodImg.userInteractionEnabled = true
            
            heartImg.alpha = DIM_APLHA
            heartImg.userInteractionEnabled = false
        }
        currentItem = rand

    }

    func startTimer(){
        if timer != nil {
            timer.invalidate()
        }
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateRemainingSecondsLabel", userInfo: nil, repeats: true)
    }

    func updateRemainingSecondsLabel(){
        
        if trackTime == 0 {
            trackTime = 3
            trackDeathTime.text = ""
            startTimer()
            changeGameState()
        } else {
            startTimer()
            trackTime = trackTime - 1
        }
        
        trackDeathTime.text = " \(trackTime)"
    }

    func changeGameState(){
        
        if !monsterHappy {
            penalties++
            sfxSkull.play()
            switch penalties{
            case 1:
                penalty1Img.alpha = OPAQUE
                penalty2Img.alpha = DIM_APLHA
                trackDeathLblLeadingConstSpace.constant = -125
            case 2:
                penalty2Img.alpha = OPAQUE
                penalty3Img.alpha = DIM_APLHA
                trackDeathLblLeadingConstSpace.constant = -65
            case 3:
                penalty3Img.alpha = OPAQUE
            default:
                trackDeathLblLeadingConstSpace.constant = -190
                if penalties >= 3 {
                    penalty3Img.alpha = OPAQUE
                }else{
                    penalty1Img.alpha = DIM_APLHA
                    penalty2Img.alpha = DIM_APLHA
                    penalty3Img.alpha = DIM_APLHA
                }
            }
            
            if penalties >= MAX_PENALTY {
                gameOver()
            }
        }else{
            monsterHappy = false
        }
    }
    
    func gameOver(){
        trackDeathTime.hidden = true
        timer.invalidate()
        foodImg.alpha = DIM_APLHA
        foodImg.userInteractionEnabled = false
        
        heartImg.alpha = DIM_APLHA
        heartImg.userInteractionEnabled = false
        
        monsterImage.playDeathAnimation()
        sfxDeath.play()
        
        self.newGameBtn.hidden = false
    }

    @IBAction func newGame(sender: AnyObject) {

        trackDeathLblLeadingConstSpace.constant = -190
        trackDeathTime.hidden = false
        trackTime = 4

        heartImg.userInteractionEnabled = true
        foodImg.userInteractionEnabled = true
        foodImg.alpha = OPAQUE
        heartImg.alpha = OPAQUE
        
        self.newGameBtn.hidden = true
        self.monsterImage.playIdleAnimation()
        penalties = 0
        monsterHappy = false
        penalty1Img.alpha = DIM_APLHA
        penalty2Img.alpha = DIM_APLHA
        penalty3Img.alpha = DIM_APLHA
        updateRemainingSecondsLabel()
        
        do {
            try musicPlayer = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("cave-music", ofType: "mp3")!))
            try sfxBite = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("bite", ofType: "wav")!))
            try sfxHeart = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("heart", ofType: "wav")!))
            try sfxDeath = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("death", ofType: "wav")!))
            try sfxSkull = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("skull", ofType: "wav")!))
            musicPlayer.volume = 0.3
            musicPlayer.prepareToPlay()
            musicPlayer.play()
            
            sfxBite.prepareToPlay()
            sfxHeart.prepareToPlay()
            sfxDeath.prepareToPlay()
            sfxSkull.prepareToPlay()
            
        }catch let error as NSError{
            print(error.debugDescription)
            
        }
    }
}

