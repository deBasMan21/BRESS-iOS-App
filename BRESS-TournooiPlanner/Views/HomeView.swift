//
//  HomeView.swift
//  BRESS-TournooiPlanner
//
//  Created by Bas Buijsen on 05/01/2022.
//

import SwiftUI


struct HomeView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        VStack{
            Color.accentColor
                .ignoresSafeArea()
                .overlay(
                    VStack{
                        Image("logo-bress-white")
                            .padding(.bottom, 15)

                    }.padding(50)
                )
        }.onAppear(perform: startHomePage)
    }
    
    func startHomePage(){
        let token = getUserToken()
        print(token)
    }

}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

