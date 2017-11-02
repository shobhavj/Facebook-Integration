//
//  videoPlayerCell.swift
//  SwiftFacebookIntegration
//
//  Created by Shobha V J on 2017-11-01.
//  Copyright © 2017 Shobha V J. All rights reserved.
//

import UIKit
import AVFoundation

class videoPlayerCell: UITableViewCell {

   
    @IBOutlet weak var videoView: UIView!
    
    @IBOutlet weak var videoLabel: UILabel!
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
        // Initialization code
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
        avPlayerLayer?.frame = CGRect.init(x:-200, y:-120, width: 400, height: 235)
        // }
        self.backgroundColor = .clear
        self.videoView.layer.insertSublayer(avPlayerLayer!, at: 0)
        
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
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
