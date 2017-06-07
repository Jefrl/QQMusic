//
//  QQMusicOperationTool.swift
//  QQMusicDemo
//
//  Created by Jefrl on 17/5/19.
//  Copyright © 2017年 com.Jefrl.www. All rights reserved.
//

import UIKit
import MediaPlayer

class QQMusicOperationTool: NSObject {
    // 记录上次的行号
    var lastRow: Int = 0
    // 图片
    var artwork: MPMediaItemArtwork?

    // 创建 QQ 音乐的操作工具单例
    static let shareInstance = QQMusicOperationTool()
    
    // 创建 QQ 音乐播放工具对象
    fileprivate let tool: QQMusicTool = QQMusicTool()
    // 定义属性接收传值
    var musicMList: [QQMusicModel]?
    // 记录当前歌曲的索引
    var currentIndex: Int = 0 {
        didSet {
            if currentIndex < 0 {
                currentIndex = (musicMList?.count)! - 1
            }
            if currentIndex > (musicMList?.count)! - 1 {
                currentIndex = 0
            }
        }
    }
    
    // 创建歌曲详细信息模型
    fileprivate var musicMessageM = QQMusicMessageModel()
    
    func getMusicMessageM() -> QQMusicMessageModel {
        if musicMList == nil {
            return musicMessageM
        }
        
        musicMessageM.musicM = musicMList?[currentIndex]
        
        if tool.player != nil {
            musicMessageM.costTime = (tool.player?.currentTime)!
            musicMessageM.totalTime = (tool.player?.duration)!
            musicMessageM.isPlaying = (tool.player?.isPlaying)!
        }
                
        return musicMessageM
    }    
    
    /// 操作单例提供的方法
    /// - Parameter musicM: 播放音乐
    func playMusic(_ musicM: QQMusicModel) {
        // 让 MusicTool 去播放音乐
        tool.playMusic(musicM.filename!)
        
        // 看列表内是否有歌曲
        guard let musicMList = musicMList else {
            return
        }
        
        // 及时更新索引
        currentIndex = musicMList.index(of: musicM)!
        // 有东西可以优化
    }
    
    func pauseCurrentMusic() {
        tool.pauseCurrentMusic()
    }
    
    func playCurrentMusic() {
        tool.playCurrentMusic()
    }
    
    func preMusic() {
        currentIndex -= 1
        playMusic(musicMList![currentIndex])
    }
    
    func nextMusic() {
        currentIndex += 1
        let musicM = musicMList?[currentIndex]
        playMusic(musicM!)
    }
    
    func setTime(_ currentTime: TimeInterval) {
        tool.setTime(currentTime)
    }
    
}

/// 锁屏下的信息
extension QQMusicOperationTool {
    func setUpLockMessage() {
        // 0. 取出需要展示的信息模型
        let musicMessageM = getMusicMessageM()
        
        // 1. 获取锁屏中心
        let infoCenter = MPNowPlayingInfoCenter.default()
        
        // 1.1 创建显示信息的字典
        var name = ""
        var singer = ""
        
        if musicMessageM.musicM?.name != nil {
            name = (musicMessageM.musicM?.name)!
        }
        
        if musicMessageM.musicM?.singer != nil {
            singer = (musicMessageM.musicM?.singer)!
        }
        
        let imageNname = musicMessageM.musicM?.icon
        
        if imageNname != nil {
            let image = UIImage(named: imageNname!)
            if image != nil
            {
                // 1. 获取歌词, 添加歌词, 到图片上, 组成一张新的图片, 来展示
                // 1. 获取当前歌曲对应的所有歌词模型组成的shuzu
                let musicM = musicMessageM.musicM
                if musicM?.lrcname != nil
                {
                    let lrcMs = QQDataTool.getLrcMData((musicM?.lrcname)!)
                    
                    // 2. 获取当前正在播放的歌词模型
                    let rowLrcM = QQDataTool.getRowLrcM(lrcMs, currentTime: musicMessageM.costTime)
                    
                    // 3. 获取当前歌词的信息
                    if lastRow != rowLrcM.row {
                        lastRow = rowLrcM.row
                        // 4. 把文字, 绘制到图片上, 生成新的图片
                        let resultImage = QQImageTool.getImage(image!, text: rowLrcM.lrcM?.lrcContent)
                        
                        artwork = MPMediaItemArtwork(image: resultImage)
                        
                        print("绘制了图片")
                        
                    }
                    
                }
                
            }
        }
        
        let infoDic: NSMutableDictionary = NSMutableDictionary()
        infoDic.setValue(name, forKey: MPMediaItemPropertyAlbumTitle)
        infoDic.setValue(singer, forKey: MPMediaItemPropertyArtist)
        infoDic.setValue(musicMessageM.totalTime, forKey: MPMediaItemPropertyPlaybackDuration)
        infoDic.setValue(musicMessageM.costTime, forKey: MPNowPlayingInfoPropertyElapsedPlaybackTime)
        
        if artwork != nil {
            infoDic.setValue(artwork!, forKey: MPMediaItemPropertyArtwork)
        }
        
        //            :
        
        let infoDic2 = infoDic.copy()
        
        // 2. 设置信息
        infoCenter.nowPlayingInfo = infoDic2 as? [String: AnyObject]
        
        // 3. 接收远程事件
        UIApplication.shared.beginReceivingRemoteControlEvents()
        
    }

}
