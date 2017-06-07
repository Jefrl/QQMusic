//
//  QQLrcLabel.swift
//  QQMusicDemo
//
//  Created by Jefrl on 17/5/19.
//  Copyright © 2017年 com.Jefrl.www. All rights reserved.
//

import UIKit

class QQLrcLabel: UILabel {

    var progress: CGFloat = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        UIColor.green.set()
      UIRectFillUsingBlendMode(CGRect(x: 0, y: 0, width: rect.width * progress, height: rect.height), CGBlendMode.sourceIn)
    }

}
