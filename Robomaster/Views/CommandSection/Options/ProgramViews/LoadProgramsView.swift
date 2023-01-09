//
//  LoadProgramsView.swift
//  Robomaster
//
//  Created by Arad Donenfeld on 08/10/2022.
//

import SwiftUI

/// A view containing all of the saved programs data.
struct LoadProgramsView: View {
    
    var username: String
    @State var robomaster: RobomasterClass
    @Binding var selection: CommandHost.Tab
    
    @StateObject
    var readData = ReadData()
    
    @StateObject
    var writeData = WriteData()
    
    var filteredPrograms: [Program]{
        readData.listPrograms.filter{ program in (program.username == username)}
    }
    
    var body: some View {
        VStack {
            Text("Select a program").bold()
            List{
                ForEach(filteredPrograms, id: \.progid){program in
                    Button{
                        loadProgram(programData: program)
                        self.selection = CommandHost.Tab.commandEditor
                    } label: {
                        ProgramRow(program: program)
                    }
                }
                .onDelete(perform: delete)
            }
            .onAppear{
                readData.observerListPrograms()
            }
        }
    }
    
    /// The function will handle deletion of programs from array and Firebase.
    /// - Parameter offsets: The index of the Program to delete.
    func delete(at offsets: IndexSet){
        writeData.removeProgram(programData: filteredPrograms[offsets[offsets.startIndex]])
        self.readData.listPrograms.remove(atOffsets: offsets)
    }
    
    /// The function will load a selected program to the Robomaster.
    /// - Parameter programData: The program to load.
    func loadProgram(programData: Program){
        self.robomaster.clearArr()
        self.robomaster.clearQueue()
        for dis in programData.programDisplay{
            self.robomaster.addToArr(message: dis)
        }
        for commandData in programData.program{
            self.robomaster.addToMessagesQueue(message: commandData)
        }
    }
}

struct LoadProgramsView_Previews: PreviewProvider {
    @State static var selection: CommandHost.Tab = CommandHost.Tab.options

    static var previews: some View {
        LoadProgramsView(username: "a", robomaster: RobomasterClass(ip: "8.7.6.5", port: "12346"), selection: $selection)
    }
}
