//
//  ChatGPTResponse.swift
//  ChatGTP-Audio
//
//  Created by Tommy Ludwig on 03.06.23.
//

import Foundation

class ChatCPTResponse: Decodable {
    let id: String
    let object: String
    let created: Int
    let model: String
    let usage: Usage
    let choices: [Choice]
    
    struct Usage: Decodable {
        let prompt_tokens: Int
        let completion_tokens: Int
        let total_tokens: Int
    }
    
    struct Choice: Decodable {
        let text: String
        let index: Int
        let logprobs: String?
        let finish_reason: String
    }
}
