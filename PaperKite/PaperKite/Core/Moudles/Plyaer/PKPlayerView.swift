//
//  File Name:  PKPlayerView.swift
//  Product Name:   PaperKite
//  Created Date:   2021/2/10 17:03
//

import Cocoa
import AVFoundation

protocol PKPlayerViewDelegate: NSObjectProtocol {
    // 播放完成
    func playerView(didPlayToEndTime view: PKPlayerView)
    func playerView(vidw: PKPlayerView, didPlayWith progress: CGFloat)
}

class PKPlayerView: NSView {

    private var videoPlayer: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    
    weak var delegate: PKPlayerViewDelegate?
    var loopPlay: Bool = true
    var videoGravity: AVLayerVideoGravity = .resize
    var videoURL: URL? {
        didSet {
            setupPlayer()
        }
    }
    
    override func layout() {
        super.layout()
        playerLayer?.frame = bounds
    }
    
    private func setupPlayer() {
        setBackgroundColor(.black)
        
        guard let url = videoURL else {
            playerLayer?.removeFromSuperlayer()
            playerLayer = nil
            setBackgroundColor(.clear)
            return
        }
        let item = AVPlayerItem.init(url: url)
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidPlayToEndTime), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        if let player = videoPlayer {
            player.replaceCurrentItem(with: item)
        } else {
            videoPlayer = AVPlayer.init(playerItem: item)
            videoPlayer?.isMuted = true
        }
        if playerLayer == nil {
            playerLayer = AVPlayerLayer.init(player: videoPlayer)
            playerLayer?.videoGravity = videoGravity
            wantsLayer = true
            layer?.addSublayer(playerLayer!)
            playerLayer?.frame = bounds
        }
        videoPlayer?.play()
        
        // 播放进度
        videoPlayer?.addPeriodicTimeObserver(forInterval: CMTime.init(value: 1, timescale: 1), queue: DispatchQueue.main, using: { [unowned self] (time) in
            let current = CMTimeGetSeconds(time)
            let total = CMTimeGetSeconds(self.videoPlayer?.currentItem?.duration ?? CMTime.init())
            let progress = CGFloat(current) / CGFloat(total)
            self.delegate?.playerView(vidw: self, didPlayWith: progress)
        })
    }
    
    @objc private func playerDidPlayToEndTime() {
        if loopPlay {
            resetPlay()
        }
        delegate?.playerView(didPlayToEndTime: self)
    }
    
    func play() {
        videoPlayer?.play()
    }
    
    func pause() {
        videoPlayer?.pause()
    }
    
    func seek(to time: CMTime) {
        videoPlayer?.seek(to: time)
    }
    
    func resetPlay() {
        videoPlayer?.seek(to: CMTime.init(value: 0, timescale: 1))
        videoPlayer?.play()
    }
    
}
