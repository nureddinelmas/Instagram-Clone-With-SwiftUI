//
//  ContentView.swift
//  Instagram-Clone
//
//  Created by Nureddin Elmas on 2021-12-21.
//

import SwiftUI
import CoreMedia
import Firebase
import FirebaseStorage
import SwURL
import SDWebImage
import SDWebImageSwiftUI

var db = Firestore.firestore()
var storage = Storage.storage()


struct ContentView: View {
    var body: some View {
        TabView{
           
            MySida().tabItem {
                    Image(systemName: "book.closed")
                    Text("My Sida")
                }
            
            Upload().tabItem {
                        Image(systemName: "square.and.arrow.up.on.square")
                        Text("Upload")
                    }
        
        Text("Settings")
            .tabItem {
                Image(systemName: "circle.grid.cross")
                Text("Settings")
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(trailing: NavigationLink(destination: UploadView()){
            Image(systemName: "plus.circle")
        })
}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct MySida: View{
    @State var items = [Items]()
    
    @State var image:UIImage = UIImage()
    
    init(){
        listenToFirebase()
        
    }
    var body: some View{
        NavigationView{
            
      
            List{
                ForEach(items){item in
                    VStack(alignment: .leading ){
                        HStack{
                            ZStack{
                                
                                Circle().fill(Color.red).frame(width: 30, height: 30, alignment: .center)
                                Image(systemName: "person")
                            }
                           
                            Text(item.userName)
                                .background(Color.red)
                        }
                 
                        WebImage(url: URL(string: item.imageUrl))
                        .resizable()
                        .scaledToFit()
//                        .clipShape(Circle())
//                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.3, alignment: .center)
                        Text(item.comment)
                    }
                }
            }
           
            .onAppear {
                listenToFirebase()
            }
            .navigationTitle("Instagram").font(.callout)
        }
    }
    
    func listenToFirebase(){
        db.collection("Posts").addSnapshotListener { snapshot, error in
            guard let snapshot = snapshot else {return}
            if error == nil{
                for document in snapshot.documents{
                    let result = Result {
                        try document.data(as: Items.self)
                    }
                
                    switch result {
                    case .success(let item):
                        if let item = item {
                            items.append(item)
                        } else {
                            print("document doesnt exist")
                        }
                    case.failure(let failure):
                        print("Error \(failure)")
                    }
                }
            }
        }
    }
}


struct Upload: View {
    var imageRef = storage.reference().child("images")
    
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var selectedImage: UIImage?
    @State private var isImagePickerDisplay = true
    @State private var isShowingConfirmation = false
    @State var myWriting :String = ""
    @Environment(\.presentationMode) var presentationMode
   
    var body: some View{
        
        VStack {
           
                            Text("Upload Sida").font(.largeTitle)
                        if selectedImage != nil {
                            Image(uiImage: selectedImage!)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .opacity(32.2)
                                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.4)
                        } else {
                            Image(systemName: "photo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.4)
                        }
                        
                        HStack{
                            Button("Camera") {
                                self.sourceType = .camera
                                self.isImagePickerDisplay.toggle()
                            }.padding()
                            
                            Button("photo") {
                                self.sourceType = .photoLibrary
                                self.isImagePickerDisplay.toggle()
                            }.padding()
                        }
           
                        Spacer()
            
                        Text("Please enter a comment under your image : ").padding(.leading)
                        TextEditor(text: $myWriting)
                            .background(Color.blue)
                            .border(Color.blue)
                            .onTapGesture {
                            if myWriting == "Please fill in it" {
                                myWriting = ""
                            }
                        }
                        
                        Button {
                            if selectedImage != nil {
                                saveToFirebase()
                                presentationMode.wrappedValue.dismiss()
                                
                            } else {
                                myWriting = "Please fill in it"
                            }
                            
                        }label: {
                            Text("SAVE").font(.title).font(.largeTitle).foregroundColor(.white).multilineTextAlignment(.center).frame(width: 300, height: 50, alignment: .center).background(Color.blue)
                        }.padding()
                        Spacer()

                    }
        
                    .sheet(isPresented: self.$isImagePickerDisplay) {
                        ImagePickerView(selectedImage: self.$selectedImage, sourceType: self.sourceType)
                        
                    }
        
                    .confirmationDialog("Are you sure? ", isPresented: $isShowingConfirmation) {
                        Text("buradan error hatasi alacagiz")
                    }
        
                
            }
    
    
    func saveToFirebase(){
        let storage = Storage.storage()
        let storageReference = storage.reference()
        let mediaFolder = storageReference.child("images")
        if let data = selectedImage!.jpegData(compressionQuality: 0.5){
            
            let uuid = UUID()
            let imageReference = mediaFolder.child("\(uuid).jpg")
            
            imageReference.putData(data, metadata: nil) { (data, error) in
                if error != nil {
                    
                } else {
                   
                    imageReference.downloadURL { url, error in
                        if error == nil {
                            let imageUrl = url?.absoluteString
                            
                            let db = Firestore.firestore()
                            let item = Items(userName: (Auth.auth().currentUser?.email)!, imageUrl: imageUrl!, comment: myWriting)
                            do {
                                _ = try  db.collection("Posts").addDocument(from: item)
                            } catch{
                                print("error")
                            }
                           
                        }
                    }
                }
            }
         
        
        }
    }
}

