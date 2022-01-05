//
//  HomeView.swift
//  BRESS-TournooiPlanner
//
//  Created by Bas Buijsen on 05/01/2022.
//

import SwiftUI


struct HomeView: View {
    @Binding var toHome : Bool
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        VStack{
            HStack{
                Image("logo-bress-orange")
                
                Spacer()
                
                Text("settings")
            }
            
            VStack{
                Text("Game")
            }
            
            Spacer()
            
            Button{
                signOut(email: getUserEmail())
            } label: {
                Text("Log uit")
                    .foregroundColor(Color.white)
                    .padding(5)
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity)
            }.background(Color.accentColor)
                .padding(.top, 15)
                .padding(.horizontal, 30)
            
        }.onAppear(perform: startHomePage)
    }
    
    func startHomePage(){
        let token = getUserToken()
        print(token)
    }

    func signOut(email: String){
        apiLogout(email: email)
        toHome = false
    }
}
