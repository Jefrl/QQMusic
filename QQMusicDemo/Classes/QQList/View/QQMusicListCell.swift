//
//  QQMusicListCell.swift
//  QQMusicDemo
//
//  Created by Jefrl on 17/5/17.
//  Copyright © 2017年 com.Jefrl.www. All rights reserved.
//

import UIKit

enum AnimationType: Int {
    case rotate
    case scale
}

class QQMusicListCell: UITableViewCell {

    @IBOutlet weak var singerNameLabel: UILabel!
    @IBOutlet weak var iconIMV: UIImageView!
    @IBOutlet weak var songNameLabel: UILabel!
    
    var musicM: QQMusicModel? {
        didSet {
            if musicM?.icon != nil {
                iconIMV.image = UIImage.init(named: (musicM?.icon)!)
            }
            
            singerNameLabel.text = musicM?.singer
            songNameLabel.text = musicM?.name
        }
    }
    
    class func cellWithTableView(_ tableView: UITableView) -> QQMusicListCell {
        
        let ID = "musicList"
        var cell = tableView.dequeueReusableCell(withIdentifier: ID) as? QQMusicListCell
        if cell == nil {
            
            cell = Bundle.main.loadNibNamed("QQMusicListCell", owner: nil
                , options: nil)?.first as? QQMusicListCell
        }
        return cell!
        
    }
        
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.clear
        selectionStyle = .none
        
        // 正式项目中要离屏渲染
        iconIMV.layer.cornerRadius = iconIMV.width * 0.5
        iconIMV.layer.masksToBounds = true
    }

    func animation(_ type: AnimationType) {
        
        switch type {
        case .rotate:
            self.layer.removeAnimation(forKey: "hxl_rotation")
            let animation = CAKeyframeAnimation(keyPath: "transform.rotation.x")
            animation.values = [-2/3 * M_PI, 0, 2/3 * M_PI, 0]
            animation.duration = 0.7
            animation.repeatCount = 2
            self.layer.add(animation, forKey: "hxl_rotation")
            
        case .scale:
            self.layer.removeAnimation(forKey: "hxl_scale")
            let animation = CABasicAnimation(keyPath: "transform.scale")
            animation.fromValue = 0.5
            animation.toValue = 1
            animation.duration = 1.4
            animation.repeatCount = 1
            self.layer.add(animation, forKey: "hxl_scale")
        }
        
    }
}
