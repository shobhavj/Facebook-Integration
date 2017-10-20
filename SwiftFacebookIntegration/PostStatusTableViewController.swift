//
//  PostStatusTableViewController.swift
//  SwiftFacebookIntegration
//
//  Created by Shobha V J on 2017-10-18.
//  Copyright © 2017 Shobha V J. All rights reserved.
//

import UIKit

class newCell : UITableViewCell{
    
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var storyDetailsLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
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
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dateDetails.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostDetail", for: indexPath) as! newCell
        switch(typeDetails[indexPath.row]){
        
             case "video":
                if indexPath.section == 0{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "PostDetail", for: indexPath) as! newCell
                    cell.userName.text = nameFromFb
                    cell.profilePic.image = profileImage
                    cell.storyDetailsLbl.text = storyDetails[indexPath.row]
                    cell.dateLbl.text = dateDetails[indexPath.row]
                    cell.timeLbl.text = timeDetails[indexPath.row]
                    return cell
                }
       
            case "photo":
                if indexPath.section == 1{
                let cell1 :imageCell = tableView.dequeueReusableCell(withIdentifier: "ImageDetail", for: indexPath) as! imageCell
                print(indexPath.row)
                print(typeDetails[indexPath.row])
                cell1.userName1.text = nameFromFb
                cell1.profilePic1.image = profileImage
                cell1.storyDetailsLbl1.text = storyDetails[indexPath.row]
                cell1.dateLbl1.text = dateDetails[indexPath.row]
                cell1.timeLbl1.text = timeDetails[indexPath.row]
            
                for i in 0..<imageDetails.count{
                    let imageUrl = imageDetails[i]
                    let url = URL(string:imageUrl)
                    print("URL  :",(url)!)
                    DispatchQueue.global().async {
                        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                        DispatchQueue.main.async {
                            cell1.detailImageLbl1.image = UIImage(data: data!)
                        }
                    }
                }
            return cell1
            }
            
        default:
            print("Image and Videos not present")
            
        }
    return cell
    }
//        var moviePlayer : MPMoviePlayerController?
//
//        let url = NSURL (string: "http://jplayer.org/video/m4v/Big_Buck_Bunny_Trailer.m4v")
//        moviePlayer = MPMoviePlayerController(contentURL: url)
//        if let player = moviePlayer {
//            player.view.frame = CGRectMake(0, 100, view.bounds.size.width, 180)
//            player.prepareToPlay()
//            player.controlStyle = .None
//            player.repeatMode = .One
//            player.scalingMode = .AspectFit
//            cell.addSubview(player.view)
        
        
        
//        AVPlayerViewController *playerViewController = [[AVPlayerViewController alloc] init];
//        playerViewController.player = [AVPlayer playerWithURL:[[NSURL alloc] initWithString:@"http://www.ebookfrenzy.com/ios_book/movie/movie.mov"]];
//        [cell addSubview:playerViewController.view];
//        [cache setValue:cell forKey:[NSString stringWithFormat:@"key%lu", indexPath.row]];
   

}
