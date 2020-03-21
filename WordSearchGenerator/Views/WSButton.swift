//
//  WordSearchButton.swift
//  WordSearchGenerator
//
//  Created by Leandro Rocha on 6/23/19.
//  Copyright © 2019 Leandro Rocha. All rights reserved.
//

import UIKit

class WSButton: UIButton {

    override var isEnabled: Bool {
        didSet {
            backgroundColor = isEnabled ? .systemBlue : UIColor.systemBlue.withAlphaComponent(0.7)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        configure()
    }
    
    private func configure() {
        setTitle("Generate Word Search", for: .normal)
        backgroundColor = .systemBlue
        setTitleColor(.lightGray, for: .disabled)
        contentEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        
        layer.cornerRadius = 8
        layer.shadowOpacity = 0.25
        layer.shadowRadius = 5
        layer.shadowOffset = CGSize(width: 0, height: 5)
    }

}
