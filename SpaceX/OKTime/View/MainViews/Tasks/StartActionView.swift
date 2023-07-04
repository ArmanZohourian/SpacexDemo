//
//  StartActionView.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/8/22.
//

import SwiftUI

struct StartActionView: View {
    
    @AppStorage("language")
    
    private var language = LocalizationService.shared.language
    
    @Binding var isPresented: Bool
    var colors: ConstantColors
    @Binding var task: Book
    @StateObject var startActionViewModel = StartActionViewModel()
    @EnvironmentObject var todayTaskViewModel : TodayTaskViewModel
    
    @EnvironmentObject var calendarViewModel : CalendarViewModel
    
    var body: some View {
        
        VStack(spacing: 20) {
            VStack(spacing: 20) {
                Image("timer-start-action")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 85, height: 85)
                
                Text("start_action".localized(language))
                    .foregroundColor(colors.blueColor)
                    .font(.custom("YekanBakhNoEn-Bold", size: 20))
                
            }
            
            Text("start_action_dialog".localized(language))
                .foregroundColor(colors.grayColor)
                .font(.custom("YekanBakhNoEn-Regular", size: 16))
            
            HStack(spacing: 5) {

                Button {
                    isPresented = false
                } label: {
                    Text("cancel".localized(language))
                        .foregroundColor(Color.white)
                    
                }
                .frame(width: UIScreen.screenWidth / 2.5, height: 45)
                .background(colors.redColor)
                .cornerRadius(5)
                
                
                Button {
                    //Start action (send request to server)
                    Task {
                        await startActionViewModel.startActionWith(id: task.id)
                        await todayTaskViewModel.getBookings(with: todayTaskViewModel.selectedDate)
                        await calendarViewModel.getCalendarStatus(withDate: todayTaskViewModel.selectedDate)
                    }
                    
                    isPresented = false
                   
                } label: {
                    Text("confirm_end".localized(language))
                        .foregroundColor(Color.white)
                }
                .frame(width: UIScreen.screenWidth / 2.5, height: 45)
                .background(colors.darkGreenColor)
                .cornerRadius(5)
                


            }
            
            
        }
        .frame(width: UIScreen.screenWidth - 40, height: UIScreen.screenHeight / 2.7, alignment: .center)
        .background(
            Color.white
        )
    }
}

//
//struct StartActionView_Previews: PreviewProvider {
//    static var colors: ConstantColors = ConstantColors()
//    static var previews: some View {
//        StartActionView(isPresented: .constant(false), colors: colors, task: .con)
//    }
//}
