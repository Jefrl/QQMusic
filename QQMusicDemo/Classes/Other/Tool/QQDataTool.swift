//
//  QQDataTool.swift
//  QQMusicDemo
//
//  Created by Jefrl on 17/5/19.
//  Copyright © 2017年 com.Jefrl.www. All rights reserved.
//

import UIKit

class QQDataTool: NSObject {
    /// 获取歌曲信息简介的 模型数组
    class func getMusicListData() -> [QQMusicModel] {
        
        guard let path = Bundle.main.path(forResource: "Musics.plist", ofType: nil) else {
            return [QQMusicModel]()
        }
        
        // 2. 转换模型
        guard let dicArray = NSArray(contentsOfFile: path) else {
            return [QQMusicModel]()
        }
        
        var musicMs = [QQMusicModel]()
        for dict in dicArray {
            let musicM = QQMusicModel(dict: dict as! [String : Any])
            musicMs.append(musicM)
        }
        
        return musicMs
    }
    
    /// 获取歌曲中歌词信息的 模型数组
    class func getLrcMData(_ lrcName: String) -> [QQLrcModel] {
        guard let path = Bundle.main.path(forResource: lrcName, ofType: nil) else {
            return [QQLrcModel]()
        }
        
        var lrcContent: String?
        do {
            lrcContent = try String(contentsOfFile: path)
        } catch  {
            print(error)
            return [QQLrcModel]()
        }
        
        guard let verLrcContent = lrcContent else {
            return [QQLrcModel]()
        }
        
        // 解析歌词
        var lrcMs = [QQLrcModel]()
        
        let lrcStrArray = verLrcContent.components(separatedBy: "\n")
        for lrcStr in lrcStrArray {
            // 1. 过滤垃圾数据
            if lrcStr.contains("[ti:") || lrcStr.contains("[ar:") || lrcStr.contains("[al:")
            {
                continue
            }
            
            // 2. 拿到正确的数据, 开始解析
            // 删除没必要的数据
            let resultStr = lrcStr.replacingOccurrences(of: "[", with: "")
            
            // 内容字符串中, 区分开 时间与歌词, 换行
            let timeAndLrc = resultStr.components(separatedBy: "]")
            
            if timeAndLrc.count == 2 {
                let timeFormat = timeAndLrc[0]
                let lrc = timeAndLrc[1]
                //                print(time, lrc)
                let lrcM = QQLrcModel()
                lrcM.startTime = QQTimeTool.getTime(timeFormat)
                lrcM.lrcContent = lrc
                lrcMs.append(lrcM)
            }
        }
        
        for i in 0..<lrcMs.count
        {
            if i == lrcMs.count - 1 {
                break
            }
            
            lrcMs[i].endTime = lrcMs[i + 1].startTime
            
        }
        
        return lrcMs
    }
    
    /// 获取当前播放歌词的 (为第几行和 当前歌曲中歌词信息的 模型) 的元祖
    class func getRowLrcM(_ lrcMs: [QQLrcModel], currentTime: TimeInterval) -> (row: Int, lrcM: QQLrcModel?) {
        
        for i in 0..<lrcMs.count {
            if currentTime > lrcMs[i].startTime && currentTime < lrcMs[i].endTime {
                return (i, lrcMs[i])
            }
        }
        
        return (0, nil)
        
    }
    

    
    
}
