//
//  ChatCPTViewModel.swift
//  ChatGTP-Audio
//
//  Created by Tommy Ludwig on 03.06.23.
//

import Combine
import SwiftUI

class ChatCPTViewModel: ObservableObject {
    @Published var messages: [String] = []
    @ObservedObject var settings = AppSettings()
    private var cancellable: AnyCancellable?
    
    func sendMessage(text: String) {
        let prompt = generatePrompt(text: text)
        getChatCPTResponse(prompt: prompt) { result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.messages.append(response)
                }
            case .failure(let error):
                print("An unresolved error occurred: \(error) ")
            }
        }
        
    }
    
    func getChatCPTResponse(prompt: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "https://api.openai.com/v1/completions") else {
            return
        }
        
        let jsonBody: [String: Any] = [
            "model": "text-davinci-003",
            "prompt": prompt,
            "max_tokens": 100,
            "temperature": 1
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(settings.openAIApiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: jsonBody)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(ChatCPTError.requestFailed))
                return
            }
            
            do {
                let response = try JSONDecoder().decode(ChatCPTResponse.self, from: data)
                print(response.usage.total_tokens)
                completion(.success(response.choices.first?.text ?? "No comment"))
            } catch {
                completion(.failure(ChatCPTError.decodingFailed))
            }
        }
        task.resume()
    }
    
    func generatePrompt(text: String) -> String {
        return """
            \(text)
        """
    }
}


enum ChatCPTError: Error {
    case requestFailed
    case decodingFailed
}
