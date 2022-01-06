//
//  NoGameView.swift
//  BRESS-TournooiPlanner
//
//  Created by Bas Buijsen on 06/01/2022.
//

import SwiftUI

struct NoGameView: View {
    var body: some View {
        VStack{
            VStack(alignment: .center, spacing: 0, content: {
                HStack{
                    Color.gray.overlay(
                        Text("Je huidige wedstrijd")
                            .foregroundColor(.white)
                    )
                }.frame(height: 50)
                
                HStack{
                    Color.accentColor.overlay(
                        Text("Je hebt op dit moment geen wedstrijd")
                            .foregroundColor(.white)
                    )
                }.frame(height: 50)
                
            })
            
        }.border(.gray, width: 1)
    }
}

struct NoGameView_Previews: PreviewProvider {
    static var previews: some View {
        NoGameView()
    }
}
