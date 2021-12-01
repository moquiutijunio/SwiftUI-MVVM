//
//  LoginView.swift
//  swiftui-mvvm
//
//  Created by Junio Cesar Moquiuti on 30/11/21.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isLoggingIn = false
    @State private var isShowingErrorAlert = false
    
    init(){
        UITableView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        Form {
            HStack(alignment: .center) {
                Text("Email:")
                    .bold()
                TextField("nome@gmail.com", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            }
            
            HStack(alignment: .center) {
                Text("Senha:")
                    .bold()
                SecureField("******", text: $password)
                    .autocapitalization(.none)
            }
            
            HStack(spacing: 20) {
                Button("Entrar", action: loginAction)
                    .font(.headline)
                    .disabled(email.isEmpty || password.isEmpty)
                ProgressView()
                    .opacity(isLoggingIn ? 1 : 0)
            }
        }
        .navigationTitle("Indentifique-se")
        .disabled(isLoggingIn)
        .alert(isPresented: $isShowingErrorAlert, content: {
            Alert(title: Text("Ops..."),
                  message: Text("Verifique seu email e senha e tente novamente"))
        })
    }
    
    private func loginAction() {
        isLoggingIn = true
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            self.isLoggingIn = false
            self.isShowingErrorAlert = true
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LoginView()
        }
    }
}
