//
//  VibrateManager.swift
//  MetroSpb
//
//  Created by Ярослав Куприянов on 21.10.2023.
//

import Foundation
import UIKit

struct VibrateManager {
    static let shared = VibrateManager()
    
    private let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
    private let selectionFeedBackGenerator = UISelectionFeedbackGenerator()
    
    func vibrateFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle = .light) {
        let feedbackGenerator = UIImpactFeedbackGenerator(style: style)
        feedbackGenerator.prepare()
        feedbackGenerator.impactOccurred()
    }
    
    func vibrateWhenSuccess() {
        notificationFeedbackGenerator.prepare()
        notificationFeedbackGenerator.notificationOccurred(.success)
    }
    
    func vibrateWhenFailure() {
        notificationFeedbackGenerator.prepare()
        notificationFeedbackGenerator.notificationOccurred(.error)
    }
    
    func vibrateSelection() {
        selectionFeedBackGenerator.prepare()
        selectionFeedBackGenerator.selectionChanged()
    }
}
