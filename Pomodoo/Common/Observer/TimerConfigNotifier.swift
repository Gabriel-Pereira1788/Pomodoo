import Foundation
import SwiftUI
import Combine


protocol TimerConfigObserver:AnyObject {
    func didChangeTimerConfig(_ data:TimerConfig)
}

class TimerConfigNotifier {
    static var instance:TimerConfigNotifier = TimerConfigNotifier()
    
    private var cancellable:AnyCancellable?
    private var dataPublisher = PassthroughSubject<TimerConfig,Never>()
    private var observers:[TimerConfigObserver] = []
    
    private init() {
        cancellable = nil
        setupCancellabe()
    }
    
    
    deinit {
        cancellable?.cancel()
    }
    
    private func setupCancellabe() {
        cancellable = dataPublisher.sink {[unowned self] value in
            
            for observer in self.observers {
                observer.didChangeTimerConfig(value)
            }
        }
    }
    
    func addObserver(_ observer:TimerConfigObserver) {
        observers.append(observer)
    }
    
    func changeValue(_ config:TimerConfig) {
        dataPublisher.send(config)
    }
}

