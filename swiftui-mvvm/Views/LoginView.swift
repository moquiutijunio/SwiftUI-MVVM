//
//  LoginView.swift
//  swiftui-mvvm
//
//  Created by Junio Cesar Moquiuti on 30/11/21.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject private var model: LoginViewModel
    
    init(_ model: LoginViewModel) {
        self.model = model
    }
    
    var body: some View {
        Form {
            HStack(alignment: .center) {
                Text("Email:")
                    .bold()
                TextField("nome@gmail.com", text: model.emailBilding)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            }
            HStack(alignment: .center) {
                Text("Senha:")
                    .bold()
                SecureField("******", text: model.passwordBilding)
                    .autocapitalization(.none)
            }
            HStack(spacing: 20) {
                Button("Entrar", action: model.loginAction)
                    .font(.headline)
                    .disabled(model.state.canSubmit)
                ProgressView()
                    .opacity(model.state.isLoggingIn ? 1 : 0)
            }
        }
        .navigationTitle("Indentifique-se")
        .disabled(model.state.isLoggingIn)
        .alert(isPresented: model.errorAlertBilding, content: {
            Alert(title: Text("Ops..."),
                  message: Text("Usuário ou senha incorretos."))
        })
    }
}

struct LoginViewState {
    var email = ""
    var password = ""
    var isLoggingIn = false
    var isShowingErrorAlert = false
    
    var canSubmit: Bool {
        return email.isEmpty || password.isEmpty
    }
    
    var willMoveToNextScreen = false
}

final class LoginViewModel: ObservableObject {
    @Published private(set) var state: LoginViewState
    
    var emailBilding: Binding<String> {
        Binding(get: { self.state.email }, set: { self.state.email = $0 })
    }
    
    var passwordBilding: Binding<String> {
        Binding(get: { self.state.password }, set: { self.state.password = $0 })
    }

    var errorAlertBilding: Binding<Bool> {
        Binding(get: { self.state.isShowingErrorAlert }, set: { self.state.isShowingErrorAlert = $0 })
    }
    
    var willMoveToNextScreenBinding: Binding<Bool> {
        Binding(get: { self.state.willMoveToNextScreen }, set: { self.state.willMoveToNextScreen = $0 })
    }
    
    init(initialState: LoginViewState) {
        self.state = initialState
    }
    
    func loginAction() {
        state.isLoggingIn = true
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            self.state.isLoggingIn = false
            if self.state.email == "teste", self.state.password == "123" {
                self.state.willMoveToNextScreen = true
            } else {
                self.state.isShowingErrorAlert = true
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LoginView(.init(initialState: .init()))
        }
    }
}
