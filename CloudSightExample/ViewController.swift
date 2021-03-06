//
//  ViewController.swift
//  CloudSightExample
//
import UIKit
import CloudSight

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CloudSightQueryDelegate {
    
    
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var libraryButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    var cloudsightQuery: CloudSightQuery!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        submitButton.isHidden = true
        
        
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
    
    @IBAction func libraryButtonPressed(_ sender: Any) {
        let image = UIImagePickerController()
        image.delegate = self
        
        image.sourceType = UIImagePickerController.SourceType.photoLibrary
        image.allowsEditing = false
        
        self.present(image, animated: true) {
            
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
        cameraButton.isHidden = true
        libraryButton.isHidden = true
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
        
        let boundary = "byte-data-separator"
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
                //mark
                // CloudSight runs in a background thread, and since we're only
                // allowed to update UI in the main thread, let's make sure it does.
                DispatchQueue.main.async {
                    //self.resultLabel.text = query.name()
                    print("CloudSight API result:")
                    print(query.name())
                    
                    var label : String = query.name()
                    
                    
                    self.activityIndicatorView.stopAnimating()
                    self.resultLabel.text = label
                    self.submitButton.isHidden = false
                    self.cameraButton.isHidden = false
                    self.libraryButton.isHidden = false
                    
                    self.imageView.sendSubviewToBack(self.imageView)
                    self.resultLabel.bringSubviewToFront(self.resultLabel)
                    
                }
        
    }
    
    func cloudSightQueryDidFail(_ query: CloudSightQuery!, withError error: Error!) {
        print("CloudSight Failure: \(error)")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is WebViewController
        {
            let vc = segue.destination as? WebViewController
            vc?.queryTerms = self.resultLabel.text!
            print("SEND TO WVC")
            print(self.resultLabel.text!)
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
}
