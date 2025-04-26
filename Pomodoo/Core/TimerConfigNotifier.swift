import Foundation
import SwiftUI
import Combine


protocol TimerConfigObserver:AnyObject {
    func didChangeTimerConfig(_ data:TimerConfig)
}

protocol TimerConfigNotifierProtocol {
    static var shared:TimerConfigNotifier { get }
    func addObserver(_ observer:TimerConfigObserver)
    func changeValue(_ config:TimerConfig)
}

class TimerConfigNotifier:TimerConfigNotifierProtocol {
    static var shared = TimerConfigNotifier()
    
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

