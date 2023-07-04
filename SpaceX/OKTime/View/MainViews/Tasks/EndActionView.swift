//
//  EndActionView.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/9/22.
//

import SwiftUI
import ExytePopupView

struct EndActionView: View {
    
    @AppStorage("language")
    
    private var language = LocalizationService.shared.language
    
    
    var colors: ConstantColors
    @Binding var isPresented: Bool
    @State var price = ""
    @State var selectedPayment : String = "cash".localized(LocalizationService.shared.language)
    @Binding var task : Book
    @State var isStartShowingDurationDatePicker = false
    @State var isEndShowingDurationDatePicker = false
    @State var startDate = Date()
    @State var endDate = Date()
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm a"
        return formatter
    }
    
    
    @State var startDateStr : String = ""
    @State var endDateStr : String = ""
    @State var isShowingPaymentPicker = false
    
    
    @StateObject var endActionViewModel = EndActionViewModel()
    
    @EnvironmentObject var todayTaskViewModel : TodayTaskViewModel
    
    @EnvironmentObject var calendarViewModel : CalendarViewModel
    
    @EnvironmentObject var keyboardResponder : KeyboardResponder
    
    @EnvironmentObject var timeViewModel: TimeViewModel
    
    var body: some View {
        
        ScrollView {
            VStack(spacing: 10) {
                
                VStack(spacing: 20) {
                    Image("timer-start-action")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 85, height: 85)
                    
                    Text("end_action".localized(language))
                        .foregroundColor(colors.blueColor)
                        .font(.custom("YekanBakhNoEn-Bold", size: 20))
                    
                }
                .padding(.top)
                
                CustomTextFieldPopUp(colors: colors, labelName: "price".localized(language), placeholder: "20000", text: $price
                                     , isPassword: false)
                .keyboardType(.numberPad)
                .padding()
                
                HStack(spacing: 15) {

                    TimerView(colors: colors, textValue: $endDateStr, isPopup: true, labelText: "end_time".localized(language), logo: "timer-2")
                        .onTapGesture {
                            isEndShowingDurationDatePicker.toggle()
                        }
                        .overlay(alignment: .bottom) {
                            Text("\(endDate, formatter: dateFormatter)")
                                .font(.custom("YekanBakhNoEn-Regular", size: 14))
                                .padding()
                                .onTapGesture {
                                    isEndShowingDurationDatePicker.toggle()
                                    hideKeyboard()
                                }
                        }
                    
                    
                    TimerView(colors: colors, textValue: $startDateStr, isPopup: true, labelText: "start_time".localized(language), logo: "timer-2")
                        .onTapGesture {
                            isStartShowingDurationDatePicker.toggle()
                        }
                        .overlay(alignment: .bottom) {
                            Text("\(startDate, formatter: dateFormatter)")
                                .font(.custom("YekanBakhNoEn-Regular", size: 14))
                                .padding()
                                .onTapGesture {
                                    isStartShowingDurationDatePicker.toggle()
                                    hideKeyboard()
                                }
                        }
                    
                    
                }
                
                
                
                CustomPopupSelectionPicker(colors: colors, options: ["transfer".localized(language),"cash".localized(language)], selectedValue: $selectedPayment , labelText: "payment_type".localized(language))
                    .padding([.leading,.trailing])
                    .onTapGesture {
                        isShowingPaymentPicker.toggle()
                        hideKeyboard()
                    }
                
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
                            await endActionViewModel.endAction(taskId: task.id
                                                                ,price: price ,startTime: startDate ,endTime: endDate ,paymentMethod: selectedPayment)
                            
                            await todayTaskViewModel.getBookings(with: todayTaskViewModel.selectedDate)
                            
                            await calendarViewModel.getCalendarStatus(withDate: todayTaskViewModel.selectedDate)
                            
                            await timeViewModel.getIncomeReports()
                            
                            
                            
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
                .padding()
                
                
            }
            .frame(width: UIScreen.screenWidth - 20)
            .background(
                Color.white
            )
            .padding(.bottom, keyboardResponder.currentHeight / 1.5)
            
        }
        .padding([.top] ,100)
        
        .environment(\.layoutDirection, language == .persian ? .leftToRight : .rightToLeft)
        .overlay(alignment: .bottom, content: {
            if isStartShowingDurationDatePicker {
                
                HourAndMinutePickerView(date: $startDate, isPresented: $isStartShowingDurationDatePicker)
                    .padding(.bottom, -20)
                    
            }

        })
        .overlay(alignment: .bottom, content: {
            if isEndShowingDurationDatePicker {
                
                HourAndMinutePickerView(date: $endDate, isPresented: $isEndShowingDurationDatePicker)
                    .padding(.bottom, -20)
                    
            }
           
        })
        
        .overlay(alignment: .bottom) {
            if isShowingPaymentPicker {
                
                CustomSelectionMenu(isPresented: $isShowingPaymentPicker, selectedValue: $selectedPayment, selectionTitle: "payment_type".localized(language), options: ["cash".localized(language), "transfer".localized(language)])
                    .frame(width: UIScreen.screenWidth)
                    .padding(.bottom, -20)
            }
        }
        
        .onTapGesture {
            hideKeyboard()
            isShowingPaymentPicker = false
            isEndShowingDurationDatePicker = false
            isStartShowingDurationDatePicker = false
        }
            
    
        
    }
    
    
    private func generateDateString(with date: Date) -> String {
    
        let df = DateFormatter()
        df.dateFormat = "HH:mm"
        let convertedDate = df.string(from: date)
        print(convertedDate)
        return convertedDate
    }
    
    
    
}

