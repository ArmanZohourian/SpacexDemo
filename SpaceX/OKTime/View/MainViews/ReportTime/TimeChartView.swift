//
//  TimeChartView.swift
//  OKTime
//
//  Created by Arman Zohourian on 10/20/22.
//

import SwiftUI
import SwiftUICharts
struct TimeChartView: View {
    
    var colors: ConstantColors
    
    var language = LocalizationService.shared.language
    
    var body: some View {
        
        ZStack {
            LineChartView(data: [10,5,22,10,55,29,59,39,49,59,69], title: "", form: CGSize(width: UIScreen.screenWidth - 25, height: 150) , dropShadow: false)
                .overlay(alignment: .topTrailing) {
                    Text("weekly_income_chart".localized(language))
                        .padding()
                        .foregroundColor(colors.blueColor)
                }
        }
 
    }
}

struct TimeChartView_Previews: PreviewProvider {
    static var colors = ConstantColors()
    static var previews: some View {
        TimeChartView(colors: colors)
    }
}
