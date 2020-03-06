//
//  WordSearchButton.swift
//  WordSearchGenerator
//
//  Created by Leandro Rocha on 6/23/19.
//  Copyright © 2019 Leandro Rocha. All rights reserved.
//

import UIKit

class WSButton: UIButton {

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
        contentEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        backgroundColor = .mainColor
        
        layer.cornerRadius = 8
        layer.shadowOpacity = 0.25
        layer.shadowRadius = 5
        layer.shadowOffset = CGSize(width: 0, height: 10)
    }

}
