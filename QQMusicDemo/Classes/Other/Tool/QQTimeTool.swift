//
//  QQTimeTool.swift
//  QQMusicDemo
//
//  Created by Jefrl on 17/5/22.
//  Copyright © 2017年 com.Jefrl.www. All rights reserved.
//

import UIKit

class QQTimeTool: NSObject {
    /// 获取格式化时间
    class func getFormatTime(_ time: TimeInterval) -> String {
        let min = Int(time + 0.5) / 60
        let sec = Int(time + 0.5) % 60
        
        return String(format: "%02d:%02d", min, sec)
    }
    
    /// 获取 TimeInterval 类型的时间
    class func getTime(_ formatTime: String) -> TimeInterval {
        let minSec = formatTime.components(separatedBy: ":")
        if minSec.count == 2 {
            let min = Double(minSec[0])
            let sec = Double(minSec[1])
            return min! * 60 + sec!
        }
        
        return 0
    }
}

