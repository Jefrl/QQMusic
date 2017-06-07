//
//  Layer+Animation.swift
//  QQMusicDemo
//
//  Created by Jefrl on 17/5/22.
//  Copyright © 2017年 com.Jefrl.www. All rights reserved.
//

import UIKit

/// 给 layer 扩展分类
extension CALayer {
    
    func resumeAnimation() -> () {
        let pauseTime: CFTimeInterval = timeOffset
        speed = 1.0
        timeOffset = 0.0
        beginTime = 0.0
        let timeSincePause: CFTimeInterval = convertTime(CACurrentMediaTime(), from: nil) - pauseTime
        beginTime = timeSincePause
        
    }
    
    /// 暂停动画
    func pauseAnimation() -> () {
        let pauseTime: CFTimeInterval = convertTime(CACurrentMediaTime(), from: nil)
        speed = 0.0
        timeOffset = pauseTime
    }
}
