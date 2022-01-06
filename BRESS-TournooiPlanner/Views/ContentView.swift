//
//  ContentView.swift
//  BRESS-TournooiPlanner
//
//  Created by Bas Buijsen on 05/01/2022.
//

import SwiftUI

struct ContentView: View {
    @State var navigation : NavigateToPage = .login;
    
    var body: some View {
        if navigation == .home{
            HomeView(navigation: $navigation)
        } else if navigation == .login{
            LoginView(navigation: $navigation)
        } else if navigation == .register {
            RegisterView(navigation: $navigation)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

