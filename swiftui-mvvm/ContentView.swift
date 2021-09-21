//
//  ContentView.swift
//  swiftui-mvvm
//
//  Created by Junio Cesar Moquiuti on 21/09/21.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var model: ContentViewModel
    
    init(_ model: ContentViewModel) {
        self.model = model
    }
    
    var body: some View {
        Text(model.state.message)
            .onAppear(perform: model.loadData)
    }
}

struct ContentViewState {
    var isLoading: Bool = false
    var message: String = ""
}

final class ContentViewModel: ObservableObject {
    @Published private(set) var state: ContentViewState
    
    init(state: ContentViewState) {
        self.state = state
    }
    
    func loadData() {
        state.isLoading = true
        state.message = "Loading...."
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            self.state.isLoading = false
            self.state.message = "Hello, world!"
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(.init(state: .init(isLoading: true)))
            .previewDisplayName("Loading")
        
        ContentView(.init(state: .init(message: "Hello, word!")))
            .previewDisplayName("Loaded")
    }
}
