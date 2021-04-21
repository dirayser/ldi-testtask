//
//  TabsView.swift
//  pc-builder
//
//  Created by Dmytro Dmytriiev on 19.04.2021.
//

import SwiftUI

struct TabsView: View {
    @Binding var screenIndex: Int
    var body: some View {
        HStack(spacing: 40) {
            
            Spacer()
            
            Button(action: {
                self.screenIndex = 0
            }) {
                VStack {
                    Image(systemName: "dollarsign.circle")
                        .resizable()
                        .frame(width: 30, height: 30)
                    Text("JackPot")
                        .fontWeight(.bold)
                }
                .foregroundColor(screenIndex == 0 ? .black : .gray)
                
            }
            
            Spacer()
            
            Button(action: {
                self.screenIndex = 1
            }) {
                VStack {
                    Image(systemName: "xserve")
                        .resizable()
                        .frame(width: 30, height: 30)
                    Text("web")
                        .fontWeight(.bold)
                }
                .foregroundColor(screenIndex == 1 ? .black : .gray)
            }
            
            Spacer()
            
        }
        .padding(.horizontal, 30)
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity)
        .foregroundColor(.black)
        .background(Color.white)
    }
}

struct TabsView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
