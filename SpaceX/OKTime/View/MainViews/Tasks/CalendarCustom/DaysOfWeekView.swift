//
//  DaysOfWeekView.swift
//  OKTime
//
//  Created by Arman Zohourian on 10/22/22.
//

import SwiftUI

struct DaysOfWeekView: View {
    
    var days : [String] = ["ش","ی","د","س","چ","پ","ج"]
    var body: some View {
        
        HStack(spacing: 30) {
            Text("ج")
                .foregroundColor(Color.red)
            Text("پ")
            Text("چ")
            Text("س")
            Text("د")
            Text("ی")
            Text("ش")
            
        }
        .frame(width: UIScreen.screenWidth, height: 15)
    }
}

struct DaysOfWeekView_Previews: PreviewProvider {
    
    static var days : [String] = ["د","ی","ش","س","چ","پ","ج"]
    
    static var previews: some View {
        DaysOfWeekView()
    }
}
