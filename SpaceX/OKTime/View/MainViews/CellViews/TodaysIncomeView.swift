//
//  TodaysIncomeView.swift
//  OKTime
//
//  Created by Arman Zohourian on 10/13/22.
//

import SwiftUI

struct TodaysIncomeView: View {
    
    
    @AppStorage("language")
    
    private var language = LocalizationService.shared.language
    
    var cancelCount: String = ""
    var doneCount: String = ""
    var queueCount: String = ""
    var dayIncome: String = ""
    var colors: ConstantColors
    
    
    var body: some View {
        
        VStack {
            HStack {
                HStack {
                    
                    


                    VStack(spacing: 5){
                        
                        Text("in_queue".localized(language))
                            .font(.system(size: 12, weight: .light, design: .default))
                            .foregroundColor(colors.inQueueCountColor)
                            
                        Text(queueCount)
                            .font(.system(size: 12, weight: .light, design: .default))
                    }
                    Divider()
                    
                    VStack(spacing: 5){
                        
                        Text("done".localized(language))
                            .font(.system(size: 12, weight: .light, design: .default))
                            .foregroundColor(colors.doneCountColor)
                            
                        Text(doneCount)
                            .font(.system(size: 12, weight: .light, design: .default))
                    }
                    
                    Divider()
                    
                    VStack(spacing: 5){
                        
                        Text("canceled".localized(language))
                            .font(.system(size: 12, weight: .light, design: .default))
                            .foregroundColor(colors.cancelCountColor)
                        
                            
                        Text(cancelCount)
                            .font(.system(size: 12, weight: .light, design: .default))
                    }
                    
//
//                    StateCellView(stateName: "در انتظار", value: queueCount, color: Color( red: 78 / 255, green: 213 / 255 , blue: 242 / 255, opacity: 1))
//
//                    Divider()
//                        .frame(height: 70)
//                    StateCellView(stateName: "انجام شده", value: doneCount, color: Color( red: 0 / 255, green: 223 / 255 , blue: 150 / 255, opacity: 1))
//
//                    Divider()
//                        .frame(height: 70)
//                    StateCellView(stateName: "لغو شده", value: queueCount, color: Color( red: 239 / 255, green: 70 / 255 , blue: 73 / 255, opacity: 1))
//                    Divider()
//                        .frame(height: 70)
                    
                }
                Spacer()
                HStack {
                    
                    VStack(alignment: .trailing) {
                        Text(dayIncome)
                            .font(.system(size: 15, weight: .semibold, design: .default))
                        Text("today_toman_income".localized(language))
                            .font(.system(size: 13, weight: .thin, design: .default))
                    }
                    
                    Image("wallet-money")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .aspectRatio(contentMode: .fit)
                }
            }
            .padding()

            
        }
        .frame(height: 70)
        .background(Color(red: 250 / 255, green: 251 / 255, blue: 251 / 255))
        .cornerRadius(7)
        
    }
}

//struct TodaysIncomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        TodaysIncomeView()
//    }
//}
