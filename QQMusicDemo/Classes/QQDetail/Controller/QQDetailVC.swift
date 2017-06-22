//
//  QQDetailVC.swift
//  QQMusicDemo
//
//  Created by Jefrl on 17/5/19.
//  Copyright © 2017年 com.Jefrl.www. All rights reserved.
//

import UIKit


class QQDetailVC: UIViewController, UIScrollViewDelegate {
   
    /** 歌词背景视图(动画使用) */
    @IBOutlet weak var lrcBackView: UIScrollView!
    
    // 根据当切换歌曲时, 控件的更新频率, 对属性进行分类, 然后采用不同的处理方案解决
    
    // 背景图片 1
    @IBOutlet weak var backImageView: UIImageView!
    // 歌曲名称 1
    @IBOutlet weak var songNameLabel: UILabel!
    // 歌手名称 1
    @IBOutlet weak var singerNameLabel: UILabel!
    /** 前景图片 1 */
    @IBOutlet weak var foreImageView: UIImageView!
    
    
    // 已经播放时长 N
    @IBOutlet weak var costTimeLabel: UILabel!
    // 总时长 1
    @IBOutlet weak var totalTimeLabel: UILabel!
    // 按钮状态  n
    @IBOutlet weak var playOrPauseBtn: UIButton!
    /** 播放进度 n */
    @IBOutlet weak var progressSlider: UISlider!
    
    /** 歌词标签 n */
    @IBOutlet weak var lrcLabel: QQLrcLabel!
    
    var updateTimesTimer: Timer?
    
    var displayLink: CADisplayLink?
    
    lazy var lrcTVC: QQLrcTVC = {
        
        return QQLrcTVC()
    }()
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}

// MARK:- 初始设置
extension QQDetailVC {
    // 这个方法里面, 存放的都是单次操作的, 比如说添加控件, 设置控件状态
    // 注意: 不要把设置frame的方法放在这里, 因为这里获取的是xib原始的尺寸
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpOnce()
        setSlider()
        
        // 设置好通知
        setupNotification()
        // 设置歌词背景视图(动画使用)
        setLrcBackView()
        // 添加了一个歌词视图
        addLrcView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        // 设置圆形前景图片
        setForeImageView()
        // 设置歌词容器 View 的大小
        lrcBackView.contentSize = CGSize(width: lrcBackView.width * 2, height: lrcBackView.height)
        // 设置歌词视图的 frame
        setLrcFrame()
    }
    
    // 添加定时器
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // 增加定时器, 驱动滑块 (silder.value)
        addTimer()
        
        // 增加 CADisplayLink 定时器
        addDisPlayLink()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        removeTimer()
    }
    
    
}

// MARK:- 业务逻辑
extension QQDetailVC {
    
    // 返回菜单
    @IBAction func back(_ sender: AnyObject) {
        
        _ = navigationController?.popViewController(animated: true)
    }

    @IBAction func close() {
        _ = navigationController?.popViewController(animated: true)
    }

    // 播放或者暂停
    @IBAction func playOrPause(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        let tool = QQMusicOperationTool.shareInstance
        if sender.isSelected {
            tool.playCurrentMusic()
            resumeRotationAnimation()
        } else {
            tool.pauseCurrentMusic()
            pauseRotationAnimation()
        }
        
    }
    
    // 上一首
    @IBAction func preMusic() {
        playOrPauseBtn.isSelected = true
        let tool = QQMusicOperationTool.shareInstance
        tool.preMusic()
        // 同步UI界面歌曲的信息
        setUpOnce()
    }

    // 下一首
    @IBAction func nextMusic() {
        playOrPauseBtn.isSelected = true
        let tool = QQMusicOperationTool.shareInstance
        tool.nextMusic()
        // 同步UI界面歌曲的信息
        setUpOnce()
    }
    
    @IBAction func down(_ sender: UISlider) {
        removeTimer()
    }
    
