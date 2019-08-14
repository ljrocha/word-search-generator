//
//  WordSearchButton.swift
//  WordSearchGenerator
//
//  Created by Leandro Rocha on 6/23/19.
//  Copyright © 2019 Leandro Rocha. All rights reserved.
//

import UIKit

class WordSearchButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        buttonSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        buttonSetup()
    }
    
    func buttonSetup() {
        setTitle("WS", for: .normal)
        contentEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        backgroundColor = .mainColor
        layer.cornerRadius = 8
        layer.shadowOpacity = 0.25
        layer.shadowRadius = 5
        layer.shadowOffset = CGSize(width: 0, height: 10)
    }

}
