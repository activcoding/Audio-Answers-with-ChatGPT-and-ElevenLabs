//
//  ListView.swift
//  ChatGTP-Audio
//
//  Created by Tommy Ludwig on 03.06.23.
//

import SwiftUI

struct ListView: View {
    @ObservedObject var gpt: ChatCPTViewModel = ChatCPTViewModel()
    var body: some View {
        List(gpt.messages, id: \.self) { message in
            Text(message)
        }.cornerRadius(20)
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}
