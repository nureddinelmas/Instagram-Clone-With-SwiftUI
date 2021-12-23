//
//  Instagram_CloneApp.swift
//  Instagram-Clone
//
//  Created by Nureddin Elmas on 2021-12-21.
//

import SwiftUI
import Firebase

@main
struct Instagram_CloneApp: App {
    
    init (){
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            IntroView()
            
        }
    }
}
