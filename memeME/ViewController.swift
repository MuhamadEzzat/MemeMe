//
//  ViewController.swift
//  MEME
//
//  Created by Mohamed Ezzat on 10/12/21.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var libraryButton: UIBarButtonItem!
    @IBOutlet weak var camerButton: UIBarButtonItem!
    @IBOutlet weak var topTF: UITextField!
    @IBOutlet weak var imageViewPicker: UIImageView!
    @IBOutlet weak var navbaar: UINavigationItem!
    @IBOutlet weak var bottomTF: UITextField!
    @IBOutlet weak var mytoolbar: UIToolbar!
    @IBOutlet weak var shareBtn: UIBarButtonItem!
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth:  -2
    ]
    
    let items = [UIImage]()
    
    var memedImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        print(appDelegate.memes.count,"TRTR")
        setupTextField(topTF, text: "TOP")
        setupTextField(bottomTF, text: "BOTTOM")
        
        navigationController?.setNavigationBarHidden(navigationController?.isNavigationBarHidden == true, animated: true)
        self.shareBtn
        
        self.topTF.delegate = self
        self.bottomTF.delegate = self

    }
    
    func setupTextField(_ textField: UITextField, text: String) {
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.text = text
    }
    
    override func viewWillAppear(_ animated: Bool) {
        camerButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    @IBAction func captureImage(_ sender: Any) {
        presentPickerViewController(source: .camera)
    }
    
    @IBAction func pickImage(_ sender: Any) {
        presentPickerViewController(source: .photoLibrary)
    }
    
    @IBAction func shareImgBtn(_ sender: Any) {
        shareImage()
    }
    @IBAction func cancelBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
//        let vc = storyboard?.instantiateViewController(withIdentifier: "SentMemesTableViewController") as! SentMemesTableViewController
//        navigationController?.pushViewController(vc, animated: true)
    }
    
    func presentPickerViewController(source: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let activityinstance = UIActivityViewController(activityItems: items, applicationActivities: nil)
        
        if let image = info[.originalImage] as? UIImage {
            imageViewPicker.image = image
            dismiss(animated: true, completion: nil)
                }
        activityinstance.completionWithItemsHandler = {
            (activity, completed, items, error) in
            if completed {
                self.save()
                print("SAVE")
            }
        }
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if bottomTF.isFirstResponder{
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {

        view.frame.origin.y -= 0
    }

    func getKeyboardHeight(_ notification:Notification) -> CGFloat {

        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications() {

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }

    func unsubscribeFromKeyboardNotifications() {

        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        unsubscribeFromKeyboardNotifications()
        
        return true
    }

    
    func generateMemedImage() -> UIImage {

        // TODO: Hide toolbar and navbar
        self.hideAndShowBars(navbar: self.navigationController!.navigationBar, toolbar: mytoolbar, hide: true)
        

        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        self.imageViewPicker.image = memedImage
        // TODO: Show toolbar and navbar
        self.hideAndShowBars(navbar: self.navigationController!.navigationBar, toolbar: mytoolbar, hide: false)
        
        self.memedImage = memedImage

        return memedImage
    }
    
    func hideAndShowBars(navbar: UINavigationBar, toolbar: UIToolbar, hide: Bool){
        navbar.isHidden = hide
        toolbar.isHidden = hide
    }
    
    func save() {
        
            // Create the meme
            let meme = Meme(topText: topTF.text!, bottomText: bottomTF.text!, originalImage: imageViewPicker.image!, memedImage: generateMemedImage())
        // Add it to the memes array in the Application Delegate
           let object = UIApplication.shared.delegate
           let appDelegate = object as! AppDelegate
           appDelegate.memes.append(meme)
        
        print(appDelegate.memes, "Trrwew")
//        UserDefaults.standard.set(appDelegate.memes, forKey: "MemeSaved")
    }
    
    @objc func shareImage(){
        let image = generateMemedImage()
        
        // set up activity view controller
        let imageToShare = [ image ]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        self.save()
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }

}

