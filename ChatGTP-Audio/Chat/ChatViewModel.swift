//
//  ChatModel.swift
//  ChatGTP-Audio
//
//  Created by Tommy Ludwig on 03.06.23.
//

import SwiftUI

struct ChatViewModel: Identifiable {
    var id: UUID = UUID()
    var text: String?
    var audio: Data?
    
    init(id: UUID = UUID(), text: String? = nil, audio: Data? = nil) {
        self.id = id
        self.text = text
        self.audio = audio
    }
}
