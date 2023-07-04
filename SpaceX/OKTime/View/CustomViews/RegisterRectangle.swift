//
//  RegisterRectangle.swift
//  OKTime
//
//  Created by Arman Zohourian on 10/17/22.
//

import SwiftUI

struct RegisterRectangle: View {
    
    @State var headtitle : String = ""
    @State var subtitle : String = ""
    @State var playgroundImage : String = ""
    var colors: ConstantColors
    
    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .foregroundColor(colors.blueColor)
                    .ignoresSafeArea()
                VStack(alignment: .trailing ,spacing: 30) {
                    //Text Stack
                    VStack(alignment: .trailing, spacing: 10) {
                        Text(headtitle)
                            .font(.system(size: 26))
                        Text(subtitle)
                            .font(.system(size: 16))
                    }
                    .foregroundColor(Color.white)
                    
                    Image(playgroundImage)
                    
                }
                .offset(y: -20)
                
            }
            .frame(height: 218)
            .cornerRadius(5)
            
            
        }
    }
}

struct RegisterRectangle_Previews: PreviewProvider {
    static var previews: some View {
        RegisterRectangle(colors: ConstantColors())
    }
}
