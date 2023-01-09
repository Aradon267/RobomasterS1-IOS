//
//  SIgnup.swift
//  Robomaster
//
//  Created by Arad Donenfeld on 01/10/2022.
//

import SwiftUI

/// A view with the requiered fields to create a new user.
struct SIgnupView: View {
    
    @State private var username: String = ""
    @State private var password: String = ""
    @State var foundUsername: Bool = false
    @State var userEmpty: Bool = false
    @State var passEmpty: Bool = false
    @Environment (\.presentationMode) var presentationMode
    
    @StateObject
    var readData = ReadData()
    
    @StateObject
    var writeData = WriteData()
    
    var body: some View {
        VStack {
            SignupText()
            TextField(
                "User name",
                text: $username)
            .autocapitalization(.none)
            .disableAutocorrection(true)
            .padding()
            .background(lightGreyColor)
            .cornerRadius(5.0)
            .padding(.bottom, 20)
                
            SecureField(
                "Password",
                text: $password
            )
            .autocapitalization(.none)
            .disableAutocorrection(true)
            .padding()
            .background(lightGreyColor)
            .cornerRadius(5.0)
            .padding(.bottom, 20)
                
            Button{
                self.userEmpty = false
                self.passEmpty = false
                self.foundUsername = false
                if(username.isEmpty){
                    self.userEmpty = true
                }
                else if (password.isEmpty){
                    self.passEmpty = true
                }
                else{
                    if(handleSignup(username: username, readData: readData)){
                        self.foundUsername = true
                    }
                    else
                    {
                        let newUser = User()
                        newUser.username = username
                        newUser.password = password
                        writeData.writeNewUser(userData: newUser)
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
            } label: {
                SignupButtonContent()
            }
            if(self.foundUsername){
                Text("Username already exists").foregroundColor(.red)
            }
            if(self.userEmpty){
                Text("Username can't be empty").foregroundColor(.red)
            }
            if(self.passEmpty){
                Text("Password can't be empty").foregroundColor(.red)
            }
        }
        .onAppear{
            readData.observerListUsers()
        }
        .padding()
    }
}

/// The function will check if the new user can be added to the Firebase.
/// - Parameters:
///   - username: The new user's username.
///   - readData: An object containig all of the registered users.
/// - Returns: True if the user can be added, false otherwise.
func handleSignup(username: String, readData: ReadData) -> Bool{
    var found: Bool = false
    for user in readData.listUsers{
        if(username == user.username){
            found = true
            break
        }
    }
    return found
}

/// A title for the view.
struct SignupText : View {
    var body: some View {
        return Text("Signup")
            .font(.largeTitle)
            .fontWeight(.semibold)
            .padding(.bottom, 20)
    }
}


struct SIgnupView_Previews: PreviewProvider {
    static var previews: some View {
        SIgnupView()
    }
}