    @IBAction func change(_ sender: UISlider) {
        // silder.value: 0 - 1.0
       let musicMessageM = QQMusicOperationTool.shareInstance.getMusicMessageM()
       let currentTime = musicMessageM.totalTime * Double(sender.value)
       costTimeLabel.text = QQTimeTool.getFormatTime(currentTime)
    }
    
    @IBAction func up(_ sender: UISlider) {
        let musicMessageM = QQMusicOperationTool.shareInstance.getMusicMessageM()
        let currentTime = musicMessageM.totalTime * Double(sender.value)
        
        QQMusicOperationTool.shareInstance.setTime(currentTime)
        
        addTimer()
    }
    
    @IBAction func upOutside(_ sender: Any) {
        
        let musicMessageM = QQMusicOperationTool.shareInstance.getMusicMessageM()
        let currentTime = musicMessageM.totalTime * Double((sender as! UISlider).value)
        
        QQMusicOperationTool.shareInstance.setTime(currentTime)
        
        addTimer()
    }
    
}

// MARK:- 数据处理
extension QQDetailVC {
    // detailVC 界面基础信息搭建
    func setUpOnce() {
        // 获取歌曲详细信息对象, 进行赋值
        let musicMessageM = QQMusicOperationTool.shareInstance.getMusicMessageM()
        
        if let icon = musicMessageM.musicM?.icon {
            backImageView.image = UIImage(named: icon)
            foreImageView.image = UIImage(named: icon)
        }
        songNameLabel.text = musicMessageM.musicM?.name
        singerNameLabel.text = musicMessageM.musicM?.singer
        totalTimeLabel.text = musicMessageM.totalTimeFormat
        
        // 添加动画
        addRotationAnimation()
        
        if musicMessageM.isPlaying {
            resumeRotationAnimation()
        } else {
            pauseRotationAnimation()
        }
        
        // 更新歌词(因为当歌曲切换时, 对应歌曲的歌词内容也需要切换一次)
        let musicM = musicMessageM.musicM
        let lrcMs = QQDataTool.getLrcMData((musicM?.lrcname)!)
        lrcTVC.lrcMs = lrcMs
        
        // 拿到歌词数据模型,之后, 需要展示歌词, 在这里, 是交给lrcTVC控制器来展示, 没有必要放到这个控制器里面展示
        // 将白点, 这个控制器负责的就是, 拿歌词数据(具体怎么拿, 工具类) -> 展示歌词数据(具体怎么展示, 别的控制器)
    }
    
    // 设置通知
    func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(nextMusic), name: NSNotification.Name(rawValue: kPlayerFinishNotification), object: nil)
    }
    
    // 进度条设置
    func setSlider() -> () {
        //progressSlider.minimumTrackTintColor
        
        progressSlider.setThumbImage(UIImage(named: "player_slider_playback_thumb"), for: UIControlState.normal)
        
    }
    
    // 设置前景图片圆角
    func setForeImageView() -> () {
        // 调好后做离屏渲染
        foreImageView.layer.cornerRadius = foreImageView.width * 0.5
        foreImageView.layer.masksToBounds = true
    }
    
    // 设置歌词背景视图(动画使用)
    func setLrcBackView() -> () {
        lrcBackView.delegate = self
        lrcBackView.isPagingEnabled = true
        lrcBackView.showsHorizontalScrollIndicator = false
        
    }
    
    // 添加了一个歌词视图
    func addLrcView() -> () {
        lrcBackView.addSubview(lrcTVC.tableView)
        
    }
    
    func setLrcFrame() {
        lrcTVC.tableView.frame = lrcBackView.bounds
        lrcTVC.tableView.x = lrcBackView.width
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
}

// MARK:- 功能模块
extension QQDetailVC {
    
    // scrollView 的代理方法实现
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let alpha = 1 - scrollView.contentOffset.x / scrollView.width
        
