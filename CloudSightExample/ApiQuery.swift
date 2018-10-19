//
//  ApiQuery.swift
//  CloudSightExample
//
//  Created by Xu Xinyi on 2018/10/19.
//  Copyright © 2018 CloudSight, Inc. All rights reserved.
//

import Foundation
import UIKit

class ApiQuery {
    var image : UIImage!
    var endpoint : String!
    var headers : [(name: String, value: String)]!
    var key : String!
    
    
}

class CloudSightApiQuery : ApiQuery {
    init(image: UIImage){
        super.init()
        self.image = image
        self.endpoint = "https://api.cloudsight.ai/v1/images"
        self.headers = [(name: "authorization", value: "CloudSight C38_disOS8RllVk3OQ5cDw"),
                        (name: "cache-control", value: "no-cache"),
                        (name: "content-type" , value: "application/json")]
        
    }
}
