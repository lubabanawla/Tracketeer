//
//  HomeScreen.swift
//  Tracketeer
//
//  Created by Student on 11/12/24.
//

import SwiftUI

struct HomeScreen: View {
    @State private var totalHours = 0
    // @State private var posts: [Post] = [] // make post
    @State private var postText = ""
    
    var body: some View{
        VStack{
            Text("Welcome to Tracketeer")
            
            Circle()
                .scale(0.4)
                .foregroundColor(.purple)
                .offset(y: -260)
                
            TextField("Enter your new volunteer submission", text: $postText)
                .textFieldStyle(.roundedBorder)
            
            Button("Post") {
                let postData= ["text": postText]
                
                
            }
            

            
        }
    }
        struct HomeScreen_Previews: PreviewProvider {
            static var previews: some View{
                HomeScreen()
            }
        }
    }

#Preview {
    HomeScreen()
}
