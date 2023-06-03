//
//  AudioBubbleView.swift
//  ChatGTP-Audio
//
//  Created by Tommy Ludwig on 03.06.23.
//

import SwiftUI
import AVFoundation

struct AudioBubbleView: View {
    @State var audioPlayer: AVAudioPlayer?
    @State var data: Data?
    var body: some View {
        HStack {
            HStack {
                Button {
                    if let audioPlayer {
                        audioPlayer.play()
                    }
                } label: {
                    if audioPlayer == nil {
                        Image(systemName: "play")
                            .foregroundColor(.secondary)
                            .scaleEffect(1.5)
                    } else {
                        Image(systemName: "play")
                            .scaleEffect(1.5)
                    }
                }
                .padding(.leading, 5)
                .padding(.trailing)
                
                Button {
                    if let audioPlayer {
                        audioPlayer.pause()
                    }
                } label: {
                    if audioPlayer == nil {
                        Image(systemName: "pause")
                            .foregroundColor(.secondary)
                            .scaleEffect(1.5)
                    } else {
                        Image(systemName: "pause")
                            .scaleEffect(1.5)
                    }
                }.padding(.trailing, 5)
            }
            .padding()
            .background(Capsule().foregroundColor(.green.opacity(0.1)))
            .padding()
            .overlay {
                HStack {
                    VStack {
                        Spacer()
                        
                        Image(systemName: "brain")
                            .foregroundColor(.green)
                            .padding(6)
                            .background(Circle().foregroundColor(.green.opacity(0.5)))
                    }
                    Spacer()
                }
            }
            Spacer()
        }
        .onAppear {
            do {
                if let data = data {
                    audioPlayer = try AVAudioPlayer(data: data)
                    audioPlayer?.prepareToPlay()
                    audioPlayer?.play()
                } else {
                    print("data == nil")
                }
            } catch {
                print("Error while loading audio data: \(error.localizedDescription)")
            }
        }
    }
}


struct AudioBubbleView_Preview: PreviewProvider {
    static var previews: some View {
        AudioBubbleView()
    }
}
