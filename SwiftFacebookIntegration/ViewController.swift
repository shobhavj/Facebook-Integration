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
    
    var accessToken: FBSDKAccessToken?
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
    
    @IBOutlet weak var btnFacebook: FBSDKLoginButton!
    @IBOutlet weak var ivUserProfileImage: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnFacebook.readPermissions = ["public_profile", "email", "user_friends"];
     
        if let _ = FBSDKAccessToken.current()
        {
            fetchUserProfile()
        }
        fetchUserStatus()
    }
    
    func fetchUserProfile()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id, email, name, picture.width(480).height(480)"])
        
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                print("Error took place: \(String(describing: error))")
            }
            else
            {
          //      print("Print entire fetched result: \(String(describing: result))")
                if let data = result as? [String:Any] {
                    let id : NSString = data["id"] as! String as NSString
           //     print("User ID is: \(id)")
                if let userName = data["name"]  as? String
                {
                    self.lblName.text = userName
                   self.name = userName
                }
                if let profilePictureObj = data["picture"]  as? NSDictionary
                {
                    let data = profilePictureObj.value(forKey: "data") as! NSDictionary
                    let pictureUrlString  = data.value(forKey: "url") as! String
                    let pictureUrl = NSURL(string: pictureUrlString)
                    let imageData = NSData(contentsOf: pictureUrl! as URL)
                            if let imageData = imageData
                            {
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
      
        //accessToken = FBSDKAccessToken.current()
        let sessionConfig: URLSessionConfiguration = URLSessionConfiguration.default
        let session: URLSession  = URLSession.init(configuration: sessionConfig)

         let acessToken = String(format:"%@", FBSDKAccessToken.current().tokenString) as String
       //  print("ACESSS TOKEN     :", (acessToken))
       
        let url = URL(string: "https://graph.facebook.com/v2.10/me/posts?fields=story,caption,name,description,created_time,permalink_url,parent_id,with_tags,from,message,icon,link,message_tags,picture,privacy,shares,type,id,place,source&access_token=EAACEdEose0cBAPq7GZBlreJOVHvTZAKkkQbMdwMBZB8lh9dlQAJAtChSJPfVgNkaqgNGpYZAri7szCP0ZBoDaa4L137dPFInsYAzRTTszmSdYsJrFanRF3MSinEhFzKF61ZADAZC3tjv8LTYyjpPZCHwpm9O4XlIenOScdtbgJmmR7GDiSeVeXkHElbclQZBjBmQZD")!
        
      //    Uri targetUri = new Uri("https://graph.facebook.com/oauth/access_token?client_id=" + ConfigurationManager.AppSettings["FacebookAppId"] + "&client_secret=" + ConfigurationManager.AppSettings["FacebookAppSecret"] + "&redirect_uri=http://" + Request.ServerVariables["SERVER_NAME"] + ":" + Request.ServerVariables["SERVER_PORT"] + "/account/user.aspx&code=" + code);
        
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

                                if let place = blog["place"] as?  [[String: Any]] {
                                    for places in place{
                                        if let location = places["location"] as? [[String: Any]] {
                                            for loc in location{
                                                if let city = loc["city"] as? String{
                                                  print("CITY   ",(city))
                                                    self.locations.append(city)
                                                   print(self.locations)
                                                }
                                                if let country = loc["country"] as? String{
                                               print("COUNTRY  ",(country))
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                if let type = blog["type"] as? String{
                                   // print("BLOG",type)
                                    
                                    if "photo" == type {
                                    //    print(blog["picture"]!)
                                        if let photoblogs = blog["picture"] as? String{
                                            self.images.append(photoblogs)
                                            
                                    }
                                    }
                                    
                                    else if "video" == type{
                                        if let videoblogs = blog["source"] as? String{
                                            self.videos.append(videoblogs)
                                         
                                        }
                                    }
                                    else if "link" == type{

                                        if let linkblogs = blog["name"] as? String{
                                            self.links.append(linkblogs)
                                            
                                        }
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
            }
        }
    }


}
