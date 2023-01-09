//
//  Login.swift
//  Robomaster
//
//  Created by Arad Donenfeld on 30/09/2022.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import Firebase
import AlertToast

let lightGreyColor = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0)

/// A view containing the fields for the user to login.
struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State var savedUser: String = ""
    @State var foundUser: Bool = false
    @State var userEmpty: Bool = false
    @State var notFoundTargetUser: Bool = false
    @State var passEmpty: Bool = false
    @State var missingArgs: Bool = false
    @State var remUser: Bool = false
    @State var savedUserName: String = ""
    @StateObject
    var readData = ReadData()
    
    var body: some View {
        return Group {
            NavigationStack {
                VStack {
                    WelcomeText()
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

                        if(username.isEmpty || password.isEmpty){
                            self.missingArgs = true
                        }
                        else{
                            if(handleLogin(username: username, password: password, readData: readData)){
                                if(self.remUser){
                                    handleSaveUser(username: username, password: password)
                                }
                                self.foundUser = true
                            }
                            else{
                                self.notFoundTargetUser = true
                            }
                        }
                    } label: {
                        LoginButtonContent()
                    }
                    .fullScreenCover(isPresented: $foundUser, content: {ConnectRMSView(username: username)})
                    NavigationLink{
                        SIgnupView()
                    }label: {
                        SignupButtonContent()
                    }
                    Toggle(isOn: $remUser) {
                        Text("Remember user?")
                    }
                    Button{
                        if(self.savedUser != "No saved user was found"){
                            let preferences = UserDefaults.standard
                            let remPassKey = "rememberPass"
                            if preferences.object(forKey: remPassKey) == nil {
                                //nothing
                            } else {
                                let pass = preferences.string(forKey: remPassKey)
                                if(handleLogin(username: self.savedUserName, password: pass!, readData: self.readData)){
                                    self.foundUser = true
                                }
                                else{
                                    self.foundUser = false
                                }
                            }
                        }
                        
                    }label: {
                        Text(self.savedUser)
                    }
                }
            }
            .toast(isPresenting: $missingArgs, alert: {
                AlertToast(type: .error(.red), title: "Missing arguments")
            })
            .toast(isPresenting: $notFoundTargetUser, alert: {
                AlertToast(type: .error(.red), title: "User wasn't found")
            })
            .onAppear{
                readData.observerListUsers()
                self.savedUserName = handleFetchUser()
                if(self.savedUserName == ""){
                    self.savedUser = "No saved user was found"
                }
                else{
                    self.savedUser = "Connect as " + self.savedUserName
                }
            }
        }
        .padding()
    }
}


/// The function will check if the user is in the Firebase.
/// - Parameters:
///   - username: The user's username.
///   - password: The user's password.
///   - readData: An object containig all of the registered users.
/// - Returns: True if the user was found in the Firebase, false otherwise.
func handleLogin(username: String, password: String, readData: ReadData) -> Bool{
    var found: Bool = false
    for user in readData.listUsers{
        if(user.username == username && user.password == password){
            found = true
            break
        }
    }
    return found
}

/// The function will save the user's data to the UserDefaults to skip login next time.
/// - Parameters:
///   - username: The username of the user to save.
///   - password: The password of the user to save.
func handleSaveUser(username: String, password: String){
    let preferences = UserDefaults.standard
    let remUnameKey = "rememberUname"
    let currUname = username
    preferences.set(currUname, forKey: remUnameKey)
    _ = preferences.synchronize()
    let remPassKey = "rememberPass"
    let currPass = password
    preferences.set(currPass, forKey: remPassKey)
    _ = preferences.synchronize()
}

/// The function will fetch the saved user's data.
/// - Returns: The saved user's username or "" if no user was found.
func handleFetchUser() -> String{
    let preferences = UserDefaults.standard

    let remUnameKey = "rememberUname"
    if preferences.object(forKey: remUnameKey) == nil {
        return ""
    } else {
        let username = preferences.string(forKey: remUnameKey)
        return username!
    }
}

/// A title for the view.
struct WelcomeText : View {
    var body: some View {
        return Text("Welcome to RMS controller")
            .font(.largeTitle)
            .fontWeight(.semibold)
            .padding(.bottom, 20)
    }
}

/// A button design for the "login" option in the view.
struct LoginButtonContent : View {
    var body: some View {
        return Text("LOGIN")
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(width: 220, height: 60)
            .background(Color.teal)
            .cornerRadius(15.0)
    }
}

/// A button design for the "signup" option in multiple views.
struct SignupButtonContent : View {
    var body: some View {
        return Text("SIGNUP")
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(width: 220, height: 60)
            .background(Color.teal)
            .cornerRadius(15.0)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
