//
//  SaveProgramView.swift
//  Robomaster
//
//  Created by Arad Donenfeld on 08/10/2022.
//

import SwiftUI
import AlertToast


/// A view containing the input fields to save a user's program.
struct SaveProgramView: View {
    
    var username: String
    @Environment (\.presentationMode) var presentationMode
    @State var robomaster: RobomasterClass

    @State var progName: String = ""
    @State var progDesc: String = ""
    
    @StateObject
    var writeData = WriteData()
    
    @State var missingArgs: Bool = false
    @State var queueEmpty: Bool = false
    
    @Binding var selection: CommandHost.Tab
    var body: some View {
            //
            //
        List{
            HStack{
                Text("Program name").bold()
                Divider()
                TextField("Program name", text: $progName)
                .autocapitalization(.none)
                .disableAutocorrection(true)
            }
            VStack{
                Text("Description").bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                TextField("Description", text: $progDesc)
                .autocapitalization(.none)
                .disableAutocorrection(true)
            }
            Button{
                if progDesc.isEmpty || progName.isEmpty{
                    self.missingArgs = true
                }
                else if (self.robomaster.getQ().head == nil){
                    self.queueEmpty = true
                }
                else{
                    saveProgram(progName: progName, progDesc: progDesc)
                    self.selection = CommandHost.Tab.commandEditor
                    self.presentationMode.wrappedValue.dismiss()
                }
            } label: {
                Text("Save Program")
            }.frame(maxWidth: .infinity, alignment: .center)
        }
        .toast(isPresenting: $missingArgs, alert: {
            AlertToast(type: .error(.red), title: "Missing arguments")
        })
        .toast(isPresenting: $queueEmpty, alert: {
            AlertToast(type: .error(.red), title: "The program is empty")
        })
    }
    
    /// The function will save a program to the Firebase.
    /// - Parameters:
    ///   - progName: The name of the program to save.
    ///   - progDesc: A description of the program to save.
    public func saveProgram(progName: String, progDesc: String){
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let currDate: String = formatter.string(from: date)
        var dis = [String]()
        var commands = [String]()
        for displayCom in self.robomaster.getArr(){
            dis.append(displayCom.command)
        }
        var commandQueue: Queue<String> = self.robomaster.getQ()
        while(!commandQueue.isEmpty()){
            commands.append(commandQueue.dequeue()!)
        }
        
        let newProgram: Program = Program(program: commands, programDisplay: dis, username: self.username, programName: progName, programDescription: progDesc, date: currDate, progid: "-1")
        
        writeData.writeNewProgram(programData: newProgram)
    }
}



struct SaveProgramView_Previews: PreviewProvider {
    @State static var selection: CommandHost.Tab = CommandHost.Tab.options
    static var previews: some View {
        SaveProgramView(username: "a", robomaster: RobomasterClass(ip: "8.7.6.5", port: "12346"), selection: $selection)
    }
}
