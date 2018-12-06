//
//  WebViewController.swift
//  CloudSightExample
//
//  Created by Asim Hirji on 10/20/18.
//  Copyright © 2018 CloudSight, Inc. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, UINavigationControllerDelegate, WKNavigationDelegate {

    
    @IBOutlet weak var webView: WKWebView!
    var queryTerms: String = ""
    var currentWebsite: String = ""
    var triggerSearch: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let baseURLString = "https://amazon.com/s?field-keywords=" + queryTerms.replacingOccurrences(of: ",", with: "").replacingOccurrences(of: " ", with: "%20")
        //let PostURLString
        
        print("PRINT QUERY TERMS")
        print(queryTerms)
        
        webView.navigationDelegate = self
        
        let url = URL(string: baseURLString)
        let urlRequest = URLRequest(url: url!)
        currentWebsite = "Amazon"
        triggerSearch = true
        webView.load(urlRequest)
        
        
    }
    
    
    @IBAction func onClick1(_ sender: Any) {
        let baseURLString = "https://amazon.com/s?field-keywords=" + queryTerms.replacingOccurrences(of: ",", with: "").replacingOccurrences(of: " ", with: "%20")
        //let PostURLString
        
        print("PRINT QUERY TERMS")
        print(queryTerms)
        
        let url = URL(string: baseURLString)
        let urlRequest = URLRequest(url: url!)
        currentWebsite = "Amazon"
        triggerSearch = true
        webView.load(urlRequest)
    }
    
    
    @IBAction func onClick2(_ sender: Any) {
        let baseURLString = "https://a-z-animals.com/search/"
        //let PostURLString
        
        print("PRINT QUERY TERMS")
        print(queryTerms)
        
        let url = URL(string: baseURLString)
        let urlRequest = URLRequest(url: url!)
        currentWebsite = "A-Z Animals"
        triggerSearch = true
        webView.load(urlRequest)
       
    }
    
    
    @IBAction func onClick3(_ sender: Any) {
        let baseURLString = "https://yelp.com/search?find_desc=" + queryTerms.replacingOccurrences(of: ",", with: "").replacingOccurrences(of: " ", with: "%20")
        //let PostURLString
        
        print("PRINT QUERY TERMS")
        print(queryTerms)
        
        let url = URL(string: baseURLString)
        let urlRequest = URLRequest(url: url!)
        currentWebsite = "Yelp"
        triggerSearch = true
        webView.load(urlRequest)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("loaded")
        if (currentWebsite == "A-Z Animals" && triggerSearch) {
            print("SEARCHING ANIMALS")
            webView.evaluateJavaScript("document.getElementsByName('keyword')[0].value=" + "\"" + queryTerms + "\"; document.forms['az-search-form'].submit();");
            triggerSearch = false
        }
    }
    
    @IBAction func pressedBack(_ sender: Any) {
        webView.goBack()
    }
    
    
    @IBAction func pressedForward(_ sender: Any) {
        webView.goForward()
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
