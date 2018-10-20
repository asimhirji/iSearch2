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
    static func AzureURLRequest(image: UIImage) -> URLRequest {
        var r  = URLRequest(url: URL(string: "https://westcentralus.api.cognitive.microsoft.com/vision/v2.0/ocr?language=en")!)
        r.httpMethod = "POST"
        let boundary = "Boundary-\(UUID().uuidString)"
        
        // Set headers
        r.setValue("dce9f46b13364b7fba1c1bcbdbe5f2b3", forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
        r.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        // Set body
        let httpBody = NSMutableData()
        httpBody.appendString("--" + boundary)
        httpBody.appendString("Content-Disposition: form-data; name=\"image_request[image]\"; filename=\"image.jpg\"\r\n")
        httpBody.appendString("Content-Type: image/jpeg\r\n\r\n")
        httpBody.append(image.jpegData(compressionQuality: 0.9)!)
        httpBody.appendString("\r\n")
        httpBody.appendString("--" + boundary + "--")
        
        r.httpBody = httpBody as Data
        
        return r
    }
}
