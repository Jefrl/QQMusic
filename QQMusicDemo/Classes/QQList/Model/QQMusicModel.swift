//
//  QQMusicModel.swift
//  QQMusicDemo
//
//  Created by Jefrl on 17/5/18.
//  Copyright © 2017年 com.Jefrl.www. All rights reserved.
//

import UIKit

class QQMusicModel: NSObject {
    /// 歌名
    var name: String?
    
    /// 歌曲文件名
    var filename: String?
    
    /// 歌词文件名
    var lrcname: String?
    
    /// 歌手名
    var singer: String?
    
    /// 歌手头像
    var singerIcon: String?
    
    /// 歌手图片
    var icon: String?

    override init() {
        super.init()
    }
    
    init(dict : [String : Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
}
