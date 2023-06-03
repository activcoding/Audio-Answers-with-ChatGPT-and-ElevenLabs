//
//  ElevenLabsAudioPlayer.swift
//  ChatGTP-Audio
//
//  Created by Tommy Ludwig on 03.06.23.
//

import SwiftUI
import AVFoundation

struct ElevenLabsAudioPlayerView: View {
    @State var data: Data?
    @State var audioPlayer: AVAudioPlayer?
    @State var audioFileURL: URL?
    var body: some View {
        VStack {
            if let audioPlayer = audioPlayer {
                HStack {
                    Button {
                        audioPlayer.play()
                    } label: {
                        Image(systemName: "play")
                    }.buttonStyle(.bordered).tint(.indigo)
                    
                    Button {
                        audioPlayer.pause()
                    } label: {
                        Image(systemName: "pause")
                    }.buttonStyle(.bordered).tint(.indigo)
                }.frame(height: 40)
            }
        }.onAppear {
            do {
                if let data = data {
                    audioPlayer = try AVAudioPlayer(data: data)
                    audioPlayer?.prepareToPlay()
                    audioPlayer?.play()
                    print("Ready to play!")
                } else {
                    print("data == nil")
                }
            } catch {
                print("Error while loading audio data: \(error.localizedDescription)")
            }
        }
        .padding()
    }
}

//struct ElevenLabsAudioPlayerView_Previews: PreviewProvider {
//    static var previews: some View {
//        ElevanLabsAudioPlayerView()
//    }
//}

