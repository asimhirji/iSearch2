//
//  WebViewController.swift
//  CloudSightExample
//
//  Created by Asim Hirji on 10/20/18.
//  Copyright © 2018 CloudSight, Inc. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let baseURLString = "https://www.homedepot.com/"
        //let PostURLString
        
        //let url = URL(string: baseURLString + PostURLString)
        //let URLRequest = URLRequest(url: url)
        //webView.loadRequest(URLRequest)
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
