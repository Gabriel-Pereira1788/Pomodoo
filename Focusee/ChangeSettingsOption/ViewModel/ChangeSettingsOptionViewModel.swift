import SwiftUI

class ChangeSettingsOptionViewModel:ObservableObject {
    @Published var option:SettingsOptions
    
    init(option:SettingsOptions){
        self.option = option
    }
    
}
