//
//  ViewController.swift
//  CloudSightExample
//
import UIKit
import CloudSight

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CloudSightQueryDelegate {

    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    var cloudsightQuery: CloudSightQuery!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CloudSightConnection.sharedInstance().consumerKey = "C38_disOS8RllVk3OQ5cDw";
        CloudSightConnection.sharedInstance().consumerSecret = "HAwGhA4TNmqOo0morWWYpA";
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    struct Tag: Decodable {
        let confidence: String
        let name: String
    }

    @IBAction func cameraButtonPressed(_ sender: Any) {

        // Check to see if the Camera is available
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()

            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false

            // Show the UIImagePickerController view
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            print("Cannot access the camera");
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        self.resultLabel.text = ""
        // Dismiss the UIImagePickerController
        self.dismiss(animated: true, completion: nil)
        
        // Assign the image reference to the image view to display
        let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as! UIImage
        imageView.image = image
        
        // Create JPG image data from UIImage
        let imageData = image.jpegData(compressionQuality: 0.8)
        
        cloudsightQuery = CloudSightQuery(image: imageData,
                                          atLocation: CGPoint.zero,
                                          withDelegate: self,
                                          atPlacemark: nil,
                                          withDeviceId: "device-id")
        
        
        
        cloudsightQuery.start()
        submitButton.isHidden = true
        activityIndicatorView.startAnimating()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func cloudSightQueryDidFinishUploading(_ query: CloudSightQuery!) {
        print("cloudSightQueryDidFinishUploading")
    }
    
    func createUrlRequest(
        data:NSData) -> URLRequest {
        
        let url: NSURL = NSURL(string: "https://westcentralus.api.cognitive.microsoft.com/vision/v2.0/analyze?language=en&visualFeatures=tags")!
        let request1: NSMutableURLRequest = NSMutableURLRequest(url: url as URL)
        
        request1.httpMethod = "POST"
        
        let boundary = "looooooooool"
        let fullData = photoDataToFormData(data: data,boundary:boundary,fileName:"image.jpeg")
        
        request1.setValue("dce9f46b13364b7fba1c1bcbdbe5f2b3",
                          forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
        
        request1.setValue("multipart/form-data; boundary=" + boundary,
                          forHTTPHeaderField: "Content-Type")
        
        
        // REQUIRED!
        request1.setValue(String(fullData.length), forHTTPHeaderField: "Content-Length")
        
        request1.httpBody = fullData as Data
        request1.httpShouldHandleCookies = false
        
        return request1 as URLRequest
    }
    
    // this is a very verbose version of that function
    // you can shorten it, but i left it as-is for clarity
    // and as an example
    func photoDataToFormData(data:NSData,boundary:String,fileName:String) -> NSData {
        var fullData = NSMutableData()
        
        // 1 - Boundary should start with --
        let lineOne = "--" + boundary + "\r\n"
        fullData.append(lineOne.data(
            using: String.Encoding.utf8,
            allowLossyConversion: false)!)
        
        // 2
        let lineTwo = "Content-Disposition: form-data; name=\"image\"; filename=\"" + fileName + "\"\r\n"
        NSLog(lineTwo)
        fullData.append(lineTwo.data(
            using: String.Encoding.utf8,
            allowLossyConversion: false)!)
        
        // 3
        let lineThree = "Content-Type: image/jpg\r\n\r\n"
        fullData.append(lineThree.data(
            using: String.Encoding.utf8,
            allowLossyConversion: false)!)
        
        // 4
        fullData.append(data as Data)
        
        // 5
        let lineFive = "\r\n"
        fullData.append(lineFive.data(
            using: String.Encoding.utf8,
            allowLossyConversion: false)!)
        
        // 6 - The end. Notice -- at the start and at the end
        let lineSix = "--" + boundary + "--\r\n"
        fullData.append(lineSix.data(
            using: String.Encoding.utf8,
            allowLossyConversion: false)!)
        
        return fullData
    }
    
    func cloudSightQueryDidFinishIdentifying(_ query: CloudSightQuery!) {
        print("cloudSightQueryDidFinishIdentifying")
        
        let image :UIImage = UIImage(data: query.image!)!
        let urlRequest = createUrlRequest(data: query.image! as NSData)
        
        let session = URLSession.shared
        
        
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            guard error == nil else {
                print("error calling POST on Azure's Computer Vision API")
                print(error!)
                return
            }
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            
            // parse the result as JSON, since that's what the API provides
            do {
                guard let analyzedData = try JSONSerialization.jsonObject(with: responseData,
                                                                          options: []) as? [String: Any] else {
                                                                            print("Could not get JSON from responseData as dictionary")
                                                                            return
                }
                //mark
                // CloudSight runs in a background thread, and since we're only
                // allowed to update UI in the main thread, let's make sure it does.
                DispatchQueue.main.async {
                    //self.resultLabel.text = query.name()
                    print("CloudSight API result:")
                    print(query.name())
                    print("Azure API result:")
                    print(analyzedData)
                    
                    var label : String = query.name()
                    
                    for tag in analyzedData["tags"] as! [Any] {
                        print("TAAAG")
                        let parsedTag = tag as! NSDictionary
                        if (parsedTag["confidence"] as! Float) >= 0.99 {
                            label += ", " + (parsedTag["name"] as! String)
                        }
                        }
                    
                    self.activityIndicatorView.stopAnimating()
                    self.resultLabel.text = label
                    self.submitButton.isHidden = false
                    
                }
                
            } catch  {
                print("error parsing response from POST on /todos")
                return
            }
        }
        task.resume()
        
    }
    
    func cloudSightQueryDidFail(_ query: CloudSightQuery!, withError error: Error!) {
        print("CloudSight Failure: \(error)")
    }

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
}
