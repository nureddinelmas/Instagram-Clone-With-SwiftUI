//
//  IntroView.swift
//  Instagram-Clone
//
//  Created by Nureddin Elmas on 2021-12-21.
//

import SwiftUI
import FirebaseAuth

struct IntroView: View {
    
    @State var userName : String = ""
    @State var password : String = ""
    var body: some View {
        NavigationView{
            
       
        VStack{
            HStack{
                Text("Your Mail Adres :").padding()
                TextField("Your mail adres", text: $userName)
            }
            HStack{
                Text("Your Password :").padding()
                TextField("Your password", text: $password)
            }
            NavigationLink(destination: ContentView()) {
                Text("Submit")
            }

            
        }

        }
        }
  
    
    
    func loginToFirebase() {
        
        Auth.auth().createUser(withEmail: userName, password: password) { result, error in
            if error != nil {
                
                print("olmadi")
                
            } else {
                print("kaydedildi")
            }
        }
        
        
    }
}

struct IntroView_Previews: PreviewProvider {
    static var previews: some View {
        IntroView()
    }
}



