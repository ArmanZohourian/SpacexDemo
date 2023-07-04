//
//  NewShiftView.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/15/22.
//

import SwiftUI
import ExytePopupView

struct NewShiftView: View {
    
    
    @AppStorage("language")
    
    private var language = LocalizationService.shared.language
    
    @EnvironmentObject var getShiftViewModel: GetShiftViewModel
    
    @EnvironmentObject var addDailyShiftViewModel: AddDailyShiftViewModel
    
    @EnvironmentObject var keyboardResponder: KeyboardResponder
    
    
    @State var daysOfWeek: [String] = [
        "saturday".localized(LocalizationService.shared.language),
        "sunday".localized(LocalizationService.shared.language),
        "monday".localized(LocalizationService.shared.language),
        "tuesday".localized(LocalizationService.shared.language),
        "wednesday".localized(LocalizationService.shared.language),
        "thursday".localized(LocalizationService.shared.language),
        "firday".localized(LocalizationService.shared.language)]
    
    
    @State var selectedDays = [String]() {
        didSet {
            print(selectedDays)
        }
    }
    
    private var dayWeekFa: String {
        JalaliHelper.DayWeekFa.string(from: Date())
        
    }
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm a"
        return formatter
    }
    
    var durationTimeFormat: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }
    
    
    @Binding var isPresneted : Bool
    
    var colors: ConstantColors
    
    @State var shiftTitle = ""
    
    @State var shiftDurationStr = ""
    
    @State var shiftDuration = Date()
    
    @State var startTime = Date()
    
    @State var endTime = Date()
    
    @State var startTimeStr = ""
    

    @State var endTimeStr = ""
    @State var isShowingStartDatePicker = false
    @State var isShwoingEndDatePicker = false
    @State var isShowingDurationDatePicker = false
    @Binding var isPresented : Bool
    var body: some View {
        
        ActionSheetView {
            ScrollView {
                VStack(alignment: .trailing ,spacing: 10) {
                    

                        
                    Text("shift_detail_days_label".localized(language))
                    
                    
                    //Weekdays selection View
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(daysOfWeek, id:\.self) { day in
                                
                                Rectangle()
                                    .frame(width: 60, height: 60)
                                    .foregroundColor(isSelectedDay(with: day) ? colors.lightBlueColor : Color.white)
                                    .cornerRadius(5)
                                    .overlay(
                                        Text(day)
                                            .font(.system(size: 10))
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 5)
                                            .stroke(colors.blueColor, lineWidth: 1)
                                    )
                                
                                    .onTapGesture {
                                        selectDay(with: day)
                                        print(isSelectedDay(with: day))
                                    }

                                

                                    .foregroundColor(Color.black)
                            }
                        }
                    }
                    
                    
                    CustomTextField(colors: colors, labelName: "shift_detail_shift_label".localized(language), placeholder: "shift_detail_shift_placeholder".localized(language), text: $shiftTitle, isPassword: false)
                    
                    CustomTextField(colors: colors, labelName: "shift_detail_shift_duration_label".localized(language), placeholder: "", text: $shiftDurationStr, isPassword: false)
                        .disabled(true)
                    
                        .onTapGesture {
                            isShowingDurationDatePicker = true
                        }
                        
                        .overlay(alignment: .bottomTrailing) {
                            HStack {

                                Text("\(shiftDuration, formatter: durationTimeFormat)")
                                    .font(.custom("YekanBakhNoEn-Regular", size: 14))
                                    .padding()
                                    .onTapGesture {
                                        isShowingDurationDatePicker = true
                                        hideKeyboard()
                                    }
                                
                                Image("clock-standby")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .aspectRatio(contentMode: .fit)
                            }
                            .padding(.trailing)
                        }
                    
                    
                    HStack(spacing: 5) {
                        
                        TimerView(colors: colors, textValue: $startTimeStr , labelText: "shift_detail_shift_end_time".localized(language), logo: "clock-standby")
                            .onTapGesture {
                                isShwoingEndDatePicker = true
                            }
                            .overlay(alignment: .bottom) {
                                Text("\(endTime, formatter: dateFormatter)")
                                    .font(.custom("YekanBakhNoEn-Regular", size: 14))
                                    .padding()
                                    .onTapGesture {
                                        isShwoingEndDatePicker = true
                                        hideKeyboard()
                                    }
                            }
                        
                        
                        Spacer()
                        
                        TimerView(colors: colors, textValue: $endTimeStr, labelText: "shift_detail_shift_start_time".localized(language), logo: "clock-standby")
                            .onTapGesture {
                                isShowingStartDatePicker = true
                            }
                        
                            .overlay(alignment: .bottom) {
                                Text("\(startTime, formatter: dateFormatter)")
                                    .font(.custom("YekanBakhNoEn-Regular", size: 14))
                                    .padding()
                                    .onTapGesture {
                                        hideKeyboard()
                                        isShowingStartDatePicker = true
                                    }
                            }
                        
                    }
                    
                    
                    Button {
                        Task {
                            await addDailyShiftViewModel.addNewShift(startDate: startTime.getFormattedDate(format: "HH:mm:ss"), endDate: endTime.getFormattedDate(format: "HH:mm:ss"), shiftDuration: shiftDuration.getFormattedDate(format: "HH:mm:ss"), shiftTitle: shiftTitle, days: selectedDays, completionHandler: {isSuccesfull in
                                if isSuccesfull {
                                    isPresented.toggle()
                                }
                            })
                            
                            await addDailyShiftViewModel.getShiftDetails()
                        
                                
                        }
                    } label: {
                        GreenFunctionButton(buttonText: "shift_detail_register_shift".localized(language), isAnimated: $addDailyShiftViewModel.isRequesting)
                            .frame(width: UIScreen.screenWidth - 20 , height: 45)
                    }

                    
                    

                                
                        } 
                .padding()
                    
                }
            
            
            .popup(isPresented: $addDailyShiftViewModel.hasError, view: {
                FloatBottomView(colors: colors.redColor, errorMessage: addDailyShiftViewModel.errorMessage)
                
            }, customize: {
                $0
                    .animation(.spring())
                    .position(.bottom)
                    .autohideIn(5)
                    .type(.floater())
            })
            
            
        }
        
        

            
            .onTapGesture {
                hideKeyboard()
            }
        
        
        
            .overlay(alignment: .bottom, content: {

                if isShowingDurationDatePicker {
                    HourAndMinutePickerView(date: $shiftDuration, isPresented: $isShowingDurationDatePicker)
                        .environment(\.locale, .init(identifier: "en_GB"))
                }
            })

        
            .overlay(alignment: .bottom, content: {
    
                if isShowingStartDatePicker {
                    HourAndMinutePickerView(date: $startTime, isPresented: $isShowingStartDatePicker)

                }

        })
        
            .overlay(alignment: .bottom) {
                
                if isShwoingEndDatePicker {
                    HourAndMinutePickerView(date: $endTime, isPresented: $isShwoingEndDatePicker)

                }

            }
        
    }
    
    
    //MARK: Functions
    
    private func isSelectedDay(with day: String) -> Bool {
        
        if selectedDays.contains(where: { selectedDay in
            selectedDay == day
        }) {
            return true
        } else {
            return false
        }
        
    }
    
    private func selectDay(with day: String) {
        
        if selectedDays.contains(where: { selectedDay in
            selectedDay == day
        }) {
            //Do remove from list
            selectedDays.removeAll { selectedDay in
                selectedDay == day
            }
        } else {
            selectedDays.append(day)
        }
    }
    
}
//
//struct NewShiftView_Previews: PreviewProvider {
//    static var previews: some View {
//        NewShiftView( colors: ConstantColors())
//    }
//}
