//
//  VoiceList.swift
//  ChatGTP-Audio
//
//  Created by Tommy Ludwig on 03.06.23.
//

import SwiftUI
import AVFAudio

struct VoiceList: View {
    @ObservedObject var elevenLabsManager = ElevenLabsManager()
    @State var audioPlayer: AVAudioPlayer?
    @StateObject var appSettings = AppSettings()
    @State private var testListen: Bool = false
    @State var currentVoice: String
    @State var voices: [Voice]
    var body: some View {
        List {
            ForEach(voices, id: \.id) { voice in
                Button {
                    if !testListen {
                        DispatchQueue.main.async {
                            self.appSettings.voice = voice.voiceID ?? "21m00Tcm4TlvDq8ikWAM"
                            self.currentVoice = voice.voiceID ?? "21m00Tcm4TlvDq8ikWAM"
                        }
                        print(voices)
                    } else {
                        playSound(filename: voice.name ?? "Rachel")
                    }
                } label: {
                    HStack {
                        if !testListen {
                            Circle()
                                .stroke(.black, lineWidth: 1)
                                .frame(width: 20)
                                .overlay {
                                    if voice.voiceID == currentVoice {
                                        Circle()
                                            .foregroundStyle(.indigo)
                                            .frame(width: 15)
                                    }
                                }
                        } else {
                            Image(systemName: "speaker.3")
                        }
                        Text("\(voice.name ?? "No name given")")
                            .foregroundColor(.black)
                        Spacer()
                        Text("\(voice.voiceID ?? "No ID given")")
                            .foregroundColor(.secondary)
                            .font(.subheadline)
                    }
                    .fontDesign(.monospaced)
                }
            }
        }.navigationTitle("Choose a voice")
        .toolbar {
            ToolbarItem {
                Button {
                    withAnimation() {
                        self.testListen.toggle()
                    }
                } label: {
                    Label("Test voices", systemImage: "testtube.2")
                }
            }
        }
    }
    
    func playSound(filename: String) {
        guard let url = Bundle.main.url(forResource: "\(filename)", withExtension: "mp3") else {
            print("Could not find sound file: \(filename)")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("Could not play \(filename).mp3")
        }
    }
}

struct VoiceList_Previews: PreviewProvider {
    static var previews: some View {
        VoiceList(currentVoice: "21m00Tcm4TlvDq8ikWAM", voices: [])
    }
}
