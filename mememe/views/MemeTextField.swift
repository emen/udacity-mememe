//
//  MemeTextField.swift
//  mememe
//
//  Created by Emen Zhao on 3/16/19.
//  Copyright © 2019 Emen Zhao. All rights reserved.
//

import UIKit

// MARK: - MemeTextField

// MemeTextField encapsulates Meme text field's format and behaviors
class MemeTextField: UITextField {

    private let textAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: 0
    ]
    
    private let memeTextFieldDelegate = MemeTextFieldDelegate()
    
    private var defaultText: String!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        defaultTextAttributes = textAttributes
        autocapitalizationType = .allCharacters
        textAlignment = .center
        delegate = memeTextFieldDelegate
    }
    
    func setDefaultText(text: String) {
        self.defaultText = text
        self.text = defaultText
    }
    
    func reset() {
        resignFirstResponder()
        self.text = self.defaultText
        memeTextFieldDelegate.resetHasUserInput()
    }

}
