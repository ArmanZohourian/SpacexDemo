//
//  StateCellView.swift
//  OKTime
//
//  Created by Arman Zohourian on 10/13/22.
//

import SwiftUI

struct StateCellView: View {
    
    @State var stateName = ""
    @State var value : String = "100"
    @State var color: Color = Color.green
    var body: some View {
        
        VStack(spacing: 5){
            
            Text(stateName)
                .font(.system(size: 8, weight: .light, design: .default))
                .foregroundColor(color)
            Text(value)
                .font(.system(size: 12, weight: .light, design: .default))
        }
        
    }
}

struct StateCellView_Previews: PreviewProvider {
    static var previews: some View {
        StateCellView()
    }
}
