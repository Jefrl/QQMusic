//
//  QQImageTool.swift
//  QQMusicDemo
//
//  Created by Jefrl on 17/5/26.
//  Copyright © 2017年 com.Jefrl.www. All rights reserved.
//

import UIKit

class QQImageTool: NSObject {

    class func getImage(_ sourceImage: UIImage, text: String?) -> UIImage {
        
        if text == nil || text! == "" {
            return sourceImage
        }
        
        // 开启图形上下文
        UIGraphicsBeginImageContext(sourceImage.size)
        
        // 将图片绘制上去
        sourceImage.draw(in: CGRect(x: 0, y: 0, width: sourceImage.size.width, height: sourceImage.size.height))
        
        // 将文字绘制上去
        // 获取段落风格对象, 设置好居中
        let style: NSMutableParagraphStyle = NSMutableParagraphStyle()
        style.alignment = .center
        
        let dic: [String : AnyObject] = [
            
            NSForegroundColorAttributeName : UIColor.white,
                       NSFontAttributeName : UIFont.systemFont(ofSize: 18),
             NSParagraphStyleAttributeName : style
        ]
        
        // Text 文字 draw 画好
        (text! as NSString).draw(in: CGRect(x: 0, y: 0, width: sourceImage.size.width, height: 28), withAttributes: dic)
        
        // 合成获取图片
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        // 关闭上下文
        UIGraphicsEndImageContext()
        
        return image!
    }
    
}
