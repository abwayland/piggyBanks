//
//  PBVC.swift
//  PiggyBanks
//
//  Created by Adam Wayland on 3/24/15.
//  Copyright (c) 2015 Adam Wayland. All rights reserved.
//

import UIKit

class PBVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var thumbnail: UIImageView!
    
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var cushionControl: UISegmentedControl!
    
    var model: PiggyBanksModel!
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
                let scrollToFrame = CGRectMake(cushionControl.frame.origin.x, cushionControl.frame.origin.y, cushionControl.frame.size.width, cushionControl.frame.size.height + 20)
                if aRect.contains(activeField.frame.origin) {
                    self.scrollView.scrollRectToVisible(scrollToFrame, animated: true)
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
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        activeField = nil
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerForKeyBoardNotifications()
        scrollView.contentSize = self.view.frame.size
        thumbnail.image = UIImage(named: "piggybank_0")
        nameField.delegate = self
        amountField.delegate = self
        dateField.delegate = self
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
