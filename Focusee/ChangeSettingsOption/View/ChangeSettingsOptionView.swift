//
//  ChangeSettingsOptionView.swift
//  Focusee
//
//  Created by Gabriel Pereira on 09/01/25.
//

import SwiftUI

struct ChangeSettingsOptionView: View {
    var goBack:() -> Void
    @ObservedObject var viewModel: ChangeSettingsOptionViewModel
    
    var body: some View {
        VStack {
            HStack(alignment: .lastTextBaseline) {
                ButtonAction(action: goBack, iconSystemName: "chevron.left",iconSize: 35)
                
                Spacer()
            }.frame(maxWidth:.infinity)
            Text("Change Option content")
        }.frame(maxWidth: 260,maxHeight: 200)
            .padding(.horizontal,30)
            .padding(.vertical,20)
        
    }
}

#Preview {
    ChangeSettingsOptionView(goBack:{
        
    },viewModel: ChangeSettingsOptionViewModel())
}
