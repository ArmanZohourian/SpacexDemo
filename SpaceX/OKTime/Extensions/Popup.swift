//
//  Popup.swift
//  OKTime
//
//  Created by Arman Zohourian on 10/18/22.
//

import SwiftUI


extension View {
    
    func popupStack<Content: View>(horizontalPadding: CGFloat = 40,show: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) -> some View {
        
        
        return self
            .overlay {
                if show.wrappedValue {
                    
                    GeometryReader { proxy in
                        let size = proxy.size
                        
                        VStack {
                             content()
                        }
                        .frame(width: size.width - horizontalPadding, height: size.height / 1.7 , alignment: .center)
                        .cornerRadius(15)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        .offset(y: -100)
                    }
                   
                }
            }
        
    }
    
}
