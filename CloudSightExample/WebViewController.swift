//
//  WebViewController.swift
//  CloudSightExample
//
//  Created by Asim Hirji on 10/20/18.
//  Copyright © 2018 CloudSight, Inc. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, UINavigationControllerDelegate {

    
    @IBOutlet weak var webView: WKWebView!
    var queryTerms: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let baseURLString = "https://www.homedepot.com/s/" + queryTerms.replacingOccurrences(of: ",", with: "").replacingOccurrences(of: " ", with: "%2520")
        //let PostURLString
        
        print("PRINT QUERY TERMS")
        print(queryTerms)
        
        let url = URL(string: baseURLString)
        let urlRequest = URLRequest(url: url!)
        webView.load(urlRequest)
        
        
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
