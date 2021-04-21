//
//  JackpotView.swift
//  TestTask
//
//  Created by Dmytro Dmytriiev on 20.04.2021.
//

import SwiftUI

struct JackpotView: View {
    var geo: GeometryProxy
    @Binding var balance: Int
    
    @State var dollarsWon: Int = 0
    @State var rotationDegree: Double = 0
    @State var centerIndexes = [0, 1, 2, 3]
    
    var body: some View {
        HStack {
            Text("JACKPOT")
                .foregroundColor(.pink)
                .font(.largeTitle)
                .fontWeight(.heavy)
        }
        .padding(10)
        .frame(width: geo.size.width)
        .background(Color.yellow.edgesIgnoringSafeArea(.top))
        Spacer()
        
        ScoreView(boardSize: geo.size.width, score: $dollarsWon)
        
        Spacer()
        
        ZStack {
            Image("jp-bg")
                .resizable()
                .frame(width: geo.size.width * 0.9,
                       height: geo.size.width * 0.7)
            Rectangle()
                .strokeBorder(Color.black, style: StrokeStyle(lineWidth: 10, dash: []))
                .frame(width: geo.size.width * 0.9,
                       height: geo.size.width * 0.7)
            HStack(spacing: 15) {
                VStack { // col of elements
                    ItemsView(width: geo.size.width * 0.9 / 5.5, rotationDegree: $rotationDegree, centerIndexes: $centerIndexes, column: 0)
                }
                
                VStack { // col of elements
                    ItemsView(width: geo.size.width * 0.9 / 5.5, rotationDegree: $rotationDegree, centerIndexes: $centerIndexes, column: 1)
                }
                VStack { // col of elements
                    ItemsView(width: geo.size.width * 0.9 / 5.5, rotationDegree: $rotationDegree, centerIndexes: $centerIndexes, column: 2)
                }
                VStack { // col of elements
                    ItemsView(width: geo.size.width * 0.9 / 5.5, rotationDegree: $rotationDegree, centerIndexes: $centerIndexes, column: 3)
                }
            }
            
            VStack(spacing: 0) {
                Rectangle()
                    .fill(Color.black.opacity(0.5))
                    .frame(width: geo.size.width * 0.9,
                           height: geo.size.width * 0.7 / 3)
                Rectangle()
                    .fill(Color.black.opacity(0))
                    .frame(width: geo.size.width * 0.9,
                           height: geo.size.width * 0.7 / 3)
                Rectangle()
                    .fill(Color.black.opacity(0.5))
                    .frame(width: geo.size.width * 0.9,
                           height: geo.size.width * 0.7 / 3)
            }
        }
        .foregroundColor(.black)
        
        
        Button(action: {
            if(balance >= 70) {
                for i in 0..<4 {
                    self.centerIndexes[i] = Int.random(in: 0..<4)
                }
                var idxs = [0, 0, 0, 0]
                
                for i in 0..<4 {
                    idxs[centerIndexes[i]] += 1
                }
                
                idxs.sort { $0 > $1 }
                
                self.dollarsWon = 40 * Int(pow(Double(idxs[0] - 1), 2))
                
                Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { timer in
                    self.rotationDegree = 0
                }
                withAnimation(.linear(duration: 0.5)) {
                    self.rotationDegree += 360 * 5
                }
                withAnimation(.linear(duration: 0.5)) {
                    self.balance -= (70 - dollarsWon)
                }
            }
            else {
                createNotification()
            }
            
        }) {
            Circle()
                .overlay(
                    Image("button-bg")
                        .resizable()
                        .clipShape(Circle())
                        .frame(
                            width: geo.size.width * 0.3,
                            height: geo.size.width * 0.3
                        )
                        .overlay(
                            Text("SPIN")
                                .foregroundColor(.pink)
                                .font(.title)
                                .fontWeight(.heavy)
                        )
                )
                .frame(
                    width: geo.size.width * 0.3,
                    height: geo.size.width * 0.3
                )
            
        }
        
        ZStack {
            Rectangle()
                .fill(Color.white)
                .frame(width: geo.size.width / 4, height: geo.size.width / 6)
                .overlay(
                    Rectangle()
                        .strokeBorder(Color.yellow, style: StrokeStyle(lineWidth: 10, dash: []))
                        .frame(width: geo.size.width / 4, height: geo.size.width / 6)
                )
            VStack {
                Text("\(balance)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                Text("balance")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
            }
        }
    }
    
    func createNotification() {
        let content = UNMutableNotificationContent()
        content.title = "LOW BALANCE"
        content.subtitle = "70$ needed"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "IN-APP", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}

struct ItemsView: View {
    var width: CGFloat
    var icons = [
        "ant.circle",
        "bolt.circle",
        "paperplane.circle",
        "ticket"
    ]
    var imageSpacing: CGFloat = 15
    
    @Binding var rotationDegree: Double
    @Binding var centerIndexes: [Int]
    var column: Int
    
    var body: some View {
        VStack(alignment: .center, spacing: imageSpacing) {
            ForEach(0..<3) { i  in
                let index = i == 1 ? centerIndexes[column] : Int.random(in: 0..<icons.count)
                ZStack {
                    Rectangle()
                        .fill(Color("cell-color"))
                        .frame(width: width * 1.1,
                               height: width * 1.1)
                    Image(systemName: icons[index])
                        .resizable()
                        .foregroundColor(.white)
                        .rotation3DEffect(
                            .degrees(rotationDegree),
                            axis: (x: 1, y: 0, z: 0)
                        )
                        .blur(radius: rotationDegree == 0 ? 0 : 5)
                        .frame(width: width,
                               height: width)
                }
                
            }
        }
        
    }
}

struct JackpotView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()    }
}
