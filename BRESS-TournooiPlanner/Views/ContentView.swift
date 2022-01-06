//
//  ContentView.swift
//  BRESS-TournooiPlanner
//
//  Created by Bas Buijsen on 05/01/2022.
//

import SwiftUI

struct ContentView: View {
    @State var navigation : NavigateToPage = .login;
    @State var email : String = ""
    
    var body: some View {
        if navigation == .home{
            HomeView(navigation: $navigation)
        } else if navigation == .login{
            LoginView(navigation: $navigation)
        } else if navigation == .register {
            RegisterView(navigation: $navigation, email: $email)
        } else if navigation == .createPlayer{
            CreatePlayerView(navigation: $navigation, email: $email)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

