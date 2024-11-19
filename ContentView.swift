//
//  ContentView.swift
//  Tracketeer
//
//  Created by Student on 11/12/24.
//

import SwiftUI

struct ContentView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var wrongUsername = 0
    @State private var wrongPassword = 0
    @State private var showingLoginScreen = false
    
    // Load saved data for user defaults
    
    init(){
        if let savedUsername = UserDefaults.standard.string(forKey: "username"), let savedPassword = UserDefaults.standard.string(forKey: "password") {
            _username = State(initialValue: savedUsername)
            _password = State(initialValue: savedPassword)
            _showingLoginScreen = State(initialValue: true)
            
        }
    }
    
    func authenticateUser(username: String, password: String) {
        if !username.isEmpty && !password.isEmpty {
            UserDefaults.standard.set(username, forKey: "username")
            UserDefaults.standard.set(password, forKey: "password")

            showingLoginScreen = true
            
            
        } else {
            wrongUsername = username.isEmpty ? 1 : 0
            wrongPassword = password.isEmpty ? 1 : 0
        }
    }
    
    var body: some View {
        NavigationView{
            ZStack {
                Color.purple
                    .ignoresSafeArea()
                Circle()
                    .scale(1.7)
                    .foregroundColor(.white.opacity(0.15))
                Circle()
                    .scale(1.35)
                    .foregroundColor(.white)
                
                VStack {
                    Text("Login")
                        .font(.largeTitle)
                        .bold()
                        .padding()
                    
                    TextField("Username", text: $username)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .border(.red, width: CGFloat(wrongUsername))
                    
                    SecureField("Password", text: $password)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .border(.red, width: CGFloat(wrongPassword))
                    
                    Button("Login"){
                        authenticateUser(username: username, password: password)
                    }
                    .foregroundColor(.white)
                    .frame(width:300, height: 50)
                    .background(Color.purple)
                    .cornerRadius(10)
                    
                    NavigationLink(destination: HomeScreen(), isActive: $showingLoginScreen) {
                        EmptyView()
                    }
                }
                
            } .navigationBarHidden(true)
        }
    }
    
}
// function for making login work

#Preview {
    ContentView()
    
}
