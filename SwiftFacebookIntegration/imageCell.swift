//
//  VideoCellTableViewCell.swift
//  SwiftFacebookIntegration
//
//  Created by Shobha V J on 2017-10-25.
//  Copyright © 2017 Shobha V J. All rights reserved.
//

import UIKit
import AVFoundation

class imageCell: UITableViewCell {
    

    
    @IBOutlet weak var dummyLabel: UILabel!
    @IBOutlet weak var userName1: UILabel!
    @IBOutlet weak var dateLbl1: UILabel!
    
    @IBOutlet weak var images: UIImageView!
    @IBOutlet weak var profilePic1: UIImageView!
    @IBOutlet weak var locationLbl1: UILabel!
    @IBOutlet weak var timeLbl1: UILabel!
    
    @IBOutlet weak var images1: UIImageView!
    @IBOutlet weak var storyDetailsLbl1: UILabel!
    @IBOutlet weak var videoPlayerSuperView: UIView!
   
    var avPlayer: AVPlayer?
    var avPlayerLayer: AVPlayerLayer?
    var paused: Bool = false
    var videoPlayerItem: AVPlayerItem? = nil {
        didSet {
            /*
             If needed, configure player item here before associating it with a player.
             (example: adding outputs, setting text style rules, selecting media options)
             */
            avPlayer?.replaceCurrentItem(with: self.videoPlayerItem)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupMoviePlayer()
    }
    
    func setupMoviePlayer(){
        
        self.avPlayer = AVPlayer.init(playerItem: self.videoPlayerItem)
        avPlayerLayer = AVPlayerLayer(player: avPlayer)
        avPlayerLayer?.videoGravity = AVLayerVideoGravity.resizeAspect
        avPlayer?.volume = 3
        avPlayer?.actionAtItemEnd = .none
//        if UIScreen.main.bounds.width == 375 {
//            let widthRequired = self.frame.size.width - 20
//            avPlayerLayer?.frame = CGRect.init(x: 0, y: 0, width: widthRequired, height: widthRequired/1.78)
//        }else if UIScreen.main.bounds.width == 320 {
//            avPlayerLayer?.frame = CGRect.init(x: 0, y: 0, width: (self.frame.size.height - 120) * 1.78, height: self.frame.size.height - 120)
//
//        }else{
            let widthRequired = self.frame.size.width
            avPlayerLayer?.frame = CGRect.init(x: 53, y: 20, width: 235, height: 235)
       // }
        self.backgroundColor = .clear
        self.videoPlayerSuperView.layer.insertSublayer(avPlayerLayer!, at: 0)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.playerItemDidReachEnd(notification:)),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: avPlayer?.currentItem)
    }
    
    func stopPlayback(){
        self.avPlayer?.pause()
    }
    
    func startPlayback(){
        self.avPlayer?.play()
    }
    
    // A notification is fired and seeker is sent to the beginning to loop the video again
    @objc func playerItemDidReachEnd(notification: Notification) {
        let p: AVPlayerItem = notification.object as! AVPlayerItem
        p.seek(to: kCMTimeZero, completionHandler: nil)
    }
    
}



//Resources Used
//1. //https://developer.apple.com/library/content/samplecode/AVFoundationSimplePlayer-iOS/Listings/Swift_AVFoundationSimplePlayer_iOS_PlayerViewController_swift.html

//2. //http://stackoverflow.com/questions/36168519/playing-video-in-uitableview-cell
