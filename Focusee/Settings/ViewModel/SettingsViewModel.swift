//
//  SettingsViewModel.swift
//  Focusee
//
//  Created by Gabriel Pereira on 09/01/25.
//

import SwiftUI

class SettingsViewModel:ObservableObject {
        
    @Published var uiState:SettingsUIState = .settings
    
    func changeUIState(to state:SettingsUIState) {
        uiState = state
    }
    
    func renderChangeSettingsOption() -> some View {
        return ChangeSettingsOptionView(goBack:{
            self.changeUIState(to: .settings)
            print("EXECUTE")
        },viewModel: ChangeSettingsOptionViewModel())
    }
}
