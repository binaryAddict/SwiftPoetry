//
//  DisplayLinkController.swift
//  SwiftPoetry
//
//  Created by Dominic Campbell on 21/10/2024.
//

import Foundation
import SwiftUI
import Combine

struct DisplayLinkUpdate: Hashable {
    let duration: TimeInterval
}

@objc class DisplayLinkController: NSObject {
    
    // CADisplayLink retains the target which is DisplayLinkController
    private(set) unowned var displayLink: CADisplayLink!
    let update = PassthroughSubject<DisplayLinkUpdate, Never>()
    var paused: Bool {
        get {  
            displayLink.isPaused
        }
        set {
            displayLink.isPaused = newValue
        }
    }
    
    init(paused: Bool = false) {
        super.init()
#if os(macOS)
        let displayLink = NSScreen.main!.displayLink(target: self, selector:  #selector(DisplayLinkController._update))
#else
        let displayLink = CADisplayLink(target: self, selector: #selector(DisplayLinkController._update))
#endif
        displayLink.isPaused = paused
        displayLink.add(to: .main, forMode: .default)
        self.displayLink = displayLink
    }
    
    @objc private func _update() {
        update.send(DisplayLinkUpdate(duration: displayLink.duration))
    }
    
    deinit {
        displayLink.invalidate()
    }
}
