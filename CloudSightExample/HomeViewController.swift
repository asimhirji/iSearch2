//
//  HomeViewController.swift
//  CloudSightExample
//
//  Created by Asim Hirji on 10/20/18.
//  Copyright © 2018 CloudSight, Inc. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var gifImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gifImage.loadGif(name: "blink")

        // Do any additional setup after loading the view.
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
