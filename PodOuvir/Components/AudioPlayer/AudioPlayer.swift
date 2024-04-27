//
//  AudioPlayer.swift
//  Adriano Souza Costa
//
//  Created by ProDoctor on 13/04/24.
//

import AVFoundation
import MediaPlayer
import SwiftUI
import SDWebImageSwiftUI

@Observable
final class AudioPlayer {
    
    typealias T = any Media
    typealias Handler = () -> Void
    
    // MARK: - Pubic Variables
    
    static var shared = AudioPlayer()
    
    var previousHandler: Handler?
    var nextHandler: Handler?
    
    private(set) var currentTime: Double = 0
    private(set) var duration: Double = 0
    private(set) var isLoading = false
    
    private(set) var currentItem: T? {
        didSet {  }
    }
    
    var hasPrevious = false {
        didSet { updateControls() }
    }
    
    var hasNext = false {
        didSet { updateControls() }
    }
    
    private(set) var state: State = .stopped {
        didSet { updateInfosCenter() }
    }
    
    var isPlaying: Bool {
        state == .playing
    }
    
    // MARK: - Private Variables
    
    private let player = AVPlayer()
    private let remoteCommand = MPRemoteCommandCenter.shared()
    private let playingInfoCenter = MPNowPlayingInfoCenter.default()
    private let audioSession = AVAudioSession.sharedInstance()
    
    private var autoplay = false
    private var debounce: Debounce<T>?
    private var timeObserverToken: Any?
    
    // MARK: - Life Cicle
    
    init() {
        defer {
            debounce = Debounce<T>(duration: .seconds(0.2)) { [weak self] media in
                try? await self?.setupPlayer(media)
            }
        }
        
        do {
            try setupSession()
        } catch {
            print("Error on create session: \(error)")
        }
    
        setupRemoteTransportControls()
    }
    
    // MARK: - Public Methods
    
    func load(_ media: T, autoplay: Bool) async throws {
        guard media.url != currentItem?.url else { return }
        
        currentItem = media
        
        stop()
        
        self.autoplay = autoplay
        isLoading = true
        
        debounce?.emit(value: media)
        setupInfoCenter(with: media)
    }
    
    func playPause() {
        isPlaying ? pause() : play()
    }
    
    func play() {
        state = .loading
        player.play()
        
        addTimeObserver()
    }
    
    func pause() {
        player.pause()
        state = .paused
    }
    
    func stop() {
        currentTime = 0
        duration = 0
        state = .stopped
        isLoading = false
        
        player.pause()
        player.seek(to: .zero)
        
        debounce?.cancel()
        
        removeTimeObserver()
    }
    
    func seek(to time: Double) {
        seek(to: CMTime(seconds: time, preferredTimescale: 1))
    }
    
    func seek(to time: CMTime) {
        player.seek(to: time)
        currentTime = time.seconds
    }
    
    func backward(time: Double = 10) {
        guard let currentTime = player.currentItem?.currentTime().seconds else { return }
        seek(to: max(0, currentTime - time))
    }
    
    func forward(time: Double = 10) {
        guard let currentTime = player.currentItem?.currentTime().seconds else { return }
        seek(to: max(0, currentTime + time))
    }
    
    // MARK: - Private Methods
    
    private func setupSession() throws {
        try audioSession.setCategory(.playback)
        try audioSession.setActive(true)
    }
    
    private func setupPlayer(_ media: T) async throws {
        do {
            player.currentItem?.asset.cancelLoading()
            player.replaceCurrentItem(with: .init(url: media.url))
            
            duration = try await player.currentItem?.asset.load(.duration).seconds ?? 0
            
            if autoplay { play() }
        } catch {
            print(error)
        }
        
        updateInfosCenter()
        
        isLoading = false
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
        
        remoteCommand.previousTrackCommand.addTarget { [weak self] _ in
            self?.previousHandler?()
            return .success
        }
        
        remoteCommand.nextTrackCommand.addTarget { [weak self] _ in
            self?.nextHandler?()
            return .success
        }
    }
    
    private func setupInfoCenter(with media: T) {
        var infos = [String: Any]()
        infos[MPMediaItemPropertyTitle] = media.title
        infos[MPMediaItemPropertyArtist] = media.author
        
        Task { try await loadArworkImage(from: media.image) }
        
        playingInfoCenter.nowPlayingInfo = infos
    }
    
    private func updateInfosCenter() {
        var infos = playingInfoCenter.nowPlayingInfo ?? [:]
        infos[MPMediaItemPropertyPlaybackDuration] = duration
        infos[MPNowPlayingInfoPropertyElapsedPlaybackTime] = currentTime
        
        playingInfoCenter.nowPlayingInfo = infos
    }
    
    private func updateControls() {
        remoteCommand.previousTrackCommand.isEnabled = hasPrevious
        remoteCommand.nextTrackCommand.isEnabled = hasNext
    }
    
    private func addTimeObserver() {
        guard timeObserverToken == nil else { return }
        
        let interval = CMTimeMakeWithSeconds(0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        
        timeObserverToken = player.addPeriodicTimeObserver(
            forInterval: interval,
            queue: .main
        ) { [weak self] time in
            if self?.state == .loading && self?.player.status == .readyToPlay {
                self?.state = .playing
            }
            
            self?.currentTime = time.seconds
        }
    }
    
    private func removeTimeObserver() {
        guard let token = timeObserverToken else { return }
        player.removeTimeObserver(token)
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
