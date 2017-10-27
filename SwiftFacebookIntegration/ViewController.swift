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
    var sources = [String]()
    var links    = [String]()
    var dates = [String]()
    var times = [String]()
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

      //  https://graph.facebook.com/v2.10//oauth/access_token?client_id=1283177111809659&client_secret=00e6aab9e701eeeae45b218fe94f52ba&grant_type=client_credentials
        
        // https://graph.facebook.com/key=value&access_token=1283177111809659|00e6aab9e701eeeae45b218fe94f52ba
       // https://graph.facebook.com/oauth/access_token?client_id=1283177111809659&client_secret=00e6aab9e701eeeae45b218fe94f52ba&grant_type=client_credentials
       // 1283177111809659 , 00e6aab9e701eeeae45b218fe94f52ba
      //  let url1 = URL(string: "https://graph.facebook.com/oauth/access_token?client_id=" + ConfigurationManager.AppSettings["FacebookAppId"] + "&client_secret=" + ConfigurationManager.AppSettings["FacebookAppSecret"] &grant_type=client_credentials
       
        let sessionConfig: URLSessionConfiguration = URLSessionConfiguration.default
        let session: URLSession  = URLSession.init(configuration: sessionConfig)
        let url = URL(string: "https://graph.facebook.com/v2.10/me/posts?fields=story,caption,name,description,created_time,permalink_url,parent_id,with_tags,from,message,icon,link,message_tags,picture,privacy,shares,type,id,place,source&access_token=EAACEdEose0cBAGKjhlJwPS1JZAOrpvRHRbg4ZCKIcW5BTW00Fb3DsZAQvHcgII1GQDdA4HmPew2MVzpau2siQSg1K5balz2gOZApWwjsFdPKEZCfDtCUhb0ITXlOX0ShGAZBVZCWiRL040N2QKeKyLeSXxnd5C6qTf3gwWlDZAr1kIjp4rCKL5yyropi0cBLtZAAZD")!
        
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
                                       case "video":
                                            if let videoblogs = blog["source"] as? String{
                                            self.videos.append(videoblogs)
                                            }
                                       case "link":
                                            if let linkblogs = blog["name"] as? String{
                                            self.links.append(linkblogs)
                                            }
                                       case "status":
                                            if let statusblogs = blog["story"] as? String{
                                            self.status.append(statusblogs)
                                            }
                                       default:
                                            break
                                }
                                    self.types.append(type)
                                    print(self.types)
                                }

                            }
                            
                            for i in 0 ..< self.createdTimeList.count{
                                let str1 = self.createdTimeList[i]
                                let index1 = str1.index(of: "T") ?? str1.endIndex
                                let date = str1[..<index1]
                                let str2 = self.createdTimeList[i]
                                let start = str2.index(str2.startIndex, offsetBy: 11)
                                let end = str2.index(str2.endIndex, offsetBy: -8)
                                let time = str2[start..<end]
                                self.times.append(String(describing: time))
                                self.dates.append(String(describing: date))
                                
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
            postStatusController.dateDetails = dates
            postStatusController.timeDetails = times
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
