//
//  SummeryCellView.swift
//  OKTime
//
//  Created by Arman Zohourian on 1/2/23.
//

import SwiftUI

struct summaryCellView: View {
    
    
    var logo: String
    var name: String
    var value: String
    
    
    var body: some View {
        
        VStack(spacing: 10) {
            Image(logo)
                .resizable()
                .frame(width: 25, height: 25)
                .padding(.top)
                
                
            Text(name)
                .font(.custom("YekanBakhNoEn-Regular", size: 12))
                .allowsTightening(true)
                
                
            Text(value)
                .font(.system(size: 13))
                
                
            
        }
        
        .frame(width: 100, height: 100 , alignment: .center)
        
        
        
    }
}
