//
//  PodOuvirApp.swift
//  PodOuvir
//
//  Created by Adriano Souza Costa on 13/04/24.
//

import SwiftUI

@main
struct PodOuvirApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var delegate
    
    private let podcastStore = PodcastStore<Episode>()
    
    var body: some Scene {
        WindowGroup {
            AudioListScreenView()
        }
        .environment(podcastStore)
        
    }
}
