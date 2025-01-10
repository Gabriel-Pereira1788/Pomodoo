//
//  ButtonAction.swift
//  Focusee
//
//  Created by Gabriel Pereira on 09/01/25.
//

import SwiftUI
struct ButtonAction:View {
    var action:()->Void
    var iconSystemName:String
    var iconSize:CGFloat = 40
    
    var body: some View {
        Button(action: action, label: {
            ZStack {
                Circle()
                    .stroke(lineWidth: 1)
                    .fill(Color(.darkGray))
                    .frame(width: iconSize, height: iconSize)
                
                Image(systemName:iconSystemName)
                    .font(.system(size: iconSize / 2))
            }
        }).buttonStyle(.plain)
    }
}
