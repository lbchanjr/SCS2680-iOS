//
//  ViewController.swift
//  Contact Entry
//
//  Created by Louise Chan on 2019-06-03.
//  Copyright © 2019 Louise Chan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // Array of outlet variables for all the textfields
    @IBOutlet var textFields: Array<UITextField>!
    // Array of outlet variables for all the labels associated with the textfields
    // Note: Indices of each array element are arranged in the same order as the indices of the array elements of "textFields"
    @IBOutlet var labelNames: Array<UILabel>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Add tap gesture that will allow closing of keyboard when user taps outside of the textfield.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.hideKeyboardView))
        self.view.addGestureRecognizer(tapGesture)

    }

    // Hides any visible keyboard display for the textfields
    @objc func hideKeyboardView() {
        // Iterate through each element of the textfields array and relinquish first responder status of each textfield
        for currentTextField in textFields {
            currentTextField.resignFirstResponder()
        }
    }
    
    // Called when user finishes input on any of the textfields
    @IBAction func textFieldDoneEditing(_ sender: UITextField) {
        // Check if we are in the last textfield (i.e. email text field)
        if sender == textFields[textFields.count-1] {
            // Hides the keyboard view when the enter key is tapped (no wrap-around to first textfield)
            sender.resignFirstResponder()
        }
        else {
            // Not the last textfield.
            // Pressing enter allow the user to move to the next textfield
            let nextTag = sender.tag + 1
            
            if let nextResponder = sender.superview?.viewWithTag(nextTag) {
                nextResponder.becomeFirstResponder()
            } else {
                sender.resignFirstResponder()
            }
        }
    }
    
    // Helper function that checks if a textfield is empty or not
    @objc func checkEmptyTextField(_ textField: UITextField) -> Bool {
        var retval: Bool = false
        
        if let text = textField.text {
            // check if user has inputted anything on the text field
            // Note: Whitespace characters such as 'spacebar' input will be considered as a valid input.
            //       Should whitespace characters be excluded, the following check should be used instead:
            //          if text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty {
            if text.isEmpty {
                // no input in textfield
                retval = true
            }
            else {
                // textfield has an input text
                retval = false
            }
        }
        
        // return text input status
        return retval
    }
    
    // Helper function that will clear all text fields
    @objc func clearTextFields() {
        // Clear data on all of the textfields
        for currentTextField in textFields {
            currentTextField.text = ""
        }
    }

    // Action performed when user taps the "Save" button
    @IBAction func saveButtonTap(_ sender: UIButton) {

        // Holds info on what textfield names are empty (empty if all textfields are filled)
        var emptyFields: String = ""
        // Counter for the number of empty fields
        var numEmptyFields: Int = 0
        // Hide any visible keyboard display if button is tapped
        hideKeyboardView()
        
        // Iterate through each of the textfield and check which ones are empty.
        // If any of the textfields are empty, the name associated to the textfield will be
        // appended into the "emptyFields" string variable.
        for index in 0 ..< textFields.count {
            // Check if current textfield is empty
            if checkEmptyTextField(textFields[index]) {
                
                // Get the label text associated with the empty textfield
                let labelText = labelNames[index].text!
                // Remove the ':' character from the label name.
                let labelName = labelText[..<labelText.index(labelText.endIndex, offsetBy: -1)]
                
                // Check if there's a need to add a comma before appending the label name.
                // (applicable only if more than one textfield is empty)
                if numEmptyFields > 0 {
                    emptyFields += ", "
                }
                
                // Append the label name into the "emptyFields" string variable
                emptyFields += "\"" + String(labelName) + "\""
                // Increment counter for empty textfields.
                numEmptyFields += 1
            }
        }
        
        // Variables for holding the title and message strings of the save alert popup.
        var alertMsg: String
        var alertTitle: String
        
        // Check what action to perform based on contents of textfields.
        if emptyFields.isEmpty {
            // New contact has been filled properly.
            // Update alert message and title strings to indicate that new contact has been saved.
            // Title: "New Contact Saved"
            // Message: <first name> is now a contanct.
            alertMsg = textFields[0].text! + " is now a contact."       // First name will always be at index 0.
            alertTitle = "New Contact Saved"
        }
        else {
            // New contact has missing textfields.
            // Update alert message and title strings to indicate the error.
            // Title: "Error!"
            // Message: "<empty text fields> field(s) is/are empty."
            alertTitle = "Error"
            // Create an action sheet for the Cancel button press
            if numEmptyFields > 1 {
                alertMsg = emptyFields + " fields are empty."
            }
            else {
                alertMsg = emptyFields + " field is empty."
            }
            
        }

        // Create an alert for the save button function.
        let saveAlert = UIAlertController(title: alertTitle, message: alertMsg, preferredStyle: .alert)
        // Create "OK" action button
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            if numEmptyFields == 0 {
                self.clearTextFields()
            }})

        // Add action to the alert
        saveAlert.addAction(okAction)
        
        // Show alert
        self.present(saveAlert, animated: true, completion: nil)

    }
    
    // Process Cancel button taps
    @IBAction func cancelButtonTap(_ sender: UIButton) {
        // Indicates whether any of the fields have been filled up.
        var fieldNotEmpty: Bool = false
        
        // Check if any of the fields have been filled.
        for currentTextField in textFields {
            if !checkEmptyTextField(currentTextField) {
                // Indicate that current filed is not empty.
                fieldNotEmpty = true
                break;
            }
        }
        
        // Make sure that cancel action sheet is shown only if user has inputted something in the text field
        if fieldNotEmpty {
        
            // Create an action sheet for the Cancel button press
            let cancelActionSheet = UIAlertController(title: nil, message: "Are you sure?", preferredStyle: .actionSheet)
            
            // Create "Yes, I'm sure!" selection option for the action sheet.
            let yesAction = UIAlertAction(title: "Yes, I'm sure!", style: .default, handler: { (action) -> Void in
                self.clearTextFields()
                // Hide any visible keyboard display only if cancellation is confirmed.
                self.hideKeyboardView()
            })
            // Create "No Way!" selection option for the action sheet.
            let noAction = UIAlertAction(title: "No Way!", style: .cancel, handler: nil)
            
            // Add actions to the action sheet
            cancelActionSheet.addAction(yesAction)
            cancelActionSheet.addAction(noAction)
            
            // Show the action sheet
            self.present(cancelActionSheet, animated: true, completion: nil)

        }
    }
}

