//
//  QQListTVC.swift
//  QQMusicDemo
//
//  Created by Jefrl on 17/5/17.
//  Copyright © 2017年 com.Jefrl.www. All rights reserved.
//

import UIKit

class QQListTVC: UITableViewController {
    
    // 懒加载 歌曲数据数组
    fileprivate lazy var musicMs: [QQMusicModel] = {
        
        // 1. 加载数据
        var models = QQDataTool.getMusicListData() {
            didSet {
                self.tableView.reloadData()
            }
        }

        // 给工具类, 赋值播放的音乐列表数据
        QQMusicOperationTool.shareInstance.musicMList = models
        
        return models
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpInit()
    }
    
}

extension QQListTVC {
    /// 状态栏设置白色
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    /// 界面初始化
    func setUpInit() {
        navigationController?.isNavigationBarHidden = true
        
        setTabView()
    }
    
    /// tableView 界面的初始化
    func setTabView() {
        
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        
        let image = UIImage(named: "QQListBack.jpg")
        let imageView = UIImageView(image: image)
        tableView.backgroundView = imageView
        
    }

}

extension QQListTVC {

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return musicMs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = QQMusicListCell.cellWithTableView(tableView)
        cell.musicM = musicMs[indexPath.row]
        // 每当 cell 将要显示的时候, 做一次动画
        cell.animation(AnimationType.scale)
        
        let flag = musicMs.count / 2
        if flag > indexPath.row {
            cell.animation(AnimationType.rotate)
        }
        
        return cell;
    }
    
    // delegate source
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let model = musicMs[indexPath.row]
        QQMusicOperationTool.shareInstance.playMusic(model)
        
        self.performSegue(withIdentifier: "listToDetail", sender: nil)
    }

}
