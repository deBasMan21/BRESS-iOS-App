//
//  HomeView.swift
//  BRESS-TournooiPlanner
//
//  Created by Bas Buijsen on 05/01/2022.
//

import SwiftUI


struct HomeView: View {
    @Binding var navigation : NavigateToPage
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    @State private var hasGame : Bool = false
    @State private var currentGame : Game = Game(id: 1, score: "0 - 0", winner: 0, inQueue: true, gameStarted: true, field: Field(id: 1, name: "Zaal 1", isAvailable: true), player1: Player(id: 1, name: "Robin Schellius", email: "robin@schellius.nl", score: 10, pointBalance: 0, skillLevel: SkillLevel(id: 0, name: "Beginner"), fbToken: "Token"), player2: Player(id: 1, name: "Sies de Witte", email: "s.dewitte@bress.nl", score: 10, pointBalance: 0, skillLevel: SkillLevel(id: 0, name: "Beginner"), fbToken: "Token"))
    
    @State private var showPopUp : Bool = false
    
    var body: some View {
        VStack{
            HStack{
                Color.gray
                    .ignoresSafeArea()
                    .overlay{
                        HStack{
                            Image("logo-bress-orange")
                                .resizable()
                                .scaledToFit()
                                
                            Spacer()
                            
                            Image("refresh")
                                .resizable()
                                .scaledToFit()
                                .onTapGesture{
                                    Task.init{
                                        hasGame = false
                                        await startHomePage()
                                    }
                                }
                        }.padding(.vertical, 10)
                            .padding(.horizontal, 20)
                    }.frame(height: 50)
            }
            
            ScrollView{
                PullToRefresh(coordinateSpaceName: "pullToRefresh", onRefresh: {
                    Task.init{
                        hasGame = false
                        await startHomePage()
                    }
                })
                
                VStack{
                    if hasGame{
                        GameView(game: currentGame, showPopUp: $showPopUp)
                    } else{
                        NoGameView()
                    }
                }.padding(20)
                    .coordinateSpace(name: "pullToRefresh")
            }

            
            Spacer()
            
            Button{
                Task.init{
                    await signOut(email: getUserEmail())
                }
            } label: {
                Text("Log uit")
                    .foregroundColor(Color.white)
                    .padding(5)
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity)
            }.background(Color.accentColor)
                .padding(.vertical, 15)
                .padding(.horizontal, 30)
            
        }.onAppear(perform:{
            Task.init{
                await startHomePage()
                
            }
        }).popup(isPresented: $showPopUp){
            BottomPopupView{
                EnterScoreView(showPopUp: $showPopUp, refresh: startHomePage, game: currentGame)
            }
        }
    }
    
    func startHomePage() async{
        do{
            let game : Game? = try await getCurrentGame()
            if game != nil{
                currentGame = game!
                
                hasGame = true
            } else {
                hasGame = false
            }
            
            let levels = try await getAllSkillLevels()
            print(levels)
        }catch let exception{
            print(exception)
        }
    }

    func signOut(email: String) async{
        do{
            try await apiLogout(email: email)
            navigation = .login
        }catch let exception{
            print(exception)
        }
    }
}
