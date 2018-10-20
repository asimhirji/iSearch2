//
//  ApiQuery.swift
//  CloudSightExample
//
//  Created by Xu Xinyi on 2018/10/19.
//  Copyright © 2018 CloudSight, Inc. All rights reserved.
//

import Foundation
import UIKit

extension NSMutableData {
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        append(data!)
    }
}

class ApiQuery {
    func CloudSightURLRequest(image: UIImage) -> URLRequest {
        var r  = URLRequest(url: URL(string: "https://api.cloudsight.ai/v1/images")!)
        r.httpMethod = "POST"
        let boundary = "Boundary-\(UUID().uuidString)"
        
        // Set headers
        r.setValue("CloudSight C38_disOS8RllVk3OQ5cDw", forHTTPHeaderField: "Authorization")
        r.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        // Set body
        r.httpBody = NSMutableData()
        r.httpBody.appendString("--" + boundary)
        r.httpBody.appendString("Content-Disposition: form-data; name=\"image_request[image]\"; filename=\"image.jpg\"\r\n")
        r.httpBody.appendString("Content-Type: image/jpeg\r\n\r\n")
        r.httpBody.append(UIImageJPEGRepresentation(image, 1.0))
        r.httpBody.appendString("\r\n")
        r.httpBody.appendString("--" + boundary + "--")
    }
    
    func AzureURLRequest(image: UIImage) -> URLRequest {
        var r  = URLRequest(url: URL(string: "https://westus.api.cognitive.microsoft.com/vision/v2.0/ocr?language=en")!)
        r.httpMethod = "POST"
        let boundary = "Boundary-\(UUID().uuidString)"
        
        // Set headers
        r.setValue("c4fb3cdedd9e45769814d55914da9936", forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
        r.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        // Set body
        r.httpBody = NSMutableData()
        r.httpBody.appendString("--" + boundary)
        r.httpBody.appendString("Content-Disposition: form-data; name=\"image_request[image]\"; filename=\"image.jpg\"\r\n")
        r.httpBody.appendString("Content-Type: image/jpeg\r\n\r\n")
        r.httpBody.append(UIImageJPEGRepresentation(image, 1.0))
        r.httpBody.appendString("\r\n")
        r.httpBody.appendString("--" + boundary + "--")
    }
}
