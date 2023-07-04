//
//  HomeView.swift
//  OKTime
//
//  Created by Arman Zohourian on 10/13/22.
//

import SwiftUI
import Foundation

struct HomeView: View {
    
    @AppStorage("language")
    
    private var language = LocalizationService.shared.language
    
    @State var isSecure : Bool = false
    
    @State var isPresented : Bool = false
    
    var colors: ConstantColors
    
    //EnvironmentObject
    @EnvironmentObject var timeViewModel: TimeViewModel
    
    @State var isHamburgerPresnted = false
    
    @EnvironmentObject var keyboardResponder : KeyboardResponder
    
    @EnvironmentObject var baseViewModel: BaseViewModel
    
    @EnvironmentObject var profileCellViewModel: ProfileCellViewModel
    
    var body: some View {
        VStack(spacing: 5) {
            

            VStack {
                
                
                ProfileCellView(isPresented: $isHamburgerPresnted)
                    .environmentObject(profileCellViewModel)
                    .environment(\.layoutDirection, .leftToRight)

                    .padding(.top, 20)
                
                
                CalendarShrinkView(colors: colors)
                    .environment(\.calendar, .persianCalendar)
                    .disabled(true)
                    .frame(width: UIScreen.screenWidth, height: 100)
            }
            .frame(width: UIScreen.screenWidth)
            .frame(height: UIScreen.screenHeight / 3.8)
            .background(colors.blueColor)
            .cornerRadius(15, corners: [.bottomLeft , .bottomRight])
            
            
            ScrollView(showsIndicators: false) {
                
                AccountPreview(colors: colors, income: String((timeViewModel.incomeReport?.income) ?? 0) ?? "چیزی برای نمایش وجود ندارد", totalIncome: String((timeViewModel.incomeReport?.totalIncome) ?? 0) ?? "چیزی برای نمایش وجود ندارد")
                    .padding()
                    .background(colors.backgroundColor)
                
                
                
                HStack(spacing: 10) {
                    
                    Spacer()
                    
                    SummaryCellView(progressPrecent: calculateDoneCount(), stateText: "canceled_percentage".localized(language), statePercentText: "weekly_canceled_percentage".localized(language), color: colors.redColor)
                        .background(colors.backgroundColor)
                        
                    Spacer()
                    SummaryCellView(progressPrecent: calculateDoneCount(), stateText: "done_percentage".localized(language), statePercentText: "weekly_done_percentage".localized(language), color: colors.darkGreenColor)
                        .background(colors.backgroundColor)
                        
                    Spacer()
                }
                .frame(width: 400, height: 99)
                
                //Chart Stack
                CustomChartView(colors: colors)
                    .offset(y: 5)
                    
                
                
            }
            .frame(width: UIScreen.screenWidth)

                
        }
        .task {
            await timeViewModel.getIncomeReports()
            await timeViewModel.getCalendarStatus()
        }

        .background(Color.white)
        .ignoresSafeArea()
        .fullScreenCover(isPresented: $isHamburgerPresnted) {
            MenuHumbergerView(isPresneted: $isHamburgerPresnted, colors: colors)
                .environmentObject(profileCellViewModel)
                .environmentObject(keyboardResponder)
                .environmentObject(baseViewModel)
        }
    }
    
    
    private func calculateDoneCount() -> Int {
        
        var doneCount = 0
        
        for day in timeViewModel.statusReports {
            
            doneCount += day.totalCost
        }
    
        return doneCount
    
    }

}

struct HomeView_Previews: PreviewProvider {
    
    static let constantColor = ConstantColors()
    
    static var previews: some View {
        HomeView(colors: constantColor)
    }
}
