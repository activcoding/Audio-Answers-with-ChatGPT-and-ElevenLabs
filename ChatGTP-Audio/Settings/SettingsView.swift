//
//  SettingsView.swift
//  ChatGTP-Audio
//
//  Created by Tommy Ludwig on 03.06.23.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var appSettings = AppSettings()
    @ObservedObject var elevenLabsManager = ElevenLabsManager()
    @State private var openAIAPIKey: String = ""
    @State private var elevenLabsKey: String = ""
    var body: some View {
        NavigationStack {
            List {
                HStack {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 150, height: 150)
                        .foregroundColor(.secondary.opacity(0.3))
                        .border(.green, width: appSettings.listView ? 8 : 0)
                        .cornerRadius(10)
                        .overlay {
                           Image(systemName: "list.bullet")
                                .font(.largeTitle)
                        }
                        .onTapGesture {
                            withAnimation() {
                                self.appSettings.listView = true
                            }
                        }
                    
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 150, height: 150)
                        .foregroundColor(.secondary.opacity(0.3))
                        .border(.green, width: appSettings.listView ? 0 : 8)
                        .cornerRadius(10)
                        .overlay {
                            ProgressView(progress: 0.5)
                                .frame(width: 130)
                        }
                        .onTapGesture {
                            withAnimation() {
                                appSettings.listView = false
                            }
                        }
                }.padding()
                
                NavigationLink {
                    VStack {
                        TextField("Open AI API-Key", text: $openAIAPIKey)
                            .textFieldStyle(.roundedBorder)
                        Button {
                            self.appSettings.openAIApiKey = self.openAIAPIKey
                        } label: {
                            Text("Save")
                        }.buttonStyle(.bordered)
                    }.padding()
                } label: {
                    HStack {
                        Button {
                            
                        } label: {
                            Image(systemName: "brain")
                                .foregroundColor(.green)
                                .frame(width: 20)
                        }
                        .buttonStyle(.bordered)
                        .tint(.green)
                        .padding(5)
                        
                        Text("OpenAI\n API-Key:")
                            .font(.system(size: 15))
                        Spacer()
                        Text("\(appSettings.openAIApiKey)")
                            .font(.system(size: 10))
                            .foregroundColor(.secondary)
                    }
                }
                
                NavigationLink {
                    VStack {
                        TextField("ElevenLabs API-Key", text: $elevenLabsKey)
                            .textFieldStyle(.roundedBorder)
                        
                        Button {
                            self.appSettings.openAIApiKey = self.openAIAPIKey
                        } label: {
                            Text("Save")
                        }.buttonStyle(.bordered)
                    }.padding()
                } label: {
                    HStack {
                        Button {
                            
                        } label: {
                            Image(systemName: "speaker.wave.3")
                                .foregroundColor(.blue)
                                .frame(width: 20)
                        }
                        .buttonStyle(.bordered)
                        .tint(.blue)
                        .padding(5)
                        
                        Text("ElevenLabs\n API-Key:")
                            .font(.system(size: 15))
                        Spacer()
                        Text("\(appSettings.elevenLabsApiKey)")
                            .font(.system(size: 10))
                            .foregroundColor(.secondary)
                    }
                }
                
                
                NavigationLink {
                    VoiceList(currentVoice: appSettings.voice, voices: elevenLabsManager.voices?.voices ?? [])
                } label: {
                    HStack {
                        Button {
                            
                        } label: {
                            Image(systemName: "person.wave.2")
                                .foregroundColor(.blue)
                                .frame(width: 20)
                        }
                        .buttonStyle(.bordered)
                        .tint(.blue)
                        .padding(5)
                        
                        Text("Choose voice")
                            .font(.system(size: 15))
                        
                        Spacer()
                        
                        Text("\(appSettings.voice)")
                            .font(.system(size: 9))
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Settings")
            .onAppear {
                Task {
                    await elevenLabsManager.getVoices()
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
