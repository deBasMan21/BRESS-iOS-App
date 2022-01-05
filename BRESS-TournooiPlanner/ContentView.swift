//
//  ContentView.swift
//  BRESS-TournooiPlanner
//
//  Created by Bas Buijsen on 04/01/2022.
//

import SwiftUI

struct ContentView: View {
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
                            signIn(email: email, password: password)
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
        }.onAppear(perform: startPage)
    }
    
    var buttonColor: Color{
        return email.isEmpty || password.isEmpty ? .gray : .black
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

func startPage(){
    apiLogout(email: "sem@gmail.com")
    let token = getUserToken()
    print(getUserId())
    if token != " " {
        //TODO navigeer door naar volgende pagina
    }
}

func signIn(email : String, password : String) {
    apiLogin(email: email, password: password)
    
    print(getUserToken())
    print(getUserId())
}
