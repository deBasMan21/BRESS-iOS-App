//
//  RegisterView.swift
//  BRESS-TournooiPlanner
//
//  Created by Bas Buijsen on 06/01/2022.
//

import SwiftUI

struct RegisterView: View {
    @Binding var navigation : NavigateToPage
    @Binding var email : String
    
    @State private var password: String = ""
    @State private var passwordConfirm: String = ""
    
    @State private var showError: Bool = false
    @State private var errorMessage : String = ""
    
    @State private var disableButton: Bool = false
    
    var body: some View {
        VStack{
            Color("LightGray")
                .ignoresSafeArea()
                .overlay(
                    VStack{
                        Image("logo-bress-orange")
                            .padding(.bottom, 15)
                        
                        Text("Email")
                            .foregroundColor(.black)
                        
                        TextField("Emailadres", text: $email)
                            .padding(5)
                            .background(Color.white)
                            .cornerRadius(5)
                            .autocapitalization(.none)
                            .textContentType(.emailAddress)
                            .keyboardType(.emailAddress)
                            .foregroundColor(.black)
                        
                        Text("Wachtwoord")
                            .foregroundColor(.black)
                        
                        SecureField("Wachtwoord", text: $password)
                            .padding(5)
                            .background(Color.white)
                            .cornerRadius(5)
                            .foregroundColor(.black)
                        
                        Text("Herhaal wachtwoord")
                            .foregroundColor(.black)
                        
                        SecureField("Herhaal wachtwoord", text: $passwordConfirm)
                            .padding(5)
                            .background(Color.white)
                            .cornerRadius(5)
                            .foregroundColor(.black)
                        
                        if showError{
                            Text(errorMessage)
                                .foregroundColor(Color.red)
                                .multilineTextAlignment(.center)
                                .padding(10)
                        }
                        
                        Button{
                            disableButton = true
                            Task.init{
                                await signUp(email: email, password: password)
                            }
                        } label: {
                            Text("Registreer")
                                .foregroundColor(Color.white)
                                .padding(5)
                                .padding(.vertical, 10)
                                .frame(maxWidth: .infinity)
                        }.background(buttonColor)
                            .padding(.top, 15)
                            .disabled(email.isEmpty || password.isEmpty || passwordConfirm.isEmpty || password != passwordConfirm || disableButton)
                        
                        Button{
                            navigation = .login
                        } label: {
                            Text("Al een account? Log in")
                                .foregroundColor(Color.white)
                                .padding(5)
                                .padding(.vertical, 10)
                                .frame(maxWidth: .infinity)
                        }.background(Color("LightGray"))
                            .padding(.top, 15)

                    }.padding(50)
                )
        }.onAppear(perform: startRegisterPage)
    }
    
    var buttonColor: Color{
        return email.isEmpty || password.isEmpty || passwordConfirm.isEmpty || password != passwordConfirm || disableButton ? .gray : .accentColor
    }
    
    func startRegisterPage(){
        let token = getUserToken()
        if token != " "{
            navigation = .home
        }
    }

    func signUp(email : String, password : String) async {
        if validEmail(string: email){
            if validPassword(string: password){
                do{
                    let success = try await apiRegister(email: email, password: password)
                    
                    if success.succeeded{
                        if success.playerExists {
                            let loginSucces = try await apiLogin(email: email, password: password)
                            
                            if loginSucces {
                                navigation = .home
                            }
                        } else {
                            navigation = .createPlayer
                        }
                    } else {
                        errorMessage = "Er is iets misgegaan bij het aanmaken.\nMisschien bestaat er al een account op dit email"
                        showError = true
                    }
                } catch let exception{
                    print(exception)
                    errorMessage = exception.localizedDescription
                    showError = true
                }
            } else {
                errorMessage = "invalid password"
                showError = true
            }
        } else {
            errorMessage = "invalid email"
            showError = true
        }
        disableButton = false
    }
    
    func validEmail(string: String) -> Bool {
        if string.count > 100 {
            return false
        }
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: string)
    }
    
    func validPassword(string: String) -> Bool {
        if string.count < 8 {
            return false
        }
        let passwordFormat = ".*[0-9].*"
        let passwordPredicate = NSPredicate(format:"SELF MATCHES %@", passwordFormat)
        return passwordPredicate.evaluate(with: string)
    }
}
