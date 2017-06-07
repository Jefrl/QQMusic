//
//  QQMusicMessageModel.swift
//  QQMusicDemo
//
//  Created by Jefrl on 17/5/22.
//  Copyright © 2017年 com.Jefrl.www. All rights reserved.
//

import UIKit

class QQMusicMessageModel: NSObject {

    var musicM: QQMusicModel?
    var costTime: TimeInterval = 0
    var totalTime: TimeInterval = 0
    var isPlaying: Bool = false
    
    var costTimeFormat: String {
        get {
            return QQTimeTool.getFormatTime(costTime)
        }
    }
    
    var totalTimeFormat: String {
        get {
            return QQTimeTool.getFormatTime(totalTime)
        }
    }
}
