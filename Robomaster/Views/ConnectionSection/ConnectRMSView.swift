//
//  ConnectRMS.swift
//  Robomaster
//
//  Created by Arad Donenfeld on 30/09/2022.
//

import SwiftUI

/// A view containing the requiered fields to connect to a server.
struct ConnectRMSView: View {
    @State private var IP: String = ""
    @State private var port: String = ""
    @State var correctIPStructure: Bool = true
    @State var correctPortStructure: Bool = true
    @State var addrEmpty: Bool = false
    @State var portEmpty: Bool = false
    @State var failedToConnect: Bool = false
    @State var moveToLogin: Bool = false
    var username: String
    @State var connected: Bool = false
    @State var robomaster: RobomasterClass = RobomasterClass(ip: "4.5.6.7", port: "4574")
    @Environment (\.presentationMode) var presentationMode


    var body: some View {
        return Group {
            VStack {
                ConnectText()
                TextField(
                    "IP Address",
                    text: $IP)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .padding()
                .background(lightGreyColor)
                .cornerRadius(5.0)
                .padding(.bottom, 20)
                    
                TextField(
                    "Port",
                    text: $port
                )
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .padding()
                .background(lightGreyColor)
                .cornerRadius(5.0)
                .padding(.bottom, 20)
                
                Button{
                    if(self.checkInput()){
                        self.robomaster = RobomasterClass(ip: IP, port: port)
                        if(self.robomaster.establishConnection()){
                            self.connected = true
                        }
                        else{
                            self.failedToConnect = true
                        }
                    }
                } label: {
                    ConnectButtonContent()
                }
                .fullScreenCover(isPresented: $connected, content:{ CommandHost(username: "a", robomaster: robomaster)})
                Button{
                    self.moveToLogin = true
                } label: {
                    LogoutButtonContent()
                }
                if(!self.correctIPStructure){
                    Text("IP must be [0-255].[0-255].[0-255].[0-255]").foregroundColor(.red)
                }
                if(self.addrEmpty || self.portEmpty){
                    Text("Fields can't be empty").foregroundColor(.red)
                }
                if(!self.correctPortStructure){
                    Text("Port must be a number").foregroundColor(.red)
                }
                if(self.failedToConnect){
                    Text("Failed to connect to given server").foregroundColor(.red)
                }
            }
            .fullScreenCover(isPresented: $moveToLogin, content: {LoginView()})
            .padding()
        }
    }
    
    /// The function will check if any input is missing or incorrect.
    /// - Returns: True if input is fine, false otherwise.
    func checkInput() -> Bool{
        self.correctIPStructure = true
        self.correctPortStructure = true
        self.addrEmpty = false
        self.portEmpty = false
        self.failedToConnect = false
        
        if(IP.isEmpty || port.isEmpty){
            self.addrEmpty = IP.isEmpty
            self.portEmpty = port.isEmpty
        }
        else if !port.isNumber{
            self.correctPortStructure = false
        }
        else{
            if(validateIpAddress(ipToValidate: IP)){
                return true
            }
            else{
                self.correctIPStructure = false
            }
        }
        return false
    }
}



/// The function will check if a given String is an IP address.
/// - Parameter ipToValidate: The string to check.
/// - Returns: Ture if the string is an Ip, false otherwise.
func validateIpAddress(ipToValidate: String) -> Bool {

    var sin = sockaddr_in()
    var sin6 = sockaddr_in6()

    if ipToValidate.withCString({ cstring in inet_pton(AF_INET6, cstring, &sin6.sin6_addr) }) == 1 {
        // IPv6 peer.
        return true
    }
    else if ipToValidate.withCString({ cstring in inet_pton(AF_INET, cstring, &sin.sin_addr) }) == 1 {
        // IPv4 peer.
        return true
    }

    return false;
}

/// A title for the view.
struct ConnectText : View {
    var body: some View {
        return Text("Connect to a RMS server")
            .font(.largeTitle)
            .fontWeight(.semibold)
            .padding(.bottom, 20)
    }
}

/// A button design for "connect" option in the view.
struct ConnectButtonContent : View {
    var body: some View {
        return Text("CONNECT")
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(width: 220, height: 60)
            .background(Color.teal)
            .cornerRadius(15.0)
    }
}

/// A button design for "logout" option in the view.
struct LogoutButtonContent : View {
    var body: some View {
        return Text("LOGOUT")
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(width: 220, height: 60)
            .background(Color.teal)
            .cornerRadius(15.0)
    }
}

extension String  {
    /// The value says if the value is a number or not.
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
}

struct ConnectRMSView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectRMSView(username: "a")
    }
}
