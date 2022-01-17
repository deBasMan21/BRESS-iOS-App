//
//  UpdatePlayerView.swift
//  BRESS-TournooiPlanner
//
//  Created by Bas Buijsen on 10/01/2022.
//

import SwiftUI

struct UpdatePlayerView: View {
    @Binding var showPopUp : Bool
    
    @State var player : Player = Player(id: 1, firstName: "", lastName: "", email: "", skillLevel: SkillLevel(id: 1, name: "Beginner"))
    @State var levels : [SkillLevel] = []
    @State var skillLevel : Int = 0
    
    @State var disableButton: Bool = false
    
    var body: some View {
        VStack{
            HStack{
                Spacer()
                
                Image("x").onTapGesture {
                    showPopUp = false
                }
            }
            
            Image("logo-bress-orange")
            
            Text("Werk speler informatie bij")
                .font(.system(size: 20, weight: .bold))
                .padding(.bottom, 10)
            
            Text("Deze informatie zal vanaf het volgende tournooi bijgewerkt zijn.")
                .multilineTextAlignment(.center)
                .padding(.bottom, 20)
            
            VStack{
                Text("Voornaam")
                
                TextField("Voornaam", text: $player.lastName)
                    .padding(5)
                    .background(Color.white)
                    .cornerRadius(5)
                    .autocapitalization(.words)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .shadow(color: .black, radius: 1, x: 0, y: 0)
                
                Text("Achternaam")
                
                TextField("Achternaam", text: $player.firstName)
                    .padding(5)
                    .background(Color.white)
                    .cornerRadius(5)
                    .autocapitalization(.words)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .shadow(color: .black, radius: 1, x: 0, y: 0)
                
                Text("Niveau")
                    .padding(.top, 10)
                
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
            }
            
            Button{
                disableButton = true
                Task.init{
                    await updatePlayer()
                }
            } label: {
                Text("Werk bij")
                    .foregroundColor(Color("ButtonTextBlack"))
                    .padding(5)
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity)
            }.background(Color("ButtonBlack"))
                .padding(.vertical, 30)
                .padding(.horizontal, 30)
                .disabled(player.firstName.isEmpty || player.lastName.isEmpty || disableButton)
            
        }.padding(30)
            .onAppear(perform: {
                Task.init{
                    await startUpdatePlayer()
                }
            })
    }

    
    func startUpdatePlayer() async {
        do{
            levels = try await getAllSkillLevels()
            player = try await apiGetPlayer() ?? player
            skillLevel = player.skillLevel.id
        } catch let exception {
            print(exception)
        }
    }
    
    func updatePlayer() async {
        do{
            let result = try await apiUpdatePlayer(firstName: player.firstName, lastName: player.lastName, skillLevel: skillLevel)
            if result {
                showPopUp = false
            }
        } catch let exception {
            print(exception)
        }
    }
}
