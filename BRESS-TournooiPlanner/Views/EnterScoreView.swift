//
//  EnterScoreView.swift
//  BRESS-TournooiPlanner
//
//  Created by Bas Buijsen on 06/01/2022.
//

import SwiftUI

struct EnterScoreView: View {
    @Binding var showPopUp : Bool
    var refresh : () async -> Void
    var game : Game
    
    @State private var selectedSet1 = true
    @State private var selectedSet2 = true
    @State private var selectedSet3 = 0
    
    @State private var score : [[String]] = [["", "", ""], ["", "", ""]]
    
    @State private var buttonClicked = false
    
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        VStack{
            HStack{
                Spacer()
                
                Image("x").onTapGesture{
                    showPopUp = false
                }
            }.padding(10)
            
            Image("logo-bress-orange")
            Text("Score invullen voor wedstrijd #\(game.id)").font(.system(size: 20, weight: .bold))
            Text("\(game.player1.name) tegen \(game.player2.name) in \(game.field!.name)")
            Text("Geef per set voor elke speler de score aan")
            
            VStack{
                HStack{
                    Text("Set 1").padding(10)
                    TextField(game.player1.name, text: $score[0][0])
                        .padding(5)
                        .background(Color("ButtonTextBlack"))
                        .cornerRadius(5)
                        .autocapitalization(.none)
                        .textContentType(.oneTimeCode)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color("ButtonBlack"))
                        .onSubmit({
                            print(score)
                        })
                    
                    Text("-")
                    
                    TextField(game.player2.name, text: $score[1][0])
                        .padding(5)
                        .background(Color("ButtonTextBlack"))
                        .cornerRadius(5)
                        .autocapitalization(.none)
                        .textContentType(.oneTimeCode)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                }
                
                HStack{
                    Text("Set 2").padding(10)
                    
                    TextField(game.player1.name, text: $score[0][1])
                        .padding(5)
                        .background(Color("ButtonTextBlack"))
                        .cornerRadius(5)
                        .autocapitalization(.none)
                        .textContentType(.oneTimeCode)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                        .onSubmit({
                            print(score)
                        })
                    
                    Text("-")
                    
                    TextField(game.player2.name, text: $score[1][1])
                        .padding(5)
                        .background(Color("ButtonTextBlack"))
                        .cornerRadius(5)
                        .autocapitalization(.none)
                        .textContentType(.oneTimeCode)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                }
                
                HStack{
                    Text("Set 3").padding(10)
                    
                    TextField("\(game.player1.name)", text: $score[0][2])
                        .padding(5)
                        .background(Color("ButtonTextBlack"))
                        .cornerRadius(5)
                        .autocapitalization(.none)
                        .textContentType(.oneTimeCode)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                        .onSubmit({
                            print(score)
                        })
                    
                    Text("-")
                    
                    TextField(game.player2.name, text: $score[1][2])
                        .padding(5)
                        .background(Color("ButtonTextBlack"))
                        .cornerRadius(5)
                        .autocapitalization(.none)
                        .textContentType(.oneTimeCode)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                }
            }.padding(10)
                .padding(.trailing, 20)
            
            if showError{
                Text("\(errorMessage)")
                    .foregroundColor(Color.red)
                    .multilineTextAlignment(.center)
                    .padding(10)
            }
            
                
            Button{
                if isValidScore() {
                    Task.init{
                        buttonClicked = true
                        await saveScore()
                        self.showPopUp = false
                        await refresh()
                    }
                } else {
                    showError = true
                }
            } label: {
                Text("Bevestig score")
                    .foregroundColor(Color("ButtonTextBlack"))
                    .padding(5)
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity)
            }.background(Color("ButtonBlack"))
                .padding(.vertical, 15)
                .padding(.horizontal, 30)
                .disabled(buttonClicked)
        
        }.padding(.bottom, 50)
    }
    
    func isValidScore() -> Bool {
        for playerScore in score {
            for setScore in playerScore{
                if setScore.isEmpty {
                    errorMessage = "Er is een veld leeg"
                    return false
                }
            }
        }
        
        for index in 0...2 {
            if score[0][index] == score[1][index]{
                if Int(score[0][index]) != 0 {
                    errorMessage = "Er is een gelijk spel in een set"
                    return false
                }
            }
        }
        
        return true
    }
    
    func saveScore() async {
        do{
            try await enterScore(score: score, gameId: game.id)
            showPopUp = false
        } catch let exception {
            print(exception)
        }
    }
}
