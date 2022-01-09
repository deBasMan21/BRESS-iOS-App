//
//  ContentView.swift
//  BRESS-TournooiPlanner
//
//  Created by Bas Buijsen on 04/01/2022.
//

import SwiftUI

struct LoginView: View {
    @Binding var navigation: NavigateToPage
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    @State private var showError: Bool = false
    
    @State private var disableButton: Bool = false
    
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
                            .autocapitalization(.none)
                            .textContentType(.emailAddress)
                            .keyboardType(.emailAddress)
                            .foregroundColor(.black)
                        
                        Text("Wachtwoord")
                            .foregroundColor(.white)
                        
                        SecureField("Wachtwoord", text: $password)
                            .padding(5)
                            .background(Color.white)
                            .cornerRadius(5)
                            .foregroundColor(.black)
                        
                        if showError{
                            Text("Verkeerde email of wachtwoord")
                                .foregroundColor(Color.red)
                                .multilineTextAlignment(.center)
                                .padding(10)
                        }
                        
                        Button{
                            disableButton = true
                            Task.init{
                                await signIn(email: email, password: password)
                            }
                        } label: {
                            Text("Log in")
                                .foregroundColor(Color.white)
                                .padding(5)
                                .padding(.vertical, 10)
                                .frame(maxWidth: .infinity)
                        }.background(buttonColor)
                            .padding(.top, 15)
                            .disabled(email.isEmpty || password.isEmpty || disableButton)
                        
                        Button{
                            navigation = .register
                        } label: {
                            Text("Nog geen account? Registreer hier")
                                .foregroundColor(Color.white)
                                .padding(5)
                                .padding(.vertical, 10)
                                .frame(maxWidth: .infinity)
                        }.background(Color("AccentColor"))
                            .padding(.top, 15)

                    }.padding(50)
                )
        }.onAppear(perform: startLoginPage)
    }
    
    var buttonColor: Color{
        return email.isEmpty || password.isEmpty || disableButton ? .gray : .black
    }
    
    func startLoginPage(){
        let token = getUserToken()
        if token != " "{
            navigation = .home
        }
    }

    func signIn(email : String, password : String) async {
        do{
            let success = try await apiLogin(email: email, password: password)
            if success{
                navigation = .home
            } else {
                showError = true
                disableButton = false
            }
        } catch let exception{
            print(exception)
        }
    }
}


