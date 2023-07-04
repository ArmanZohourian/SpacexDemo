//
//  TabBarView.swift
//  Spotify Clone
//
//  Created by Arman Zohourian on 4/23/22.
//

import SwiftUI



struct TabBarView: View {
    
    var image: String
    @Binding var selectedTab: String
    var body: some View {
        
        Button {
            withAnimation {
                selectedTab = image
            }
            
        } label: {
            Image(image)
                .font(.title)
                .foregroundColor(selectedTab == image ? Color.purple : Color.white)
                .frame(maxHeight: .infinity)
        }

    }
    
    
}

