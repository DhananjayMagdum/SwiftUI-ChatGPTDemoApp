//
//  ContentView.swift
//  ChatGPTSampleApp
//
//  Created by Dhananjay Magdum on 22/03/23.
//

import SwiftUI
import OpenAISwift

struct QuestionAnswers: Identifiable {
    let id = UUID()
    
    let question: String
    let answer: String
}
struct ContentView: View {
    let openAI =  OpenAISwift(authToken: "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")
    @State private var search = ""
    @State private var questionAnswers: [QuestionAnswers] = []
    @State private var searching = false
    
    private func performOpenAISearch() {
        openAI.sendCompletion(with: search) { result in
            switch result {
            case .success(let success):
                let questionAnswer = QuestionAnswers(question: search, answer: success.choices.first?.text.trimmingCharacters(in: .whitespacesAndNewlines) ?? "")
                questionAnswers.append(questionAnswer)
                search = ""
                searching = false
            case .failure(let error):
                print(error.localizedDescription)
                searching = false
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView(showsIndicators: false) {
                                    ForEach(questionAnswers) { qa in
                                        VStack(spacing: 10) {
                                            Text(qa.question)
                                                .bold()
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                            
                                            Text(qa.answer)
                                                .padding([.bottom], 10)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                        }
                                    }
                                }.padding()
                
                HStack {
                    TextField("Type here...", text: $search)
                    .onSubmit {
                        if !search.isEmpty {
                            searching = true
                            performOpenAISearch()
                        }
                    }
                    .padding()
                    if(searching) {
                        ProgressView()
                            .padding()
                    }
                }
            }
            .navigationTitle("ChatGPT")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
