//
//  NavigationItemsView.swift
//  OKTime
//
//  Created by Arman Zohourian on 12/21/22.
//

import SwiftUI

struct NavigationItemsView: View {
    
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    
    var title: String
    
    
    var isBackButtonHidden: Bool
    
    
    var body: some View {
        backButton
    }
    
    var backButton: some View {
        
        HStack {
            
            
            if !isBackButtonHidden {
                Button {
                    self.presentationMode.wrappedValue.dismiss()
                } label: {
                    Image("arrow-square-left")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 35, height: 35)
                }
            }
            
            Text(title)
                .foregroundColor(Color.white)
                .font(.custom("YekanBakhNoEn-Bold", size: 30))
                .padding(.top, 5)

            
        }
        .environment(\.layoutDirection, .leftToRight)
    }
    
}


