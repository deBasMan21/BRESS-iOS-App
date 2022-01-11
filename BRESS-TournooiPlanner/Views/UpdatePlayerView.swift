//
//  UpdatePlayerView.swift
//  BRESS-TournooiPlanner
//
//  Created by Bas Buijsen on 10/01/2022.
//

import SwiftUI

struct UpdatePlayerView: View {
    @Binding var showPopUp : Bool
    
    @State var player : PlayerObj = PlayerObj(id: 1, name: "", email: "", skillLevel: SkillLevelObj(id: 1, name: "Beginner"))
    @State var levels : [SkillLevelObj] = []
    @State var skillLevel : Int = 0
    
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
            
            Text("Naam")
            
            TextField("Naam", text: $player.name)
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
            
            Button{
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
            let result = try await apiUpdatePlayer(name: player.name, skillLevel: skillLevel)
            if result {
                showPopUp = false
            }
        } catch let exception {
            print(exception)
        }
    }
}
