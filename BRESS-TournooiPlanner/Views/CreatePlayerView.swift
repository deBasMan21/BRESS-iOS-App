//
//  CreatePlayerView.swift
//  BRESS-TournooiPlanner
//
//  Created by Bas Buijsen on 06/01/2022.
//

import SwiftUI

struct CreatePlayerView: View {
    @Binding var navigation : NavigateToPage
    @Binding var email : String
    
    @State private var levels: [SkillLevel] = []
    
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var skillLevel: Int = 0
    
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
                        
                        Text("Voornaam")
                            .foregroundColor(.black)
                        
                        TextField("Voornaam", text: $firstName)
                            .padding(5)
                            .background(Color.white)
                            .cornerRadius(5)
                            .autocapitalization(.words)
                            .foregroundColor(.black)
                        
                        Text("Achternaam")
                            .foregroundColor(.black)
                        
                        TextField("Achternaam", text: $lastName)
                            .padding(5)
                            .background(Color.white)
                            .cornerRadius(5)
                            .autocapitalization(.words)
                            .foregroundColor(.black)
                        
                        Text("Niveau")
                            .foregroundColor(.black)
                        
                        if(levels.count > 0){
                            Picker(selection: $skillLevel, label: Text("SkillLevel")){
                                ForEach(levels){item in
                                    Text(item.name).tag(item.id)
                                }
                            }.pickerStyle(.segmented)
                                .onAppear(perform: {
                                    skillLevel = levels[0].id
                                })
                        }
                        
                        if showError{
                            Text(errorMessage)
                                .foregroundColor(Color.red)
                                .multilineTextAlignment(.center)
                                .padding(10)
                        }
                        
                        Button{
                            disableButton = true
                            Task.init{
                                await createPlayer()
                            }
                        } label: {
                            Text("Afronden")
                                .foregroundColor(Color.white)
                                .padding(5)
                                .padding(.vertical, 10)
                                .frame(maxWidth: .infinity)
                        }.background(buttonColor)
                            .padding(.top, 15)
                            .disabled(firstName.isEmpty || lastName.isEmpty || disableButton)

                    }.padding(50)
                )
        }.onAppear(perform: {
            Task.init{
                await startCreatePlayerPage()
            }
        })
    }
    
    var buttonColor: Color{
        return firstName.isEmpty || lastName.isEmpty || disableButton ? .gray : .accentColor
    }
    
    func startCreatePlayerPage() async {
        do{
            levels = try await getAllSkillLevels()
            print(levels)
        } catch let exception {
            print(exception)
        }
    }

    func createPlayer() async {
        do{
            let success = try await apiCreatePlayer(email: email, firstName: firstName, lastName: lastName, skillLevel: skillLevel)
            if success {
                navigation = .home
            } else {
                errorMessage = "Er is iets mis gegaan. \nVraag een BRESS medewerker om een speler voor jou aan te maken."
                showError = true
            }
        } catch let exception {
            print(exception)
        }
    }
}

