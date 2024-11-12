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
                        
                    }
                    .foregroundColor(.white)
                    .frame(width:300, height: 50)
                    .background(Color.purple)
                    .cornerRadius(10)
                    
                    NavigationLink(destination: HomeScreen()) {
                        Text("Click to Navigate")
                            .frame(width: 300, height:150, alignment: .center)
                            .background(Color.gray)
                            .foregroundColor(Color.black)
                            .cornerRadius(50)
                    }
                }
                
            } .navigationBarHidden(true)
        }
    }
    
    //func authenticateUser
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}
