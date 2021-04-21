//
//  ContentView.swift
//  leadsdoit-test
//
//  Created by Dmytro Dmytriiev on 21.04.2021.
//

import SwiftUI
import WebKit
import Firebase
import FirebaseAuth
import UserNotifications

struct ContentView: View {
    
    @State var balance: Int = 300
    @State var screenIndex = 1
    
    @StateObject var delegate = NotificationDelegate()
    
    let content = UNMutableNotificationContent()
    var screen =  UIScreen.main.bounds
    
    var body: some View {
        GeometryReader {
            geo in
            VStack {
                if screenIndex == 0 {
                    Spacer()
                    JackpotView(geo: geo, balance: $balance)
                }
                else if screenIndex == 1 {
                    WebpageView()
                }
                Spacer()
                TabsView(screenIndex: $screenIndex)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .background(
                Image("bg")
                    .resizable()
                    .frame(width: screen.width, height: screen.height)
                    .edgesIgnoringSafeArea(.top)
            )
        }
        .onAppear {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
                (_, _) in
            }
            
            UNUserNotificationCenter.current().delegate = delegate
        }
        .edgesIgnoringSafeArea(.bottom)
        .preferredColorScheme(.dark)
    }
}

class NotificationDelegate: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge, .banner, .sound])
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
