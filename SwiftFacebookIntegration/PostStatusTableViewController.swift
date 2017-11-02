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
    var dateDetails = [String]()
    var timeDetails = [String]()
    var locationDetails = [String]()
    var imageDetails = [String]()
    var videoDetails = [String]()
    var typeDetails = [String]()
    var statusDetails = [String]()
    var photoArray = [String]()
    var videoArray = [String]()
    var linkArray = [String]()
    var statusArray = [String]()
    var combinedArray = [String]()
   
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
        
        if j < typeDetails.count{
            switch(typeDetails[j]){
                
            case "photo":
                photoArray.append(typeDetails[j])
            case "video":
                videoArray.append(typeDetails[j])
            case "link":
                linkArray.append(typeDetails[j])
            case "status":
                statusArray.append(typeDetails[j])
            default:
                print ("Default")
            }
            j = j + 1
        }
      
        for p in  photoArray{
            print(p)
        }
        combinedArray = photoArray
       
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
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
        
        print("Row", indexPath.row)
        switch(typeDetails[indexPath.row]){
        case "photo" :
                var ip1 = IndexPath(row: 0, section: 0)
                ip1.section = 0
                let cell = tableView.dequeueReusableCell(withIdentifier: "ImageDetail", for:ip1) as! imageCell
                if(im < imageDetails.count){
                    let imageUrl = imageDetails[im]
                    let url = URL(string:imageUrl)
                    let data = try? Data(contentsOf: url!)
                    cell.storyDetailsLbl1.text = photoStoryDetails[im]
                    cell.images1.image = UIImage(data: data!)
                }
                im = im + 1
                i = i + 1
                return cell
      
        case "video" :
                var ip2 = IndexPath(row: 0, section: 0)
                ip2.section = 1
                let cell1 = tableView.dequeueReusableCell(withIdentifier: "VideoCell", for: ip2) as! videoPlayerCell
                cell1.videoView.isHidden = false
                if  vd < videoURLs.count{
                    let urls = videoURLs[vd]
                    cell1.videoPlayerItem = AVPlayerItem.init(url: urls)
                    cell1.videoLabel.text = videoStoryDetails[vd]
                }
                vd = vd + 1
                i = i + 1
                return cell1
        
        case "link":
                var ip3 = IndexPath(row: 0, section: 0)
                ip3.section = 2
                let cell2 = tableView.dequeueReusableCell(withIdentifier: "LinkCell", for: ip3) as! linkCell
                if  ln < linkDetails.count {
                    cell2.linkLbl.text = linkDetails[ln]
                   
                }
                ln = ln + 1
                i = i + 1
                return cell2
        
        default:
                var ip4 = IndexPath(row: 0, section: 0)
                ip4.section = 3
                 let cell3 = tableView.dequeueReusableCell(withIdentifier: "StatusCell", for: ip4) as! statusCell
                    if  st < statusDetails.count{
                        cell3.statusLbl.text = statusDetails[st]
                    }
                    st = st + 1
                     i = i + 1
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
            else{
                if let imagesCell = self.tableView.cellForRow(at: ip) as?imageCell{
                cells.append(imagesCell)
                }
            }
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
