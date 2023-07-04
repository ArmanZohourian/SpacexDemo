//
//  DetailCellView.swift
//  SpaceX
//
//  Created by Arman Zohourian on 6/29/23.
//

import SwiftUI

struct DetailCellView<Content: View>: View {
    private let title: String
    private let logoImageName: String
    private let content: Content
    private let isFullWidth: Bool
    private let maxHeight: CGFloat?

    init(title: String, logoImageName: String, isFullWidth: Bool,maxHeight : CGFloat? = nil , @ViewBuilder content: () -> Content) {
        self.title = title
        self.logoImageName = logoImageName
        self.isFullWidth = isFullWidth
        self.maxHeight = maxHeight
        self.content = content()
        
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: logoImageName)
                    .resizable()
                    .frame(width: 15, height: 15)
            
                Text(title)
                    .font(.system(size: 13, weight: .bold, design: .default))
            }
            .foregroundColor(Color.white)
            .padding([.top, .leading])
            
            content
                .padding()
        }
        .frame(maxWidth: isFullWidth ? UIScreen.main.bounds.width : UIScreen.main.bounds.width / 1.5, maxHeight: maxHeight, alignment: .topLeading)
        .background(Color(red: 19 / 255, green: 23 / 255, blue: 26 / 255))
        .cornerRadius(10)
        
    }
}

