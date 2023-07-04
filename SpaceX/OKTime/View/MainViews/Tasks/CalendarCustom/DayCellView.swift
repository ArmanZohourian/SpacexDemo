//
//  DayCellView.swift
//  OKTime
//
//  Created by Arman Zohourian on 10/22/22.
//

import SwiftUI

struct DayCellView: View {
    
    @State var dayNumber = "01"
    
    var body: some View {
        
        ZStack {
            Rectangle()
                .frame(width: 56, height: 68, alignment: .center)
                .opacity(0.15)
            VStack {
                Text("01")
                    .foregroundColor(Color.white)
                    .padding(.bottom,40)
//                Spacer()
//                Text("")
            }
        }
        .frame(width: 56, height: 68, alignment: .center)
        
        
    }
}

struct DayCellView_Previews: PreviewProvider {
    static var previews: some View {
        DayCellView()
    }
}
