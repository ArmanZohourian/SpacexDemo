//
//  FloatBottomView.swift
//  OKTime
//
//  Created by Arman Zohourian on 12/17/22.
//

import SwiftUI

struct FloatBottomView: View {
    
    var colors: Color
    
    var errorMessage: String
    
    var body: some View {
        HStack(spacing: 8) {
            
            
            Text(errorMessage)
                .foregroundColor(.white)
                .font(.system(size: 12))
                .environment(\.layoutDirection, LocalizationService.shared.language == .persian ? .rightToLeft : .leftToRight)
            
            
            Image(systemName: "exclamationmark.circle.fill")
                .foregroundColor(.white)
                .frame(width: 24, height: 24)
        }
        
        .padding(.vertical, 20)
        .padding(.horizontal, 20)
        .background(colors)
        .cornerRadius(20, corners: [.allCorners])
        
    }
}

