//
//  ViewController.swift
//  memeMe
//
//  Created by Vinicius Rocha on 5/1/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

 @objcMembers class EdidMememeController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    let textAttributes : [NSAttributedString.Key : Any] = [
        .strokeColor: UIColor.black,
        .foregroundColor: UIColor.white,
        .font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        .strokeWidth: -4.0
    ]
    
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        pickAnImage(Any.self, sourceType: .photoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        pickAnImage(Any.self, sourceType: .camera)
        
    }
    
    @IBAction func shareImage(_ sender: Any) {
        let memeImage: UIImage = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [memeImage], applicationActivities: nil)
        controller.completionWithItemsHandler = {( type, ok, items, error ) in
            if ok {
                self.save(meme: memeImage)
            }
        }
        self.present(controller, animated: true, completion: nil)
    }
    @IBAction func cancel(_ sender: Any) {
        
        imagePickerView.image = nil
        shareButton.isEnabled = false
        topTextField.text = ""
        bottomTextField.text = ""
        formatPlaceHolder(textField: topTextField, defaultText: "TOP")
        formatPlaceHolder(textField: bottomTextField, defaultText: "BOTTOM")
    
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        formatTextField(textField: topTextField, defaultText: "TOP")
        formatTextField(textField: bottomTextField, defaultText: "BOTTOM")
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        shareButton.isEnabled = (imagePickerView.image != nil)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }

    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imagePickerView.contentMode = .scaleAspectFit
            imagePickerView.image = pickedImage
            shareButton.isEnabled = true
        }
        dismiss(animated:true, completion: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        return textField.resignFirstResponder()
        
    }

    private func pickAnImage(_ sender: Any, sourceType: UIImagePickerController.SourceType ) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func formatTextField(textField: UITextField, defaultText: String){
        textField.becomeFirstResponder()
        textField.delegate = self
        textField.defaultTextAttributes = textAttributes
        textField.textAlignment = .center
        formatPlaceHolder(textField: textField, defaultText: defaultText)
       
    }
    
    private func formatPlaceHolder(textField: UITextField, defaultText: String){
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        textField.attributedPlaceholder = NSAttributedString(string: defaultText,
                                                             attributes: [NSAttributedString.Key.strokeColor: UIColor.black,
                                                                          NSAttributedString.Key.foregroundColor: UIColor.white,
                                                                          NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
                                                                          NSAttributedString.Key.strokeWidth: -4,
                                                                          NSAttributedString.Key.paragraphStyle: paragraph
            ])
    }
    
    private func hideToolbars(_ hide: Bool) {
        navBar.isHidden = hide
        toolBar.isHidden = hide
    }
    
   func subscribeToKeyboardNotifications() {
    
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(_ notification:Notification) {
        
        if (bottomTextField.isEditing){
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(_ notification:Notification) {
        
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func save(meme: UIImage) {
        // Create the meme
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView.image!, memedImage: meme)
    }
    
    func generateMemedImage() -> UIImage {
        
        hideToolbars(true)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        hideToolbars(false)
        
        return memedImage
    }
}

