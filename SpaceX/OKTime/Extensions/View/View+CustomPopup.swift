//
//  View+CustomPopup.swift
//  OKTime
//
//  Created by Arman Zohourian on 1/4/23.
//

import SwiftUI

extension View {
    
    public func customPopupView<Content: View>(horizontalPadding: CGFloat = 40 ,isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) -> some View {
        
        return self.overlay {
            
            if isPresented.wrappedValue {
                GeometryReader { geometry in
                    
                    Color.primary
                        .opacity(0.15)
                        .ignoresSafeArea()
                    
                    VStack {
                        content()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    
                    
                }
                
            }
            
        }
        .transition(.move(edge: .bottom))
        .transaction { transaction in
            transaction.animation = .easeIn(duration: 0.3)
            
        }
        
    }
    
}

