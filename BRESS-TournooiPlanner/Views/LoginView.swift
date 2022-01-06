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
                        
                        Text("Wachtwoord")
                            .foregroundColor(.white)
                        
                        SecureField("Wachtwoord", text: $password)
                            .padding(5)
                            .background(Color.white)
                            .cornerRadius(5)
                        
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
            toHome = .home
        }
    }

    func signIn(email : String, password : String) async {
        do{
            let success = try await apiLogin(email: email, password: password)
            if success{
                self.toHome = .home
            } else {
                showError = true
                disableButton = false
            }
        } catch let exception{
            print(exception)
        }
    }
}


