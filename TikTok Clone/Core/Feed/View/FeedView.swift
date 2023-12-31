//
//  FeedView.swift
//  TikTok Clone
//
//  Created by Ikbal Demirdoven on 2023-12-11.
//

import SwiftUI
import AVKit

struct FeedView: View {
    @StateObject var viewModel = FeedViewModel()
    @State private var scrollPosition : String?
    @State private var player = AVPlayer()
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(viewModel.posts) {
                    post in
                    FeedCell(post: post, player: player)
                        .id(post.id)
                        .onAppear {
                            playInitialVideoIfNecessary()
                        }
                }
            }
            .scrollTargetLayout()
        }
        .onAppear { player.play() }
        .onDisappear { player.pause() }
        .scrollPosition(id: $scrollPosition)
        .scrollTargetBehavior(.paging)
        .ignoresSafeArea()
        .onChange(of: scrollPosition) { oldValue, newValue in
            playVideoOnChangeOfScrollPosition(postID: newValue)
        }
    }
    
    func playVideoOnChangeOfScrollPosition(postID : String?) {
        guard let currentPost = viewModel.posts.first(where: { $0.id == postID}) else { return }
        player.replaceCurrentItem(with: nil)
        let playerItem = AVPlayerItem(url: URL(string: currentPost.videoURL)!)
        player.replaceCurrentItem(with: playerItem)
    }
    
    func playInitialVideoIfNecessary() {
        guard
            scrollPosition == nil,
            let post = viewModel.posts.first,
            player.currentItem == nil else { return }
        let item = AVPlayerItem(url: URL(string: post.videoURL)!)
        
        player.replaceCurrentItem(with: item)
    }
}

#Preview {
    FeedView()
}
