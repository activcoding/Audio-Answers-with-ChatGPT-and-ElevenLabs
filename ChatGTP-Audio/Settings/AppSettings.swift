//
//  Settings.swift
//  ChatGTP-Audio
//
//  Created by Tommy Ludwig on 03.06.23.
//

import SwiftUI

class AppSettings: ObservableObject {
    @AppStorage("ai-voice") var voice: String = "21m00Tcm4TlvDq8ikWAM"
    @AppStorage("ai-voice-name") var voiceName: String = "Rachel"
    @AppStorage("eleven-api-key") var elevenLabsApiKey: String = ""
    @AppStorage("openAI-api-key") var openAIApiKey: String = ""
    @AppStorage("view") var listView: Bool = false
}
