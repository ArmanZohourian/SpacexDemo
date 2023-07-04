//
//  KeyboardResponder.swift
//  OKTime
//
//  Created by Arman Zohourian on 10/11/22.
//

import SwiftUI
import Foundation


//1. Create a class for updating the observing views when the keyboard gets toggled
class KeyboardResponder: ObservableObject {
    
    //2. Keeping track off the keyboard's current height
    @Published var currentHeight: CGFloat = 0
    
    @Published var isKeyboardVisible = false
    
    //3. We use the NotificationCenter to listen to system notifications
    var _center: NotificationCenter
    
    init(center: NotificationCenter = .default) {
        _center = center
        //4. Tell the notification center to listen to the system keyboardWillShow and keyboardWillHide notification
        _center.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        _center.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //5.1. Update the currentHeight variable when the keyboards gets toggled
    @objc func keyBoardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            withAnimation {
                DispatchQueue.main.async { [weak self] in
                    self?.currentHeight = keyboardSize.height
                    self?.isKeyboardVisible = true
                }
            }

        }
    }

    //5.2 Update the currentHeight variable when the keyboards collapses
    @objc func keyBoardWillHide(notification: Notification) {
        withAnimation {
           currentHeight = 0
            isKeyboardVisible = false
        }
    }
}



