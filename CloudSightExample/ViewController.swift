//
//  ViewController.swift
//  CloudSightExample
//

import UIKit
import CloudSight

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CloudSightQueryDelegate {

    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
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
        activityIndicatorView.startAnimating()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func cloudSightQueryDidFinishUploading(_ query: CloudSightQuery!) {
        print("cloudSightQueryDidFinishUploading")
    }
    
    func cloudSightQueryDidFinishIdentifying(_ query: CloudSightQuery!) {
        print("cloudSightQueryDidFinishIdentifying")
        
        let endpoint: String = "https://westcentralus.api.cognitive.microsoft.com/vision/v2.0/analyze?visualFeatures=Description,Tags"
        let url = URL(string: endpoint)!
        var urlRequest = URLRequest(url: url)
        
        urlRequest.addValue("c4fb3cdedd9e45769814d55914da9936", forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        urlRequest.httpMethod = "POST"
        let payload: [String: Any] = ["url": "https://upload.wikimedia.org/wikipedia/commons/1/17/Dining_table_for_two.jpg"]
        let jsonPayload: Data
        do {
            jsonPayload = try JSONSerialization.data(withJSONObject: payload, options: [])
            urlRequest.httpBody = jsonPayload
            
        } catch {
            print("Error: cannot create JSON from payload")
            return
        }
        
        let session = URLSession.shared
        
        print(urlRequest)
        
        
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
                
                // CloudSight runs in a background thread, and since we're only
                // allowed to update UI in the main thread, let's make sure it does.
                DispatchQueue.main.async {
                    //self.resultLabel.text = query.name()
                    print("CloudSight API result:")
                    print(query.name())
                    print("Azure API result:")
                    print(analyzedData)
                    self.activityIndicatorView.stopAnimating()
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
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
