//
//  ContentView.swift
//  BRESS-TournooiPlanner
//
//  Created by Bas Buijsen on 05/01/2022.
//

import SwiftUI

struct ContentView: View {
    @State var homeView : NavigateToPage = .login;
    
    var body: some View {
        if homeView == .home{
            HomeView(toHome: $homeView)
        } else if homeView == .login{
            LoginView(toHome: $homeView)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

