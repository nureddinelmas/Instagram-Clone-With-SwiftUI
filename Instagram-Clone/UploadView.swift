//
//  UploadView.swift
//  Instagram-Clone
//
//  Created by Nureddin Elmas on 2021-12-23.
//

import SwiftUI
import FirebaseStorage
import Firebase
import FirebaseAuth
import FirebaseFirestoreSwift

struct UploadView: View {
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

struct UploadView_Previews: PreviewProvider {
    static var previews: some View {
        UploadView()
    }
}
