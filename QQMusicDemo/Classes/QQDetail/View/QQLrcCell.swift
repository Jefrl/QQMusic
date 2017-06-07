//
//  QQLrcCell.swift
//  QQMusicDemo
//
//  Created by Jefrl on 17/5/25.
//  Copyright © 2017年 com.Jefrl.www. All rights reserved.
//

import UIKit

class QQLrcCell: UITableViewCell {

    @IBOutlet weak var lrcLabel: QQLrcLabel!
    var progress: CGFloat = 0 {
        didSet {
            lrcLabel.progress = progress
        }
    }
    
    var lrcM: QQLrcModel? {
        didSet {
            lrcLabel.text = lrcM?.lrcContent
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.clear
    }

    class func cellWithTableView(_ tableView: UITableView) -> UITableViewCell {
        let ID = "LRC"
        var cell = tableView.dequeueReusableCell(withIdentifier: ID) as? QQLrcCell
        if cell == nil {
            
            cell = Bundle.main.loadNibNamed("QQLrcCell", owner: nil
                , options: nil)?.first as? QQLrcCell
        }
        
        return cell!
    }
    
}
