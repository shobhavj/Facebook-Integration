//
//  ViewController.swift
//  SwiftFacebookIntegration
//
//  Created by Shobha V J on 2017-10-11.
//  Copyright © 2017 Shobha V J. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Foundation


class ViewController: UIViewController{
    
    var name : String?
    var userProfileImage :UIImage?
    var stories = [String]()
    var photoStories = [String]()
    var videoStories = [String]()
    var photoTime = [String]()
    var videoTime = [String]()
    var linkTime = [String]()
    var statusTime = [String]()
    var sources = [String]()
    var links    = [String]()
    var dates = [String]()
    var times = [String]()
    var datesP = [String]()
    var timesP = [String]()
    var datesV = [String]()
    var timesV = [String]()
    var datesL = [String]()
    var timesL = [String]()
    var datesS = [String]()
    var timesS = [String]()
    
    var createdTimeList = [String]()
    var locations = [String]()
    var videos = [String]()
    var images = [String]()
    var types = [String]()
    var status = [String]()
    
    @IBOutlet weak var btnFacebook: FBSDKLoginButton!
    @IBOutlet weak var ivUserProfileImage: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        btnFacebook.readPermissions = ["public_profile", "email", "user_friends"]
        fetchUserProfile()
        fetchUserStatus()
    }
    
    func fetchUserProfile(){
       
//        print("\(FBSDKAccessToken.current())")
//        let acessToken = String(format:"%@", FBSDKAccessToken.current().tokenString) as String
//        print("\(acessToken)")
        
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id, email, name, picture.width(480).height(480)"])
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            if ((error) != nil){
                print("Error took place: \(String(describing: error))")
            }
            else{
                if let data = result as? [String:Any] {
                    let id : NSString = data["id"] as! String as NSString
                    print("User ID is: \(id)")
                    if let userName = data["name"]  as? String{
                        self.lblName.text = userName
                        self.name = userName
                    }
                if let profilePictureObj = data["picture"]  as? NSDictionary{
                    let data = profilePictureObj.value(forKey: "data") as! NSDictionary
                    let pictureUrlString  = data.value(forKey: "url") as! String
                    let pictureUrl = NSURL(string: pictureUrlString)
                    let imageData = NSData(contentsOf: pictureUrl! as URL)
                            if let imageData = imageData{
                                self.userProfileImage = UIImage(data: imageData as Data)!
                                self.ivUserProfileImage.image = self.userProfileImage
                                self.ivUserProfileImage.contentMode = UIViewContentMode.scaleAspectFit
                            }
                    }
            }
        }
    })
  
}
    
    
    func fetchUserStatus() {

        let sessionConfig: URLSessionConfiguration = URLSessionConfiguration.default
        let session: URLSession  = URLSession.init(configuration: sessionConfig)
        
        //hardcoding access token
      let url = URL(string: "https://graph.facebook.com/v2.10/me/posts?fields=story,caption,name,description,created_time,permalink_url,parent_id,with_tags,from,message,icon,link,message_tags,picture,privacy,shares,type,id,place,source&access_token=EAACEdEose0cBAARrG1jotNZA1gQcNooPhevJsINhTSCH3d1TIYFVoBT2mE6FjIWzmZBMeoMW90afjFiNAZBNOe39ZCCqlhZBPcfqZBswsPZBUSxmmtx0Bq8aZCh0tnKFYsxEpCCbVnZBJzn8kOtE5vvlNDMvjoxpkHmzhlTJjJvK6EZAepkYTOSNFXybUw9W96ZB84ZD")!
        
        
        let task: URLSessionDataTask =
            session.dataTask(with: url) { (data, response, error) in
               do {
                        if let data = data,
                            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                            let blogs = json["data"] as? [[String: Any]] {
                            for blog in blogs {
                                
                                if let story = blog["story"] as? String {
                                    self.stories.append(story)
                                }
                            
                                if let createdTime = blog["created_time"] as? String{
                                    self.createdTimeList.append(createdTime)
                                }
                                
                                if let type = blog["type"] as? String{
                                    
                                   switch(type) {
                                       case "photo" :
                                            if let photoblogs = blog["picture"] as? String{
                                            self.images.append(photoblogs)
                                            }
                                            if let story = blog["story"] as? String {
                                                self.photoStories.append(story)
                                            }
                                            if let timeP = blog["created_time"] as? String{
                                                self.photoTime.append(timeP)
                                            }
                                        case "video":
                                            if let videoblogs = blog["source"] as? String{
                                            self.videos.append(videoblogs)
                                            }
                                            if let story = blog["story"] as? String {
                                                self.videoStories.append(story)
                                            }
                                            if let timeV = blog["created_time"] as? String{
                                                self.videoTime.append(timeV)
                                            }
                                       case "link":
                                            if let linkblogs = blog["name"] as? String{
                                            self.links.append(linkblogs)
                                            }
                                            if let timeL = blog["created_time"] as? String{
                                                self.linkTime.append(timeL)
                                            }
                                       case "status":
                                            if let statusblogs = blog["story"] as? String{
                                            self.status.append(statusblogs)
                                            }
                                            if let timeS = blog["created_time"] as? String{
                                                self.statusTime.append(timeS)
                                            }
                                       default:
                                            break
                                }
                                    self.types.append(type)
                                    print(self.types)
                                }

                            }
                            //getting date and time
                            for i in 0 ..< self.createdTimeList.count{
                                let str1 = self.createdTimeList[i]
                                let index1 = str1.index(of: "T") ?? str1.endIndex
                                let date = str1[..<index1]
                                let str2 = self.createdTimeList[i]
                                let start = str2.index(str2.startIndex, offsetBy: 11)
                                let end = str2.index(str2.endIndex, offsetBy: -8)
                                let time = str2[start..<end]
                                self.timesP.append(String(describing: time))
                                self.datesP.append(String(describing: date))
                                }
                            for i in 0 ..< self.videoTime.count{
                                let str1 = self.videoTime[i]
                                let index1 = str1.index(of: "T") ?? str1.endIndex
                                let date = str1[..<index1]
                                let str2 = self.videoTime[i]
                                let start = str2.index(str2.startIndex, offsetBy: 11)
                                let end = str2.index(str2.endIndex, offsetBy: -8)
                                let time = str2[start..<end]
                                self.timesV.append(String(describing: time))
                                self.datesV.append(String(describing: date))
                            }
                            for i in 0 ..< self.linkTime.count{
                                let str1 = self.linkTime[i]
                                let index1 = str1.index(of: "T") ?? str1.endIndex
                                let date = str1[..<index1]
                                let str2 = self.linkTime[i]
                                let start = str2.index(str2.startIndex, offsetBy: 11)
                                let end = str2.index(str2.endIndex, offsetBy: -8)
                                let time = str2[start..<end]
                                self.timesL.append(String(describing: time))
                                self.datesL.append(String(describing: date))
                            }
                            for i in 0 ..< self.statusTime.count{
                                let str1 = self.statusTime[i]
                                let index1 = str1.index(of: "T") ?? str1.endIndex
                                let date = str1[..<index1]
                                let str2 = self.statusTime[i]
                                let start = str2.index(str2.startIndex, offsetBy: 11)
                                let end = str2.index(str2.endIndex, offsetBy: -8)
                                let time = str2[start..<end]
                                self.timesS.append(String(describing: time))
                                self.datesS.append(String(describing: date))
                            }
                            }
                    } catch {
                        print("Error deserializing JSON: \(error)")
                    }
        }
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "postSegue"{
        if let postStatusController = segue.destination as? PostStatusTableViewController {
            postStatusController.nameFromFb = name
            postStatusController.profileImage = userProfileImage
            postStatusController.storyDetails = stories
            postStatusController.photoStoryDetails = photoStories
            postStatusController.videoStoryDetails = videoStories
            postStatusController.dateDetailsPhoto = datesP
            postStatusController.timeDetailsPhoto = timesP
            postStatusController.dateDetailsVideo = datesV
            postStatusController.timeDetailsVideo = timesV
            postStatusController.dateDetailsLink = datesL
            postStatusController.timeDetailsLink = timesL
            postStatusController.dateDetailsStatus = datesS
            postStatusController.timeDetailsStatus = timesS
            
            postStatusController.locationDetails = locations
            postStatusController.imageDetails = images
            postStatusController.videoDetails = videos
            postStatusController.linkDetails = links
            postStatusController.typeDetails = types
            postStatusController.statusDetails = status
            
            }
        }
    }


}
