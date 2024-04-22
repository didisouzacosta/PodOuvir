//
//  AudioPlayer.swift
//  Adriano Souza Costa
//
//  Created by ProDoctor on 13/04/24.
//

import AVFoundation
import MediaPlayer
import SwiftUI

@Observable
final class AudioPlayer<T: Media> {
    
    typealias Handler = () -> Void
    
    // MARK: - Pubic Variables
    
    var hasPrevious = false
    var hasNext = false
    var previousHandler: Handler?
    var nextHandler: Handler?
    
    private(set) var currentItem: T?
    private(set) var totalTime: Double = 0
    
    var currentTime: Double = 0 {
        didSet { updateInfosCenter() }
    }
    
    private(set) var state: State = .stopped {
        didSet { updateInfosCenter() }
    }
    
    var isPlaying: Bool {
        state == .playing
    }
    
    // MARK: - Private Variables
    
    private let remoteCommand = MPRemoteCommandCenter.shared()
    private let playingInfoCenter = MPNowPlayingInfoCenter.default()
    private let audioSession = AVAudioSession.sharedInstance()
    
    private var timeObserverToken: Any?
    private var player: AVPlayer?
    
    // MARK: - Public Methods
    
    func load(media: T) async throws {
        try await setupSession()
        
        stop()
        
        let playerItem = AVPlayerItem(url: media.url)
        
        if let player {
            player.replaceCurrentItem(with: playerItem)
        } else {
            player = AVPlayer(playerItem: playerItem)
        }
        
        totalTime = 0
        totalTime = try await playerItem.asset.load(.duration).seconds
        
        setupInfoCenter(with: media)
    }
    
    func playPause() {
        isPlaying ? pause() : play()
    }
    
    func play() {
        state = .loading
        player?.play()
        
        addTimeObserver()
    }
    
    func pause() {
        player?.pause()
        state = .paused
    }
    
    func stop() {
        player?.pause()
        player?.seek(to: .zero)
        currentTime = 0
        state = .stopped
        
        removeTimeObserver()
    }
    
    func seek(to time: Double) {
        seek(to: CMTime(seconds: time, preferredTimescale: 1))
    }
    
    func seek(to time: CMTime) {
        player?.seek(to: time)
        currentTime = time.seconds
    }
    
    func backward() {
        guard let currentTime = player?.currentItem?.currentTime().seconds else { return }
        seek(to: max(0, currentTime - 10))
    }
    
    func forward() {
        guard let currentTime = player?.currentItem?.currentTime().seconds else { return }
        seek(to: max(0, currentTime + 10))
    }
    
    // MARK: - Private Methods
    
    private func setupSession() async throws {
        try audioSession.setCategory(.playback)
        try audioSession.setActive(true)
    }
    
    private func setupRemoteTransportControls() {
        remoteCommand.playCommand.addTarget { [weak self] _ in
            self?.play()
            return .success
        }
        
        remoteCommand.pauseCommand.addTarget { [weak self] _ in
            self?.pause()
            return .success
        }
        
        remoteCommand.stopCommand.addTarget { [weak self] _ in
            self?.stop()
            return .success
        }
        
        remoteCommand.changePlaybackPositionCommand.addTarget { [weak self] event in
            if let event = event as? MPChangePlaybackPositionCommandEvent {
                self?.seek(to: event.positionTime)
            }
            return .success
        }
        
        remoteCommand.previousTrackCommand.isEnabled = hasPrevious
        remoteCommand.previousTrackCommand.addTarget { [weak self] _ in
            self?.previousHandler?()
            return .success
        }
        
        remoteCommand.nextTrackCommand.isEnabled = hasNext
        remoteCommand.nextTrackCommand.addTarget { [weak self] _ in
            self?.nextHandler?()
            return .success
        }

    }
    
    private func setupInfoCenter(with media: T) {
        var infos = [String: Any]()
        infos[MPMediaItemPropertyTitle] = media.title
        infos[MPMediaItemPropertyArtist] = media.artist
        infos[MPMediaItemPropertyPlaybackDuration] = totalTime
        
        if let artworkUrl = media.artworkURL {
            Task { try await loadArworkImage(from: artworkUrl) }
        }
        
        playingInfoCenter.nowPlayingInfo = infos
    }
    
    private func updateInfosCenter() {
        var infos = playingInfoCenter.nowPlayingInfo ?? [:]
        infos[MPMediaItemPropertyPlaybackDuration] = totalTime
        infos[MPNowPlayingInfoPropertyElapsedPlaybackTime] = currentTime
        
        playingInfoCenter.nowPlayingInfo = infos
    }
    
    private func addTimeObserver() {
        let interval = CMTimeMakeWithSeconds(0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        
        timeObserverToken = player?.addPeriodicTimeObserver(
            forInterval: interval,
            queue: .main
        ) { [weak self] time in
            if self?.state == .loading && self?.player?.status == .readyToPlay {
                self?.state = .playing
            }
            
            self?.currentTime = time.seconds
        }
    }
    
    private func removeTimeObserver() {
        guard let token = timeObserverToken else { return }
        player?.removeTimeObserver(token)
        timeObserverToken = nil
    }
    
    private func loadArworkImage(from url: URL) async throws {
        let (data, _) = try await URLSession.shared.data(from: url)
        
        guard let image = UIImage(data: data) else { return }
        
        var infos = playingInfoCenter.nowPlayingInfo ?? [:]
        infos[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: image.size) { _ in
            return image
        }
        
        playingInfoCenter.nowPlayingInfo = infos
    }
    
}

extension AudioPlayer {
    
    enum State {
        case playing
        case paused
        case stopped
        case loading
    }
    
}
