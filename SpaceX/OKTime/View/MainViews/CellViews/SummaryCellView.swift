//
//  SummaryCellView.swift
//  OKTime
//
//  Created by Arman Zohourian on 10/13/22.
//

import SwiftUI

struct SummaryCellView: View {
    
    @State var progressPrecent = 80
    @State var stateText = ""
    @State var statePercentText = ""
    @State var color : Color = Color.green
    @State var progressRate: Float = 0.0
    
    var body: some View {
        VStack {
            
            HStack(spacing: -20) {
                
                //Load circle
                CustomProgressView(progress: self.$progressRate , color: color)
                    .frame(width: 25, height: 25)
                    .onAppear {
                        progressRate = 0.8
                    }
                    .offset(x:10 ,y: -15)
                    .padding()
                Spacer()
                VStack(alignment: .trailing , spacing: 5) {
                    Text("%:\(progressPrecent)")
                        .foregroundColor(color)
                    Text(stateText)
                        .font(.system(size: 17, weight: .regular, design: .default))
                    Text(statePercentText)
                        .font(.system(size: 12, weight: .light, design: .default))
                        .foregroundColor(Color.gray)
                }
                .padding()
            }
            .frame(width: 180, height: 80)
            .background(Color.white)
            .padding(-20)

        }
    }
}

struct SummaryCellView_Previews: PreviewProvider {
    static var previews: some View {
        SummaryCellView()
    }
}
