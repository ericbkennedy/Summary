//
//  ContentView.swift
//  Summary
//
//  Created by Eric Kennedy on 6/7/23.
//

import SwiftUI

struct ContentView: View {

    @StateObject var viewModel = BrowserViewModel()

    var body: some View {
        NavigationStack {
            VStack {
                TextField("URL",
                          text: $viewModel.urlString,
                          onCommit: {
                    viewModel.loadURLString()
                })
                if let url = URL(string: viewModel.urlString) {
                    BrowserView(url: url, viewModel: viewModel)
                        .frame(height: 300)
                }
                TextEditor(text: $viewModel.transcript)
            }
            .padding()
        }
        .navigationBarTitle("WWDC Summaries")
        .navigationBarTitleDisplayMode(.inline) // smaller centered title
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
