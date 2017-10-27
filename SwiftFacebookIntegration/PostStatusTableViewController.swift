//
//  PostStatusTableViewController.swift
//  SwiftFacebookIntegration
//
//  Created by Shobha V J on 2017-10-18.
//  Copyright © 2017 Shobha V J. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class PostStatusTableViewController: UITableViewController{
    
    var nameFromFb: String? = nil
    var profileImage : UIImage? = nil
    var storyDetails =  [String]()
    var sourceDetails = [String]()
    var linkDetails = [String]()
    var dateDetails = [String]()
    var timeDetails = [String]()
    var locationDetails = [String]()
    var imageDetails = [String]()
    var videoDetails = [String]()
    var typeDetails = [String]()
    var statusDetails = [String]()
   
    var avPlayer: AVPlayer!
    var visibleIP : IndexPath?
    var aboutToBecomeInvisibleCell = -1
    var avPlayerLayer: AVPlayerLayer!
    var paused: Bool = false
    var videoURLs = Array<URL>()
    var firstLoad = true
  
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        for i in 0 ..< videoDetails.count {
            let url = URL(string:videoDetails[i])
            videoURLs.append(url!)
        }
        visibleIP = IndexPath.init(row: 0, section: 0)
        //self.tableView.reloadData()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return typeDetails.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageDetail", for: indexPath) as! imageCell
        cell.userName1.text = nameFromFb
        cell.profilePic1.image = profileImage
        cell.storyDetailsLbl1.text = storyDetails[indexPath.row]
        cell.dateLbl1.text = dateDetails[indexPath.row]
        cell.timeLbl1.text = timeDetails[indexPath.row]
       
        switch(typeDetails[indexPath.row]){
            
            case "photo":
                cell.videoPlayerSuperView.isHidden = true
                for image in imageDetails{
                let imageUrl = image
                let url = URL(string:imageUrl)
                let data = try? Data(contentsOf: url!)
                cell.images1.isHidden = false
                cell.images1.image = UIImage(data: data!)
                }
                break
            
            case "link" :
                 cell.videoPlayerSuperView.isHidden = true
                 for link in linkDetails{
                 cell.storyDetailsLbl1.text = link
                 }
                 break
            
            case "status" :
                cell.videoPlayerSuperView.isHidden = true
                for status in statusDetails{
                cell.storyDetailsLbl1.text = status
                }
                break
            
            case "video":
                cell.images1.isHidden = true
                cell.videoPlayerSuperView.isHidden = false
                for video in videoURLs{
                let urls = video
                cell.videoPlayerItem = AVPlayerItem.init(url: urls)
                }
                break
            default:
                break
                
        }
            return cell
    }
    
    
    // A notification is fired and seeker is sent to the beginning to loop the video again
    @objc func playerItemDidReachEnd(notification: Notification) {
        let p: AVPlayerItem = notification.object as! AVPlayerItem
        p.seek(to: kCMTimeZero, completionHandler: nil)
    }
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let indexPaths = self.tableView.indexPathsForVisibleRows
        var cells = [Any]()
        for ip in indexPaths!{
            if let videoCell = self.tableView.cellForRow(at: ip) as? imageCell{
                cells.append(videoCell)
            }
        }
        let cellCount = cells.count
        if cellCount == 0 {return}
        if cellCount == 1{
            //print ("visible = \(String(describing: indexPaths?[0]))")
            if visibleIP != indexPaths?[0]{
                visibleIP = indexPaths?[0]
            }
            if let videoCell = cells.last! as? imageCell{
                self.playVideoOnTheCell(cell: videoCell, indexPath: (indexPaths?.last)!)
            }
        }
        if cellCount >= 2 {
            for i in 0..<cellCount{
                let cellRect = self.tableView.rectForRow(at: (indexPaths?[i])!)
                let intersect = cellRect.intersection(self.tableView.bounds)
                
                let currentHeight = intersect.height
               // print("\n \(currentHeight)")
                let cellHeight = (cells[i] as AnyObject).frame.size.height
                if currentHeight > (cellHeight * 0.95){
                    if visibleIP != indexPaths?[i]{
                        visibleIP = indexPaths?[i]
                      //  print ("visible = \(String(describing: indexPaths?[i]))")
                        if let videoCell = cells[i] as? imageCell{
                            self.playVideoOnTheCell(cell: videoCell, indexPath: (indexPaths?[i])!)
                        }
                    }
                }
                else{
                    if aboutToBecomeInvisibleCell != indexPaths?[i].row{
                        aboutToBecomeInvisibleCell = (indexPaths?[i].row)!
                        if let videoCell = cells[i] as? imageCell{
                            self.stopPlayBack(cell: videoCell, indexPath: (indexPaths?[i])!)
                        }
                        
                    }
                }
            }
        }
    }
    
    func checkVisibilityOfCell(cell : imageCell, indexPath : IndexPath){
        let cellRect = self.tableView.rectForRow(at: indexPath)
        let completelyVisible = self.tableView.bounds.contains(cellRect)
        if completelyVisible {
            self.playVideoOnTheCell(cell: cell, indexPath: indexPath)
        }
        else{
            if aboutToBecomeInvisibleCell != indexPath.row{
                aboutToBecomeInvisibleCell = indexPath.row
                self.stopPlayBack(cell: cell, indexPath: indexPath)
            }
        }
    }
    
    func playVideoOnTheCell(cell : imageCell, indexPath : IndexPath){
        cell.startPlayback()
    }
    
    func stopPlayBack(cell : imageCell, indexPath : IndexPath){
        cell.stopPlayback()
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
      //  print("end = \(indexPath)")
        if let videoCell = cell as? imageCell{
            videoCell.stopPlayback()
        }
        
        paused = true
    }
  
}
