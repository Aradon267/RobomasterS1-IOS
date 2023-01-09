//
//  TutorialRow.swift
//  Robomaster
//
//  Created by Arad Donenfeld on 08/10/2022.
//

import SwiftUI

/// A view containing how to present a row with a given tutorial's data.
struct TutorialRow: View {
    var tutorial: RobotFunctionTutorial
    var body: some View {
        HStack{
            AsyncImage(url: URL(string: tutorial.imgSrc)) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 50, height: 50)
            .cornerRadius(20)
            
            Text(tutorial.funcName)
                .bold()
            Divider()
            Text(tutorial.funcDescStart)
        }
    }
}

struct TutorialRow_Previews: PreviewProvider {
    static var tutorials = LocalData().tutorials

    static var previews: some View {
        TutorialRow(tutorial: tutorials[0])
    }
}
