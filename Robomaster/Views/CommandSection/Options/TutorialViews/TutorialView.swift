//
//  TutorialView.swift
//  Robomaster
//
//  Created by Arad Donenfeld on 08/10/2022.
//

import SwiftUI

/// A view containing a list of all tutorials and redirects the user to each tutorial.
struct TutorialView: View {
    @StateObject private var localData = LocalData()
    
    @Environment (\.presentationMode) var presentationMode

    var body: some View {
        NavigationView{
            List{
                ForEach(localData.tutorials) { tutorial in
                    NavigationLink{
                        TutorialDetails(tutorial: tutorial)
                    } label: {
                        TutorialRow(tutorial: tutorial)
                    }
                }
            }
            .navigationTitle("Tutorials")
            .toolbar(content: {
                ToolbarItem(placement: ToolbarItemPlacement.navigationBarLeading) {
                    Button{
                        self.presentationMode.wrappedValue.dismiss()
                    }label: {
                        Label("Back", systemImage: "chevron.left")
                    }
                }
            })
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct TutorialView_Previews: PreviewProvider {
    static var previews: some View {
        TutorialView()
    }
}
