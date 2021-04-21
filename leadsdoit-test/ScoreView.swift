//
//  ScoreView.swift
//  TestTask
//
//  Created by Dmytro Dmytriiev on 20.04.2021.
//

import SwiftUI

struct ScoreView: View {
    var boardSize: CGFloat
    @Binding var score: Int
        
    var body: some View {
        ZStack {
            Image("score-bg")
                .resizable()
                .frame(width: boardSize / 2, height: boardSize / 4)
                .scaledToFit()

            Text("\(score)$")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.green)
        }
    }
}

struct ScoreView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
