//
//  Debounce.swift
//  PodOuvir
//
//  Created by ProDoctor on 24/04/24.
//

import Foundation

final class Debounce<T> {
    private let block: @Sendable (T) async -> Void
    private let duration: ContinuousClock.Duration
    private var task: Task<Void, Never>?
    
    init(
        duration: ContinuousClock.Duration,
        block: @Sendable @escaping (T) async -> Void
    ) {
        self.duration = duration
        self.block = block
    }
    
    deinit {
        cancel()
    }
    
    func emit(value: T) {
        self.task?.cancel()
        self.task = Task { [duration, block] in
            do {
                try await Task.sleep(for: duration)
                await block(value)
            } catch {}
        }
    }
    
    func cancel() {
        task?.cancel()
    }
}
