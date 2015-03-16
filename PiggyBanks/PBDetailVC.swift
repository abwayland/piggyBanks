//
//  PBDetailVC.swift
//  PiggyBanks
//
//  Created by Adam Wayland on 3/12/15.
//  Copyright (c) 2015 Adam Wayland. All rights reserved.
//

import UIKit

class PBDetailVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var thumbnail: UIImageView!
    
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var outlets = [String]()
    var image: UIImage!
    var activeField: UITextField!
    
    func registerForKeyBoardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillBeHidden:", name: UIKeyboardDidHideNotification, object: nil)
    }
    
    func keyboardWasShown(notification: NSNotification) {
        if let info = notification.userInfo {
            if let kbSize = info[UIKeyboardFrameBeginUserInfoKey]?.CGRectValue().size {
                let contentInsets = UIEdgeInsetsMake(0, 0, kbSize.height, 0)
                scrollView.contentInset = contentInsets
                var aRect = self.view.frame
                aRect.size.height -= kbSize.height
                if aRect.contains(activeField.frame.origin) {
                    self.scrollView.scrollRectToVisible(activeField.frame, animated: true)
                }
            }
        }
    }
    
    func keyboardWillBeHidden(notification: NSNotification) {
        scrollView.contentInset = UIEdgeInsetsZero
        scrollView.scrollIndicatorInsets = UIEdgeInsetsZero
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        activeField = textField
        println("active")
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        activeField = nil
        println("Deactive")
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerForKeyBoardNotifications()
        scrollView.contentSize = self.view.frame.size
        nameField.text = outlets[0]
        amountField.text = outlets[1]
        dateField.text = outlets[2]
        thumbnail.image = image
        nameField.delegate = self
        amountField.delegate = self
        dateField.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setOutlets(name nameLocal: String, amount amountLocal: String, date dateLocal: String, image imageLocal: UIImage) {
        outlets = [nameLocal, amountLocal, dateLocal]
        image = imageLocal
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        
//    }


}
