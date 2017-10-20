//
//  WebViewController.swift
//  SwiftFacebookIntegration
//
//  Created by Shobha V J on 2017-10-16.
//  Copyright © 2017 Shobha V J. All rights reserved.
//

import UIKit


class WebViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL (string: "http://www.facebook.com/1686314748079810");
        let requestObj = URLRequest(url:url!);
        webView.loadRequest(requestObj);
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
