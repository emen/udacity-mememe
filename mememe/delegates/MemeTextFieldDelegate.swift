//
//  MemeMeTextFieldDelegate.swift
//  mememe
//
//  Created by Emen Zhao on 3/3/19.
//  Copyright © 2019 Emen Zhao. All rights reserved.
//

import Foundation
import UIKit

// MARK: - MemeMeTextFieldDelegate

/// MemeMeTextFieldDelegate controls Mememe Text Field's behavior
class MemeTextFieldDelegate: NSObject, UITextFieldDelegate {
    
    private var hasUserInput:Bool = false
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if !hasUserInput {
            textField.text = ""
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        hasUserInput = true
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

