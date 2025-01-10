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
        VStack(spacing:20) {
            HStack(alignment: .lastTextBaseline) {
                ButtonAction(iconSystemName: "chevron.left", iconSize: 30) {
                    goBack()
                }
                
                Spacer()
            }.frame(maxWidth:.infinity)
            
            Text(viewModel.option.title)
                .font(.title)
            
            HStack(spacing:20) {
                
                Button(action:{}){
                    VStack {
                        Image(systemName:"minus")
                            .font(.system(size: 14))
                        
                    }.modifier(ButtonStyle())
                    
                }.buttonStyle(.plain)
                
                
                Text(viewModel.option.value)
                    .font(.title)
                    .fontWeight(.medium)
                
                Button(action:{}){
                    VStack {
                        Image(systemName:"plus")
                            .font(.system(size: 14))
                        
                    }.modifier(ButtonStyle())
                }.buttonStyle(.plain)
            }
            Spacer()
        }.frame(maxWidth: 260,maxHeight: 200)
            .padding(.horizontal,30)
            .padding(.vertical,20)
        
    }
}

struct ButtonStyle: ViewModifier {
    func body(content:Content) -> some View {
        content.frame(height: 32)
            .padding(.horizontal,10)
            .font(Font.system(.title3).bold())
            .background(Color(.darkGray).opacity(0.1))
            .foregroundColor(.white)
            .cornerRadius(5.0)
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(.white).opacity(0.6), lineWidth: 1)
            }
        
    }
}

#Preview {
    
    ChangeSettingsOptionView(goBack:{
        
    },viewModel: ChangeSettingsOptionViewModel(option: .long))
}
