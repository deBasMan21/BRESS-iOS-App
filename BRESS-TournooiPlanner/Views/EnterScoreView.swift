//
//  EnterScoreView.swift
//  BRESS-TournooiPlanner
//
//  Created by Bas Buijsen on 06/01/2022.
//

import SwiftUI

struct EnterScoreView: View {
    @Binding var showPopUp : Bool
    @Binding var showLoader: Bool
    var refresh : () async -> Void
    var game : Game
    
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
            Text("\(game.player1.firstName) tegen \(game.player2.firstName) in \(game.field!.name)")
            Text("Geef per set voor elke speler de score aan")
            
            VStack{
                HStack{
                    Text("Set 1").padding(10)
                    TextField(game.player1.firstName, text: $score[0][0])
                        .padding(5)
                        .background(Color("ButtonTextBlack"))
                        .cornerRadius(5)
                        .autocapitalization(.none)
                        .textContentType(.oneTimeCode)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color("ButtonBlack"))

                    Text("-")
                    
                    TextField(game.player2.firstName, text: $score[1][0])
                        .padding(5)
                        .background(Color("ButtonTextBlack"))
                        .cornerRadius(5)
                        .autocapitalization(.none)
                        .textContentType(.oneTimeCode)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color("ButtonBlack"))
                }
                
                HStack{
                    Text("Set 2").padding(10)
                    
                    TextField(game.player1.firstName, text: $score[0][1])
                        .padding(5)
                        .background(Color("ButtonTextBlack"))
                        .cornerRadius(5)
                        .autocapitalization(.none)
                        .textContentType(.oneTimeCode)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color("ButtonBlack"))
                    
                    Text("-")
                    
                    TextField(game.player2.firstName, text: $score[1][1])
                        .padding(5)
                        .background(Color("ButtonTextBlack"))
                        .cornerRadius(5)
                        .autocapitalization(.none)
                        .textContentType(.oneTimeCode)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color("ButtonBlack"))
                }
                
                HStack{
                    Text("Set 3").padding(10)
                    
                    TextField("\(game.player1.firstName)", text: $score[0][2])
                        .padding(5)
                        .background(Color("ButtonTextBlack"))
                        .cornerRadius(5)
                        .autocapitalization(.none)
                        .textContentType(.oneTimeCode)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color("ButtonBlack"))
                    
                    Text("-")
                    
                    TextField(game.player2.firstName, text: $score[1][2])
                        .padding(5)
                        .background(Color("ButtonTextBlack"))
                        .cornerRadius(5)
                        .autocapitalization(.none)
                        .textContentType(.oneTimeCode)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color("ButtonBlack"))
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
//        for playerScore in score {
//            for setScore in playerScore{
//                if setScore.isEmpty {
//                    errorMessage = "Er is een veld leeg"
//                    return false
//                }
//            }
//        }
        for index in 0...1 {
            for j in 0...1{
                if score[index][j].isEmpty{
                    errorMessage = "Er is een veld leeg"
                    return false
                }
            }
        }
        
        var setWins : [Bool?] = [nil, nil, nil]
        for index in 0...2 {
            if Int(score[0][index]) != nil && Int(score[1][index]) != nil {
                let score0 = Int(score[0][index])!
                let score1 = Int(score[1][index])!
                if score0 > score1 {
                    setWins[index] = true
                } else if score0 < score1{
                    setWins[index] = false
                }
            }
        }
        
        var scorePlayer1 = 0
        var scorePlayer2 = 0
        
        for winner in setWins {
            if winner == true{
                scorePlayer1 += 1
            } else if winner == false{
                scorePlayer2 += 1
            }
        }
        
        if scorePlayer1 != 2 && scorePlayer2 != 2 {
            errorMessage = "Een speler moet minimaal 2 sets winnen"
            return false
        }

        let scoreInInt : [[Int]] = [[Int(score[0][0])!,Int(score[0][1])!,Int(score[0][2]) ?? 0], [Int(score[1][0])!,Int(score[1][1])!,Int(score[1][2]) ?? 0]]
        
        for index in 0...2{
            if scoreInInt[0][index] > 11 || scoreInInt[1][index] > 11 {
                let diff = abs(scoreInInt[0][index] - scoreInInt[1][index])
                if diff != 2 {
                    errorMessage = "Er is precies een verschil van 2 nodig in set \(index + 1)"
                    return false
                }
            } else if scoreInInt[0][index] == 11 || scoreInInt[1][index] == 11{
                let diff = abs(scoreInInt[0][index] - scoreInInt[1][index])
                if diff < 2 {
                    errorMessage = "Er is minimaal een verschil van 2 nodig in set \(index + 1)"
                    return false
                }
            }
        }
        
        return true
    }
    
    func saveScore() async {
        do{
            showLoader = true
            try await enterScore(score: score, gameId: game.id)
            showPopUp = false
            showLoader = false
        } catch let exception {
            print(exception)
        }
    }
}
