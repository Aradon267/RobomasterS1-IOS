//
//  CommandHost.swift
//  Robomaster
//
//  Created by Arad Donenfeld on 07/10/2022.
//

import SwiftUI

/// A view that manages switching between sending commands and picking options.
struct CommandHost: View {
    var username: String
    var robomaster: RobomasterClass
    @State private var selection: Tab = .commandEditor
    
    enum Tab{
        case commandEditor
        case options
    }
    var body: some View {
        TabView(selection: $selection, content: {
            CommandView(robomaster: robomaster, username: username)
                .tabItem{Label("Command", systemImage: "keyboard")}
                .tag(Tab.commandEditor)
            
            OptionsView(selection: $selection ,robomaster: robomaster, username: username)
                .tabItem{Label("Options", systemImage: "list.bullet")}
                .tag(Tab.options)
        })
    }
}

struct CommandHost_Previews: PreviewProvider {
    static var previews: some View {
        CommandHost(username: "a", robomaster: RobomasterClass(ip: "8.7.6.5", port: "12346"))
    }
}
