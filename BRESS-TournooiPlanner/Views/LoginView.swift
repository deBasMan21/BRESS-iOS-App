//
//  ContentView.swift
//  BRESS-TournooiPlanner
//
//  Created by Bas Buijsen on 04/01/2022.
//

import SwiftUI

struct LoginView: View {
    @Binding var toHome: NavigateToPage
    
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
                        
                        Text("Email")
                            .foregroundColor(.white)
                        
                        TextField("Emailadres", text: $email)
                            .padding(5)
                            .background(Color.white)
                            .cornerRadius(5)
                        
                        Text("Wachtwoord")
                            .foregroundColor(.white)
                        
                        SecureField("Wachtwoord", text: $password)
                            .padding(5)
                            .background(Color.white)
                            .cornerRadius(5)
                        
                        Button{
                            Task.init{
                                await signIn(email: email, password: password)
                                self.toHome = .home
                            }
                        } label: {
                            Text("Log in")
                                .foregroundColor(Color.white)
                                .padding(5)
                                .padding(.vertical, 10)
                                .frame(maxWidth: .infinity)
                        }.background(buttonColor)
                            .padding(.top, 15)
                            .disabled(email.isEmpty || password.isEmpty)

                    }.padding(50)
                )
        }.onAppear(perform: startLoginPage)
    }
    
    var buttonColor: Color{
        return email.isEmpty || password.isEmpty ? .gray : .black
    }
    
    func startLoginPage(){
        let token = getUserToken()
        if token != " " {
            toHome = .home
        }
    }

    func signIn(email : String, password : String) async {
        do{
            try await apiLogin(email: email, password: password)
        } catch let exception{
            print(exception)
        }
    }
}


