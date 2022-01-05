//
//  ContentView.swift
//  BRESS-TournooiPlanner
//
//  Created by Bas Buijsen on 05/01/2022.
//

import SwiftUI

struct ContentView: View {
    @State var homeView = false;
    
    var body: some View {
        if homeView{
            HomeView(toHome: $homeView)
        } else {
            LoginView(toHome: $homeView)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

