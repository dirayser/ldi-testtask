//
//  WebpageView.swift
//  leadsdoit-test
//
//  Created by Dmytro Dmytriiev on 21.04.2021.
//

import SwiftUI
import WebKit

import UserNotifications
import FBSDKLoginKit

struct WebView : UIViewRepresentable {
    
    var urlString: String
    
    func makeUIView(context: Context) -> WKWebView  {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let url = URL(string: urlString) {
            let request: URLRequest = URLRequest(url: url)
            uiView.load(request)
        }
        
    }
    
}


struct WebpageView: View {
    
    @State var logged = false
    @State var email = ""
    @State var manager = LoginManager()
    
    var url =  "https://apple.com"
    var screen =  UIScreen.main.bounds
    
    var body: some View {
        VStack {
            Spacer()
            Button(action: {
                let content = UNMutableNotificationContent()
                content.title = "Local notification title"
                content.subtitle = "Local notification subtitle"
                content.body = "Local notification body"
                content.sound = UNNotificationSound.default
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
                let request = UNNotificationRequest(identifier: "notification.id.01", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request)
            }) {
                Text("Push Notification")
                    .foregroundColor(.white)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(15)
                    .background(Color.blue)
                    .cornerRadius(20)
            }
            Button(action: {
                if logged {
                    manager.logOut()
                    self.email = ""
                    logged = false
                }
                else {
                    manager.logIn(permissions: ["public_profile", "email"], from: nil) { (result, err) in
                        if err != nil {
                            print(err!.localizedDescription)
                            return
                        }
                        if !result!.isCancelled {
                            logged = true
                            let request = GraphRequest(graphPath: "me", parameters: ["fields": "email"])
                            
                            request.start { (_, res, _) in
                                guard let profileData = res as? [String: Any] else { return }
                                self.email = profileData["email"] as! String
                            }
                        }
                        
                    }
                }
            }) {
                Text(logged ? "Log Out" : "Log In")
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(15)
                    .background(Color.blue)
                    .cornerRadius(20)
            }
            Text("\(email)")
                .font(.title)
            
            if logged {
                WebView(urlString: url)
                    .frame(width: screen.width, height: screen.width)
            }
            
            
            Spacer()
        }
    }
}

struct WebpageView_Previews: PreviewProvider {
    static var previews: some View {
        WebpageView()
    }
}
