//
//  ContentView.swift
//  ChatGTP-Audio
//
//  Created by Tommy Ludwig on 03.06.23.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    @ObservedObject var gpt: ChatCPTViewModel = ChatCPTViewModel()
    @ObservedObject var audioManager = ElevenLabsManager()
    @ObservedObject var settings = AppSettings()
    @State private var showSettings: Bool = false
    @State private var chat: [ChatViewModel] = [ChatViewModel]()
    @State private var sendMessages: [String] = ["Hi, how are ya?"]
    @State private var message: String = ""
    @State private var progress: Double = 0.0
    @State var audioPlayer: AVAudioPlayer?
    @State var data: Data?
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                if settings.listView {
                    ListView()
                } else {
                    ProgressView(progress: progress)
                        .frame(width: 300)
                }
                
                Spacer()
                
                VStack {
                    ForEach(chat, id: \.id) { message in
                        if let text = message.text {
                            UserBubbleView(text: text)
                        } else if let audioData = message.audio {
                            AudioBubbleView(data: audioData)
                        }
                    }
                }
                HStack {
                    TextField("Message", text: $message)
                        .textFieldStyle(.roundedBorder)
                    
                    Button {
                        withAnimation() {
                            self.chat.append(ChatViewModel(id: UUID(), text: message))
                            self.progress = 0.10
                            self.gpt.sendMessage(text: message)
                            self.message = ""
                        }
                    } label: {
                        Image(systemName: "paperplane")
                            .font(.title3)
                    }.buttonStyle(.bordered)
                }
            }
            .padding()
            .onChange(of: gpt.messages) { newValue in
                withAnimation {
                    progress = 0.55
                }
                Task {
                    await audioManager.convertToAudio(text: newValue.last ?? "", voice: "\(settings.voice)")
                    progress = 0.8
                }
            }
            .onChange(of: audioManager.audioData, perform: { data in
                do {
                    if let data = data {
                        withAnimation {
                            progress = 1.0
                            chat.append(ChatViewModel(audio: data))
                        }
                    } else {
                        print("data == nil")
                    }
                } catch {
                    print("Error while loading audio data: \(error.localizedDescription)")
                }
            })
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        self.showSettings.toggle()
                    } label: {
                        Label("Settings", systemImage: "gear")
                    }
                }
                
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    if let audioPlayer = audioPlayer {
                        HStack {
                            Button {
                                audioPlayer.play()
                            } label: {
                                Image(systemName: "play")
                            }
                            
                            Button {
                                audioPlayer.pause()
                            } label: {
                                Image(systemName: "pause")
                            }
                        }.frame(height: 40)
                    }
                }
            }
            .sheet(isPresented: $showSettings) {
                SettingsView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
