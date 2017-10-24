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

private var playerViewControllerKVOContext = 0

class newCell : UITableViewCell,AVPictureInPictureControllerDelegate{
   
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var storyDetailsLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var images: UIImageView!
    
}

class imageCell : UITableViewCell{
    
    @IBOutlet weak var profilePic1: UIImageView!
    @IBOutlet weak var userName1: UILabel!
    @IBOutlet weak var dateLbl1: UILabel!
    @IBOutlet weak var timeLbl1: UILabel!
    @IBOutlet weak var storyDetailsLbl1: UILabel!
    @IBOutlet weak var locationLbl1: UILabel!
    @IBOutlet weak var detailImageLbl1: UIImageView!
    
}

class linkNstatusCell : UITableViewCell{
    
    @IBOutlet weak var profilePic2: UIImageView!
    @IBOutlet weak var username2: UILabel!
    @IBOutlet weak var story: UILabel!
    @IBOutlet weak var dateLbl2: UILabel!
    @IBOutlet weak var timeLbl2: UILabel!
    @IBOutlet weak var locationLbl2: UILabel!
}
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
    var i = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.navigationItem.rightBarButtonItem = self.editButtonItem
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
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostDetail", for: indexPath) as! newCell
        //print("Details : ",typeDetails[indexPath.row])
        
        cell.userName.text = nameFromFb
        cell.profilePic.image = profileImage
        cell.storyDetailsLbl.text = storyDetails[indexPath.row]
        cell.dateLbl.text = dateDetails[indexPath.row]
        cell.timeLbl.text = timeDetails[indexPath.row]
        switch(typeDetails[indexPath.row])
        {
        case "photo":

            let imageUrl = imageDetails[i]
            let url = URL(string:imageUrl)
            let data = try? Data(contentsOf: url!)
            cell.images.isHidden = false
            cell.images.image = UIImage(data: data!)
            
            break
            
        case "video":
            cell.images.isHidden = true
            break
            
        case "link" :
            cell.storyDetailsLbl.text = linkDetails[i]
        case "status" :
        
            break
        
            default:
            break
        
        }
    
        return cell
    }
 
}
//        switch(typeDetails[indexPath.row]){
//             case "video":
//                print("Index ",(typeDetails[indexPath.row]))
//
//                    let cell = tableView.dequeueReusableCell(withIdentifier: "PostDetail", for: indexPath) as! newCell
//                    cell.userName.text = nameFromFb
//                    cell.profilePic.image = profileImage
//                    cell.storyDetailsLbl.text = storyDetails[indexPath.row]
//                    cell.dateLbl.text = dateDetails[indexPath.row]
//                    cell.timeLbl.text = timeDetails[indexPath.row]
//
//                    return cell
//
//
//            case "photo":
//
//                    print("In indexPath 1 ",(indexPath.section))
//                let cell1 :imageCell = tableView.dequeueReusableCell(withIdentifier: "ImageDetail", for: indexPath) as! imageCell
//                print(indexPath.row)
//                print(typeDetails[indexPath.row])
//                cell1.userName1.text = nameFromFb
//                cell1.profilePic1.image = profileImage
//                cell1.storyDetailsLbl1.text = storyDetails[indexPath.row]
//                cell1.dateLbl1.text = dateDetails[indexPath.row]
//                cell1.timeLbl1.text = timeDetails[indexPath.row]
//
//                for i in 0..<imageDetails.count{
//                    let imageUrl = imageDetails[i]
//                    let url = URL(string:imageUrl)
//                    print("URL  :",(url)!)
//                    let data = try? Data(contentsOf: url!)
//                    cell1.detailImageLbl1.image = UIImage(data: data!)
//
//
//                }
//            return cell1
//
//        case "link":
//            print("IndexPathSection ",indexPath.section)
//
//                let cell2 : linkNstatusCell = tableView.dequeueReusableCell(withIdentifier: "LinknStatusDetail",for: indexPath) as! linkNstatusCell
//                cell2.username2.text = nameFromFb
//                cell2.profilePic2.image = profileImage
//                cell2.dateLbl2.text = dateDetails[indexPath.row]
//                cell2.timeLbl2.text = timeDetails[indexPath.row]
//
//
//        default:
//            print("Image and Videos not present")
//
//        }
//    return cell


        
        
//        AVPlayerViewController *playerViewController = [[AVPlayerViewController alloc] init];
//        playerViewController.player = [AVPlayer playerWithURL:[[NSURL alloc] initWithString:@"http://www.ebookfrenzy.com/ios_book/movie/movie.mov"]];
//        [cell addSubview:playerViewController.view];
//        [cache setValue:cell forKey:[NSString stringWithFormat:@"key%lu", indexPath.row]];
   
   

