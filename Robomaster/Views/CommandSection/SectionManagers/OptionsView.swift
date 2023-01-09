//
//  OptionsView.swift
//  Robomaster
//
//  Created by Arad Donenfeld on 08/10/2022.
//

import SwiftUI

/// A view containing a list of options for the user.
struct OptionsView: View {
    
    @State private var saveProgram = false
    @Binding var selection: CommandHost.Tab
    @State var robomaster: RobomasterClass
    @State var disconnected = false
    
    @State private var drawSwiftUIColor: Color = Color.red
    @State private var drawHexNumber: String = "#FF0000"
    
    var username: String
    var body: some View {
        NavigationView{
            List{
                Label("Tutorial", systemImage: "chevron.right").overlay(NavigationLink(destination: TutorialView(), label: {EmptyView()}))
                HStack{
                    Label("Color Options", systemImage: "chevron.right")
                    ColorPicker("", selection: $drawSwiftUIColor, supportsOpacity: false)
                        .onChange(of: drawSwiftUIColor) { newValue in
                            getColorsFromPicker(pickerColor: newValue)
                        }
                }
                Label("Clear Queue", systemImage: "chevron.right")
                    .onTapGesture {
                        robomaster.clearQueue()
                        self.selection = CommandHost.Tab.commandEditor
                    }
                Label("Save Program", systemImage: "chevron.right")
                    .onTapGesture {
                        saveProgram.toggle()
                    }
                    .sheet(isPresented: $saveProgram, content: {
                        SaveProgramView(username: username, robomaster: robomaster, selection: $selection)
                    })
                Label("Load Program", systemImage: "chevron.right").overlay(NavigationLink(destination: LoadProgramsView(username: username, robomaster: robomaster, selection: $selection), label: {EmptyView()}))
                Label("Disconnect", systemImage: "chevron.right")
                    .onTapGesture {
                        robomaster.disconnect()
                        self.disconnected = true
                    }
            }
            .fullScreenCover(isPresented: $disconnected, content: {ConnectRMSView(username: username)})
        }
    }
    
    /// The function will get a color from the color picker and parse it.
    /// - Parameter pickerColor: The picked color.
    func getColorsFromPicker(pickerColor: Color) {
        let colorString = "\(pickerColor)"
        let colorArray: [String] = colorString.components(separatedBy: " ")
        
        if colorArray.count > 1 {
            var r: CGFloat = CGFloat((Float(colorArray[1]) ?? 1))
            var g: CGFloat = CGFloat((Float(colorArray[2]) ?? 1))
            var b: CGFloat = CGFloat((Float(colorArray[3]) ?? 1))
            
            if (r < 0.0) {r = 0.0}
            if (g < 0.0) {g = 0.0}
            if (b < 0.0) {b = 0.0}
            
            if (r > 1.0) {r = 1.0}
            if (g > 1.0) {g = 1.0}
            if (b > 1.0) {b = 1.0}
            
            // Update hex
            let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
            drawHexNumber = String(format: "%06X", rgb)
            self.robomaster.setPermaColor(hex: drawHexNumber)
            self.robomaster.parsePermaColor()
        }
    }
}

struct OptionsView_Previews: PreviewProvider {
    @State static var selection: CommandHost.Tab = CommandHost.Tab.options
    static var previews: some View {
        OptionsView(selection: $selection, robomaster: RobomasterClass(ip: "8.7.6.5", port: "12346"), username: "a")
    }
}
