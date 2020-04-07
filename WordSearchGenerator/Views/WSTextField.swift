//
//  WSTextField.swift
//  WordSearchGenerator
//
//  Created by Leandro Rocha on 3/6/20.
//  Copyright © 2020 Leandro Rocha. All rights reserved.
//

import UIKit

class WSTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        configure()
    }
    
    private func configure() {
        borderStyle = .roundedRect
        clearButtonMode = .whileEditing
        font = UIFont.preferredFont(forTextStyle: .body)
        adjustsFontForContentSizeCategory = true
        enablesReturnKeyAutomatically = true
    }
}
