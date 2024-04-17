//
//  AudioPlayer.swift
//  Adriano Souza Costa
//
//  Created by ProDoctor on 13/04/24.
//

import AVFoundation
import MediaPlayer

@Observable
final class AudioPlayer {
    
    // MARK: - Pubic Variables
    
    static let shared = AudioPlayer()
    
    private(set) var currentItem: Media?
    private(set) var totalTime: TimeInterval = 0
    
    private(set) var currentTime: TimeInterval = 0 {
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
    
    func load(audio: Audio) async throws {
        try await load(media: audio)
    }
    
    func load<T: Media>(media: T) async throws {
        try audioSession.setCategory(.playback)
        try audioSession.setActive(true)
        
        let playerItem = AVPlayerItem(url: media.url)
        
        if let player {
            player.replaceCurrentItem(with: playerItem)
        } else {
            player = AVPlayer(playerItem: playerItem)
        }
        
        currentItem = media
        totalTime = try await playerItem.asset.load(.duration).seconds
        
        setupInfoCenter(with: media)
        setupRemoteTransportControls()
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
        
        remoteCommand.nextTrackCommand.addTarget { [weak self] _ in
            return .success
        }
        
        remoteCommand.previousTrackCommand.addTarget { [weak self] _ in
            return .success
        }
    }
    
    private func setupInfoCenter<T: Media>(with media: T) {
        var infos = [String: Any]()
        infos[MPMediaItemPropertyTitle] = media.title
        infos[MPMediaItemPropertyArtist] = media.artist
        infos[MPMediaItemPropertyPlaybackDuration] = totalTime
        
        if let artworkUrl = media.artworkUrl {
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
    
    protocol Media {
        var url: URL { get }
        var title: String? { get }
        var artist: String? { get }
        var artworkUrl: URL? { get }
    }
    
    struct Audio: Media {
        var url: URL
        var title: String?
        var artist: String?
        var artworkUrl: URL?
    }
    
}
