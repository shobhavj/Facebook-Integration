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
    var photoStoryDetails = [String]()
    var videoStoryDetails = [String]()
    var sourceDetails = [String]()
    var linkDetails = [String]()
    var dateDetailsPhoto = [String]()
    var timeDetailsPhoto = [String]()
    var dateDetailsVideo = [String]()
    var timeDetailsVideo = [String]()
    var dateDetailsLink = [String]()
    var timeDetailsLink = [String]()
    var dateDetailsStatus = [String]()
    var timeDetailsStatus = [String]()
    var locationDetails = [String]()
    var imageDetails = [String]()
    var videoDetails = [String]()
    var typeDetails = [String]()
    var statusDetails = [String]()
    var photoArray = [String]()
    var videoArray = [String]()
    var linkArray = [String]()
    var statusArray = [String]()
    var combinedArray =  [[String]]()
    
   
    var avPlayer: AVPlayer!
    var visibleIP : IndexPath?
    var aboutToBecomeInvisibleCell = -1
    var avPlayerLayer: AVPlayerLayer!
    var paused: Bool = false
    var videoURLs = Array<URL>()
    var firstLoad = true
    var numberOfRowsAtSection = [Int]()
    
    var i = 0
    var im = 0
    var vd = 0
    var ln = 0
    var st = 0
    var j = 0
    var p = 0
    
    var ip = IndexPath(row: 0, section: 0)
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
        
        numberOfRowsAtSection = [imageDetails.count,videoURLs.count,linkDetails.count,statusDetails.count]
        print("NumberofRowsatSectionarray",numberOfRowsAtSection)
        
       while j < typeDetails.count{
            if (typeDetails[j] == "photo"){
                print("In Photo",typeDetails[j])
                photoArray.append(typeDetails[j])
            }
            
            if (typeDetails[j] == "video"){
                print("In Video",typeDetails[j])
                videoArray.append(typeDetails[j])
            }
            if(typeDetails[j] == "link"){
                 print("In LInk",typeDetails[j])
                linkArray.append(typeDetails[j])
            }
            if(typeDetails[j] == "status"){
                print("In LInk",typeDetails[j])
                statusArray.append(typeDetails[j])
               
            }
            j = j + 1
            }

        combinedArray.append(photoArray)
        combinedArray.append(videoArray)
        combinedArray.append(linkArray)
        combinedArray.append(statusArray)
        print("combined array",combinedArray)
        //self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
   
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        if section == 2 {
            return 100.0
        }
        else if section == 3{
            return 100.0
        }
        return 383.0
       
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var rows : Int = 0
        if section < numberOfRowsAtSection.count{
            rows = numberOfRowsAtSection[section]
            print(section,rows)
        }
        return rows
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("Section,Row",indexPath.section, indexPath.row)
        switch(combinedArray[indexPath.section][indexPath.row]){
        case "photo" :
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImageDetail", for:indexPath) as! imageCell
                if(im < imageDetails.count){
                    let imageUrl = imageDetails[im]
                    let url = URL(string:imageUrl)
                    let data = try? Data(contentsOf: url!)
                    cell.storyDetailsLbl1.text = photoStoryDetails[im]
                    cell.profilePic1.image = profileImage
                    cell.dateLbl1.text = dateDetailsPhoto[im]
                    cell.timeLbl1.text = timeDetailsPhoto[im]
                    cell.userName1.text = nameFromFb
                    print(imageDetails[im])
                    cell.images1.image = UIImage(data: data!)
                }
                im = im + 1
                return cell
            
        case "video" :
                let cell1 = tableView.dequeueReusableCell(withIdentifier: "VideoCell", for: indexPath) as! videoPlayerCell
                cell1.videoView.isHidden = false
                if  vd < videoURLs.count{
                    let urls = videoURLs[vd]
                    cell1.profilePicVideo.image = profileImage
                    cell1.videoPlayerItem = AVPlayerItem.init(url: urls)
                    cell1.videoLabel.text = videoStoryDetails[vd]
                    cell1.username2.text = nameFromFb
                    cell1.dateLbl2.text =  dateDetailsVideo[vd]
                    cell1.timeLbl2.text = timeDetailsVideo[vd]
                    print("Video",cell1.videoLabel.text!)
                }
                vd = vd + 1
                return cell1
        
        case "link":
                let cell2 = tableView.dequeueReusableCell(withIdentifier: "LinkCell", for: indexPath) as! linkCell
                if  ln < linkDetails.count {
                    cell2.profilePicLink.image = profileImage
                    cell2.linkLbl.text = linkDetails[ln]
                    cell2.username3.text = nameFromFb
                    cell2.dateLbl3.text =  dateDetailsLink[ln]
                    cell2.timeLbl3.text = timeDetailsLink[ln]
                    
                    
                }
                ln = ln + 1
                return cell2
        
        default:
                 let cell3 = tableView.dequeueReusableCell(withIdentifier: "StatusCell", for: indexPath) as! statusCell
                 if  st < statusDetails.count{
                        cell3.profilePicStatus.image = profileImage
                        cell3.statusLbl.text = statusDetails[st]
                        cell3.username4.text = nameFromFb
                        cell3.dateLbl4.text = dateDetailsStatus[st]
                        cell3.timeLbl4.text = timeDetailsStatus[st]
                 }
                    st = st + 1
                    return cell3
        }
        
    }
    
    @objc func playerItemDidReachEnd(notification: Notification) {
        let p: AVPlayerItem = notification.object as! AVPlayerItem
        p.seek(to: kCMTimeZero, completionHandler: nil)
    }
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let indexPaths = self.tableView.indexPathsForVisibleRows
        var cells = [Any]()
        for ip in indexPaths!{
            if let videoCell = self.tableView.cellForRow(at: ip) as?videoPlayerCell{
                cells.append(videoCell)
            }
//            else{
//                if let imagesCell = self.tableView.cellForRow(at: ip) as?imageCell{
//                cells.append(imagesCell)
//                }
//            }
        }
        let cellCount = cells.count
        if cellCount == 0 {return}
        if cellCount == 1{
            //print ("visible = \(String(describing: indexPaths?[0]))")
            if visibleIP != indexPaths?[0]{
                visibleIP = indexPaths?[0]
            }
            if let videoCell = cells.last! as? videoPlayerCell{
                self.playVideoOnTheCell(cell: videoCell, indexPath: (indexPaths?.last)!)
            }
        }
        if cellCount >= 2{
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
                        if let videoCell = cells[i] as? videoPlayerCell{
                            self.playVideoOnTheCell(cell: videoCell, indexPath: (indexPaths?[i])!)
                        }
                    }
                }
                else{
                    if aboutToBecomeInvisibleCell != indexPaths?[i].row{
                        aboutToBecomeInvisibleCell = (indexPaths?[i].row)!
                        if let videoCell = cells[i] as? videoPlayerCell{
                            self.stopPlayBack(cell: videoCell, indexPath: (indexPaths?[i])!)
                        }
                        
                    }
                }
            }
        }
    }
    
    func checkVisibilityOfCell(cell : videoPlayerCell, indexPath : IndexPath){
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
    
    func playVideoOnTheCell(cell : videoPlayerCell, indexPath : IndexPath){
        cell.startPlayback()
    }
    
    func stopPlayBack(cell : videoPlayerCell, indexPath : IndexPath){
        cell.stopPlayback()
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
      //  print("end = \(indexPath)")
        if let videoCell = cell as? videoPlayerCell{
            videoCell.stopPlayback()
        }
        
        paused = true
    }
  
}
