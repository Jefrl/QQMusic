//
//  QQMusicTool.swift
//  QQMusicDemo
//
//  Created by Jefrl on 17/5/19.
//  Copyright © 2017年 com.Jefrl.www. All rights reserved.
//

import UIKit
import AVFoundation // 音视频框架

class QQMusicTool: NSObject {
    override init() {
        // info.plist 里加入后台播放设置
        let session = AVAudioSession.sharedInstance()
        do {
            // 设为静音跟锁屏时依然播放声音的类型
            try session.setCategory(AVAudioSessionCategoryPlayback)
            try session.setActive(true)
        } catch  {
            return
        }
        
    }
    
    var player : AVAudioPlayer?
    
    func playMusic(_ musicName: String) {
        // 获取需要的播放文件的路径
        guard let url = Bundle.main.url(forResource: musicName, withExtension: nil) else {
            return
        }
        
        // 判断是否是同一首
        if player?.url == url {
            player?.play()
            return
        }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.delegate = self
        } catch  {
            print(error)
            return
        }
        
        // 3. 准备播放
        player?.prepareToPlay()
        // 4. 开始播放
        player?.play()
        
    }
    
    func pauseCurrentMusic() -> () {
        player?.pause()
    }
    
    func playCurrentMusic() -> Void {
        player?.play()
    }
    
    func stopCurrentMusic() -> Void {
        player?.stop()
    }
    
    func setTime(_ currentTime: TimeInterval) -> Void {
        player?.currentTime = currentTime
    }
    
    
}

let kPlayerFinishNotification = "playFinish"


// MARK: - 实现音频代理方法
extension QQMusicTool: AVAudioPlayerDelegate {

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("播放完成后")
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kPlayerFinishNotification), object: nil)
    }

}








