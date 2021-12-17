//
//  KeyboardObserving.swift
//
//  Created by Nicholas Fox on 10/4/19.
//

import Foundation
import SwiftUI
import UIKit

@available(iOS 13.0, *)
struct KeyboardObserving: ViewModifier {
    var offset: CGFloat
    @State var keyboardHeight: CGFloat = 0
    @State var keyboardAnimationDuration: Double = 0

    func body(content: Content) -> some View {
        content
            .padding([.bottom], self.keyboardHeight)
            .edgesIgnoringSafeArea((self.keyboardHeight > 0) ? [.bottom] : [])
            .animation(.easeOut(duration: self.keyboardAnimationDuration))
            .onReceive(
                NotificationCenter.default.publisher(for: UIResponder.keyboardWillChangeFrameNotification)
                    .receive(on: RunLoop.main),
                perform: self.updateKeyboardHeight
            )
    }

    func updateKeyboardHeight(_ notification: Notification) {
        guard let info = notification.userInfo else { return }
        // Get the duration of the keyboard animation
        self.keyboardAnimationDuration = (info[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double)
            ?? 0.25

        guard let keyboardFrame = info[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        // If the top of the frame is at the bottom of the screen, set the height to 0.
        if keyboardFrame.origin.y == UIScreen.main.bounds.height {
            self.keyboardHeight = 0
        } else {
            // IMPORTANT: This height will _include_ the SafeAreaInset height.
            self.keyboardHeight = keyboardFrame.height + self.offset
        }
    }
}
