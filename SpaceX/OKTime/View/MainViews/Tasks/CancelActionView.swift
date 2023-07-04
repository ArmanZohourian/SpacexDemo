//
//  CancelActionView.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/9/22.
//

import SwiftUI
import ExytePopupView
struct CancelActionView: View {
    
    @AppStorage("language")
    
    private var language = LocalizationService.shared.language
    
    var colors: ConstantColors
    @Binding var isPresented: Bool
    @Binding var task: Book
    @State var isShowingDurationDatePicker = false
    
    
    @State var cancelActionViewModel = CancelActionViewModel()
    
    @EnvironmentObject var todayTaskViewModel : TodayTaskViewModel
    
    @EnvironmentObject var calendarViewModel : CalendarViewModel
    
    @State var startDate = Date()
    @State var endDate = Date()
    
    
    var body: some View {
        
        
        VStack(spacing: 40) {
            VStack(spacing: 20) {
                Image("cancel-action")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 85, height: 85)
                
                Text("cancel_action".localized(language))
                    .foregroundColor(colors.blueColor)
                    .font(.custom("YekanBakhNoEn-Bold", size: 20))
                
            }
            
            Text("cancel_action_dialog".localized(language))
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
                    //End action (send request to server)
                    
                    Task {
                        await cancelActionViewModel.cancelAction(id: task.id)
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
//struct CancelActionView_Previews: PreviewProvider {
//    static var previews: some View {
//        CancelActionView(colors: ConstantColors(), isPresented: .constant(true))
//    }
//}
