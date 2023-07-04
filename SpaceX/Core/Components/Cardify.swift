//
//  CardView.swift
//  SpaceX
//
//  Created by Arman Zohourian on 6/28/23.
//

import SwiftUI

struct Cardify<Content: View>: View {
    
    let content: Content
    
    init(@ViewBuilder content: () -> Content ) {
        self.content = content()
        
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                content
                    .scaledToFill()
            }
        }
        .frame(height: 100)
        .background(Color(red: 19 / 255, green: 23 / 255, blue: 26 / 255))
        .cornerRadius(10)
        .padding([.leading, .trailing])
    }
}
