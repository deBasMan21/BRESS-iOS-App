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
            Text("\(game.player1.name) tegen \(game.player2.name) in \(game.field.name)")
            Text("Geef per set aan wie er heeft gewonnen")
            
            VStack{
                HStack{
                    Text("Set 1").padding(10)
                    
                    Picker(selection: $selectedSet1, label: Text("Set 1")){
                        Text(game.player1.name).tag(true)
                        Text(game.player2.name).tag(false)
                    }.pickerStyle(.segmented)
                }
                
                HStack{
                    Text("Set 2").padding(10)
                    
                    Picker(selection: $selectedSet2, label: Text("Set 2")){
                        Text(game.player1.name).tag(true)
                        Text(game.player2.name).tag(false)
                    }.pickerStyle(.segmented)
                }
                
                HStack{
                    Text("Set 3").padding(10)
                    
                    Picker(selection: $selectedSet3, label: Text("Set 3")){
                        if selectedSet1 == selectedSet2 {
                            Text("Niemand").tag(0)
                        } else {
                            Text(game.player1.name).tag(1)
                            Text(game.player2.name).tag(2)
                        }
                        
                    }.pickerStyle(.segmented)
                }
            }.padding(10)
                .padding(.trailing, 20)
            
            if showError{
                Text("Score is niet geldig. \n\(errorMessage)")
                    .foregroundColor(Color.red)
                    .multilineTextAlignment(.center)
                    .padding(10)
            }
            
                
            Button{
                if isValidScore(){
                    Task.init{
                        buttonClicked = true
                        await saveScore()
                        self.showPopUp = false
                        await refresh()
                    }
                }else {
                    showError = true
                }
            } label: {
                Text("Bevestig score")
                    .foregroundColor(Color.white)
                    .padding(5)
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity)
            }.background(Color.black)
                .padding(.vertical, 15)
                .padding(.horizontal, 30)
                .disabled(buttonClicked)
        
        }.padding(.bottom, 100)
    }
    
    func isValidScore() -> Bool {
        var score : [Bool] = []
        if selectedSet3 != 0{
            score = [selectedSet1, selectedSet2, selectedSet3 == 1 ? true : false]
        } else {
            score = [selectedSet1, selectedSet2]
        }
        
        var player1Score = 0
        var player2Score = 0
        
        for point in score {
            if point{
                player1Score += 1
            } else {
                player2Score += 1
            }
        }
        
        if player2Score == 2 || player1Score == 2{
            return true
        } else{
            if player1Score == 3 || player2Score == 3 {
                errorMessage = "(Bij het winnen van de eerste 2 sets hoeft de derde niet ingevuld te worden)"
            } else if player1Score == 1 && player2Score == 1 {
                errorMessage = "(Er is geen winnaar, een van de spelers moet 2 sets winnen)"
            } else {
                errorMessage = ""
            }
            return false
        }
    }
    
    func saveScore() async {
        do{
            var score : [Bool] = []
            if selectedSet3 != 0{
                score = [selectedSet1, selectedSet2, selectedSet3 == 1 ? true : false]
            } else {
                score = [selectedSet1, selectedSet2]
            }
            
            try await enterScore(score: score, gameId: game.id)
            showPopUp = false
        } catch let exception {
            print(exception)
        }
    }
}
