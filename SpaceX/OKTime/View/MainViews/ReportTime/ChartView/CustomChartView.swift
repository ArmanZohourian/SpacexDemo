//
//  CustomChartView.swift
//  OKTime
//
//  Created by Arman Zohourian on 10/19/22.
//

import SwiftUI
import SwiftUICharts
struct CustomChartView: View {
    
    @AppStorage("language")
    
    private var language = LocalizationService.shared.language
    
    var colors: ConstantColors
    var body: some View {
        
        
        VStack {
            
            
            VStack {

                
//                DSFSparklineBarGraphView.SwiftUI(dataSource: , graphColor: .blue, showZeroLine: true, lineWidth: 2,barSpacing: 1)
            //form: CGSize(width: UIScreen.screenWidth - 20 , height: 150)
                
                ZStack {
                    MultiLineChartView(data: [([8,32,50,40,60,70], GradientColors.green), ([1,20,10,40,20,70,100], GradientColors.purple)], title: "", form: CGSize(width: UIScreen.screenWidth - 20 , height: 200), dropShadow: false)
                        .cornerRadius(-10)
                        
                    HStack(spacing: -100) {
                        
                        VStack(spacing: 5) {
                            
                            HStack {
                                Text("follow_counts".localized(language))
                                    .foregroundColor(colors.tirratyColor)
                                    .font(.system(size: 13))
                                Rectangle()
                                    .foregroundColor(colors.blueColor)
                                    .frame(width: 7, height: 7)
                                    .cornerRadius(2)
                            }
                            
                            HStack {
                                Text("unfollow_counts".localized(language))
                                    .foregroundColor(colors.tirratyColor)
                                    .font(.system(size: 13))
                                Rectangle()
                                    .frame(width: 7, height: 7)
                                    .foregroundColor(colors.greenColor)
                                    .cornerRadius(2)
                            }
                            
                        }
                        Spacer()
                        Text("overall_reports".localized(language))
                            .foregroundColor(colors.blueColor)
                            .offset(y: -10)
                    }
                    .padding(35)
                    .offset(y: -80)

                }
                .padding(-10)
                

            }
            
            

            
        }
        
    }
}

struct CustomChartView_Previews: PreviewProvider {
    
    static var constantColors  = ConstantColors()
    
    static var previews: some View {
        CustomChartView(colors: constantColors)
    }
}
