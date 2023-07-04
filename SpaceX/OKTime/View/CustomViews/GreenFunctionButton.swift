//
//  GreenFunctionButton.swift
//  OKTime
//
//  Created by Arman Zohourian on 10/17/22.
//

import SwiftUI

struct GreenFunctionButton: View {
    
    
    @State var buttonText : String = ""
    
    @Binding var isAnimated: Bool
    
//    var language = LocalizationService.shared.language
    
    @AppStorage("language", store: .standard) var language = "en"
    
    var body: some View {
        
        VStack {
            ZStack {
                Rectangle()
                    .foregroundColor(Color(red: 0  / 255 , green: 255 / 255, blue: 171 / 255))
                
                
                Text(buttonText)
                    .font(.custom("YekanBakhNoEn-Regular", size: 16))
                    .foregroundColor(Color(red: 14 / 255 , green: 31 / 255, blue: 80 / 255))
                    .opacity(isAnimated ? 0.0 : 1.0)
                
                
            }
        }
        .overlay(alignment: .top) {
            SpinnerView()
                .opacity(isAnimated ? 1.0 : 0.0)
                .padding(.all, 10)
                
        }
        .cornerRadius(8)
    }
}

//struct GreenFunctionButton_Previews: PreviewProvider {
//    static var previews: some View {
//        GreenFunctionButton()
//    }
//}
