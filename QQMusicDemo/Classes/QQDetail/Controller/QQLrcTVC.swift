//
//  QQLrcTVC.swift
//  QQMusicDemo
//
//  Created by Jefrl on 17/5/19.
//  Copyright © 2017年 com.Jefrl.www. All rights reserved.
//

import UIKit

class QQLrcTVC: UITableViewController {
    // 歌词content 模型数组
    var lrcMs = [QQLrcModel]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    // 滚动到某一行
    var scrollRow: Int = -1 {
        didSet {
            if scrollRow == oldValue {
                return
            }
            
            print(scrollRow)
            tableView.reloadRows(at: tableView.indexPathsForVisibleRows!, with: UITableViewRowAnimation.fade)
            
            let indexPath = IndexPath(row: scrollRow, section: 0)
            tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.middle, animated: true)
        }
    }
    
    var progress: CGFloat = 0 {
        didSet {
            let indexPath = IndexPath(row: scrollRow, section: 0)
            let cell = tableView.cellForRow(at: indexPath) as? QQLrcCell
            cell?.progress = progress
            
        }
        
    }
    
    // MARK:- 初始设置
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
    }
    
    override func viewWillLayoutSubviews() {
        tableView.contentInset = UIEdgeInsetsMake(tableView.height * 0.5, 0, tableView.height * 0.5, 0)
    }
    
}

// MARK:- dataSource
extension QQLrcTVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lrcMs.count 
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = QQLrcCell.cellWithTableView(tableView) as! QQLrcCell
        cell.lrcM = lrcMs[indexPath.row]
        
        if scrollRow == indexPath.row {
            cell.progress = progress
        } else {
            cell.progress = 0
        }
        
        return cell
    }
}




