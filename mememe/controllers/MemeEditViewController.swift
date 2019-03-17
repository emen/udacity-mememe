//
//  MemeEditViewController.swift
//
//  Created by Emen Zhao on 3/2/19.
//  Copyright © 2019 Emen Zhao. All rights reserved.
//

import UIKit

// MARK: - MemeEditViewController

class MemeEditViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: Outlets
    
    @IBOutlet private weak var meImage: UIImageView!
    @IBOutlet private weak var cameraButton: UIBarButtonItem!
    @IBOutlet private weak var topText: MemeTextField!
    @IBOutlet private weak var bottomText: MemeTextField!
    @IBOutlet weak var topToolBar: UIToolbar!
    @IBOutlet weak var bottomToolBar: UIToolbar!
    
    // MARK: Text Field Attributes
    
    private let defaultTopText = "TOP"
    private let defaultBottomText = "BOTTOM"
    
    // MARK: Top Tool Bar Buttons
    
    private let actionButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.action, target: nil, action: #selector(shareMeme(_:)))
    private let topSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
    private let cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: nil, action: #selector(cancel(_:)))

    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        meImage.contentMode = .scaleAspectFit
        topText.setDefaultText(text: defaultTopText)
        bottomText.setDefaultText(text: defaultBottomText)
        topToolBar.items = [actionButton, topSpace, cancelButton]
        actionButton.isEnabled = false
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeToKeyboardNotification()
    }

    // MARK: Actions
    
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        present(createUIImagePickerController(type: .photoLibrary), animated: true, completion: nil)
    }
    
    @IBAction func takeAPhoto(_ sender: Any) {
        present(createUIImagePickerController(type: .camera), animated: true, completion: nil)
    }
    
    @objc func shareMeme(_ sender: Any) {
        let memedImage = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        controller.completionWithItemsHandler = {(activity, success, items, error) in
            if success {
                self.save()
            }

            self.dismiss(animated: true, completion: nil)
        }
        present(controller, animated: true, completion: nil)
    }
    
    @objc func cancel(_ sender: Any) {
        topText.reset()
        bottomText.reset()
        meImage.image = nil
        actionButton.isEnabled = false
    }
    
    // MARK: Delegates
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            meImage.image = image
            actionButton.isEnabled = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Keyboard Events
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if bottomText.isFirstResponder {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    func subscribeToKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotification() {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: MemeMe methods
    
    func generateMemedImage() -> UIImage {
        
        hideToolBar(true)
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        hideToolBar(false)
        
        return memedImage
    }
    
    func save() {
        let _ = Meme(topText: topText.text!, bottomText: bottomText.text!, originalImage: meImage.image!, memedImage: generateMemedImage())
    }
    
    // MARK: private methods
    
    private func createUIImagePickerController(type: UIImagePickerController.SourceType) -> UIImagePickerController {
        let controller = UIImagePickerController()
        controller.sourceType = type
        controller.delegate = self
        return controller
    }

    private func hideToolBar(_ hide: Bool) {
        topToolBar.isHidden = hide
        bottomToolBar.isHidden = hide
    }
}
