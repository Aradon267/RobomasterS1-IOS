//
//  ProgramRow.swift
//  Robomaster
//
//  Created by Arad Donenfeld on 08/10/2022.
//

import SwiftUI

/// A view containing how to present a row with a given program's data.
struct ProgramRow: View {
    var program: Program
    var body: some View {
        HStack{
            Text(program.programName)
                .bold()
            Text(program.programDescription)
                .font(.subheadline)
            Text(program.date)
                .foregroundColor(.gray)
                .font(.footnote)
        }
    }
}

struct ProgramRow_Previews: PreviewProvider {
    static var programs = ReadData().listPrograms
    static var previews: some View {
        ProgramRow(program: programs[0])
    }
}
