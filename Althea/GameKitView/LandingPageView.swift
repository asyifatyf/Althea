//
//  LandingPageView.swift
//  Althea
//
//  Created by James Jeremia on 29/06/23.
//

import SwiftUI
import AVFoundation
import AVKit

func getVideoURL() -> URL? {
    // Replace "videoFileName" with the actual name of your video file
    if let videoURL = Bundle.main.url(forResource: "OpeningVideoAlthea", withExtension: "mp4") {
        return videoURL
    }
    return nil
}

struct LandingPageView: View {
    @State private var navigateToNextView = false
    private let player: AVPlayer
    @State private var playerDidFinish = false
    private let playerController = AVPlayerViewController()
    
    init() {
        guard let videoURL = getVideoURL() else {
            fatalError("Video file not found")
        }
        player = AVPlayer(url: videoURL)
        
        // Observe the DidPlayToEndTime notification
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem,
            queue: nil
        ) { [self] notification in
            self.playerDidFinish = true
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack{
                // Video Player Layer
                VideoPlayerLayer(player: player)
                    .onAppear {
                        // Start playing the video automatically
                        playVideo()
                    }
                    .onDisappear {
                        // Stop playing the video when the view disappears
                        pauseVideo()
                    }
                    .onChange(of: playerDidFinish) { didFinish in
                        if didFinish {
                            navigateToNextView = true
                        }
                    }

                NavigationLink(
                    destination: NextView(),
                    isActive: $navigateToNextView,
                    label: {
                        Color.clear

                    })
                .padding(.trailing)
                .padding(.top)
            }
            //            .fullScreenCover(isPresented: $navigateToNextView, content: NextView.init)
            .edgesIgnoringSafeArea(.all)
        }.navigationViewStyle(StackNavigationViewStyle())
    }
    
    
    // Helper method to play the video
    private func playVideo() {
        playerController.player = player
        player.play()
        addTimeObserver()
        
    }
    
    // Helper method to pause the video
    private func pauseVideo() {
        player.pause()
    }
    private func addTimeObserver() {
        let time = CMTime(seconds: 55, preferredTimescale: 1)
        player.addBoundaryTimeObserver(forTimes: [NSValue(time: time)], queue: nil) { [ self] in
            self.navigateToNextView = true
        }
    }
    
    // Remove time observer
    private func removeTimeObserver() {
        player.removeTimeObserver(self)
    }
}

struct NextView: View {
    let game = RealTimeGame.shared
    
    var body: some View {
        HomeView()
            .environmentObject(game)
    }
}

struct VideoPlayerLayer: UIViewControllerRepresentable {
    let player: AVPlayer
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let viewController = AVPlayerViewController()
        viewController.player = player
        
        // Disable player controls
        viewController.showsPlaybackControls = false
        
        // Disable fast forward and rewind gestures
        viewController.allowsPictureInPicturePlayback = false
        viewController.requiresLinearPlayback = true
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        // No updates needed
    }
}



struct LandingPageView_Previews: PreviewProvider {
    static var previews: some View {
        LandingPageView().previewInterfaceOrientation(.landscapeLeft)
    }
}
