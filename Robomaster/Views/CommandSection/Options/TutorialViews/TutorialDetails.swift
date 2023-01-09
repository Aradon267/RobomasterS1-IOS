//
//  TutorialDetails.swift
//  Robomaster
//
//  Created by Arad Donenfeld on 08/10/2022.
//

import SwiftUI

/// A view containing all the details about a given tutorial.
struct TutorialDetails: View {
    var tutorial: RobotFunctionTutorial
    var body: some View {
        ScrollView{
            AsyncImage(url: URL(string: tutorial.imgSrc)) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                ProgressView()
            }
            VStack(alignment: .leading){
                Text(tutorial.funcName)
                    .font(.title)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Divider()
                Text(tutorial.funcDescStart + tutorial.funcDescRest)
                    .font(.title2)
                Divider()
                Text(tutorial.funcPara)
            }
        }
    }
}

struct TutorialDetails_Previews: PreviewProvider {
    static var tutorials = LocalData().tutorials

    static var previews: some View {
        TutorialDetails(tutorial: tutorials[0])
    }
}