        foreImageView.alpha = alpha
        lrcLabel.alpha = alpha
        lrcTVC.tableView.alpha = 1 - alpha
    }
    
    /// 动画
    func addRotationAnimation() -> () {
        // 先移除之前的动画, 如果有的话
        foreImageView.layer.removeAnimation(forKey: "rotation")
        // 创建动画对象
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = 0
        animation.toValue = Double.pi * 2
        // 从 fromValue 到 toValue 花费时长
        animation.duration = 30
        animation.repeatCount = MAXFLOAT
        // 即使 Home 键 也不会打断停止动画
        animation.isRemovedOnCompletion = false
        foreImageView.layer.add(animation, forKey: "rotation")
    }
    
    func resumeRotationAnimation() -> () {
        foreImageView.layer.resumeAnimation()
    }
    
    func pauseRotationAnimation() -> () {
        foreImageView.layer.pauseAnimation()
    }
    
    // 所增添的定时器方法
    func addTimer() {
        updateTimesTimer = Timer(timeInterval: 1, target: self, selector: #selector(setUpTimes), userInfo: nil, repeats: true)
        
        RunLoop.current.add(updateTimesTimer!, forMode: RunLoopMode.commonModes)
    }
    
    func addDisPlayLink() {
        displayLink = CADisplayLink(target: self, selector: #selector(updateLrcData))
        displayLink?.add(to: RunLoop.current, forMode: RunLoopMode.commonModes)
    }

    // 所移除的定时器方法
    func removeTimer() {
        updateTimesTimer?.invalidate()
        updateTimesTimer = nil
    }
    
    func removeDisplayLink() {
        displayLink?.invalidate()
        displayLink = nil
    }
    
    // 定时器1 配置的执行方法
    func setUpTimes() {
        let musicMessageM = QQMusicOperationTool.shareInstance.getMusicMessageM()
        costTimeLabel.text = musicMessageM.costTimeFormat
        
        if playOrPauseBtn.isSelected != musicMessageM.isPlaying {
            playOrPauseBtn.isSelected = musicMessageM.isPlaying
            
            if musicMessageM.isPlaying {
                resumeRotationAnimation()
            } else {
                pauseRotationAnimation()
            }
        }
        
        // 设置 slider 的播放进度
        progressSlider.value = Float(musicMessageM.costTime / musicMessageM.totalTime)
        
        // 歌词的话 lrcLabel
    }
    
    // 定时器2 配置的执行方法
    func updateLrcData() {
        
        let musicMessageM = QQMusicOperationTool.shareInstance.getMusicMessageM()
        
        // 1. 拿到当前行号
        let rowLrcM = QQDataTool.getRowLrcM(lrcTVC.lrcMs, currentTime: musicMessageM.costTime)
        // 2. 滚动到对应行
        lrcTVC.scrollRow = rowLrcM.row
        
        // 3. 给歌词label, 赋值
        lrcLabel.text = rowLrcM.lrcM?.lrcContent
        
        // 4. 更新歌词进度
        if rowLrcM.lrcM != nil {
            let progressTime = CGFloat(musicMessageM.costTime - (rowLrcM.lrcM?.startTime)!)
            
            let totalTime = CGFloat((rowLrcM.lrcM?.endTime)! - (rowLrcM.lrcM?.startTime)!)
            
            lrcLabel.progress = progressTime / totalTime
            
            lrcTVC.progress = lrcLabel.progress
        }
        
        // 更新锁屏界面信息
        if UIApplication.shared.applicationState == .background {
            QQMusicOperationTool.shareInstance.setUpLockMessage()
        }
    }
}

// MARK:- 远程事件
extension QQDetailVC {
    
    override func remoteControlReceived(with event: UIEvent?) {
        switch (event?.subtype)! {
        case .remoteControlPlay:
            print("播放")
            QQMusicOperationTool.shareInstance.playCurrentMusic()
        case .remoteControlPause:
            print("暂停")
            QQMusicOperationTool.shareInstance.pauseCurrentMusic()
        case .remoteControlNextTrack:
            print("下一首")
            QQMusicOperationTool.shareInstance.nextMusic()
        case .remoteControlPreviousTrack:
            print("上一首")
            QQMusicOperationTool.shareInstance.preMusic()
        default:
            print("none")
        }
        
        setUpOnce()
    }
    
    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
        QQMusicOperationTool.shareInstance.nextMusic()
        setUpOnce()
    }
    
}



