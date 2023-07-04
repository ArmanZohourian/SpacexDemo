//
//  NewShiftEditView.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/17/22.
//

import SwiftUI

struct NewShiftEditView: View {
    
    @AppStorage("language")
    
    private var language = LocalizationService.shared.language
    
    @EnvironmentObject var addDailyShiftViewModel: AddDailyShiftViewModel
    
    @EnvironmentObject var getShiftViewModel: GetShiftViewModel
    
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
    
    @Binding var isPresented : Bool {
        didSet {
            selectedDays = generateDay(with: getShiftViewModel.currentShift!.weekDay)
        }
    }
    
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm a"
        return formatter
    }
    
    
    var timeFormat: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter
    }
    
    
    var durationTimeFormat: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }
    
    
    
    var body: some View {
     
        ActionSheetView {
            ScrollView {
                VStack(alignment: .trailing ,spacing: 10) {
                    

                        
                    Text("shift_detail_days_label".localized(language))
                    
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
                    CustomTextField(colors: colors, labelName: "shift_detail_shift_label".localized(language), placeholder: addDailyShiftViewModel.currentShift?.title ?? "", text: $shiftTitle, isPassword: false)
                    
                    CustomTextField(colors: colors, labelName: "shift_detail_shift_duration_label".localized(language), placeholder:  "", text: $shiftDurationStr , isPassword: false)
                    
                        .disabled(true)
                    
                        .onTapGesture {
                            isShowingDurationDatePicker = true
                            hideKeyboard()
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
                            .overlay(alignment: .bottom, content: {
                                Text("\(endTime,formatter: dateFormatter)")
                                    .font(.custom("YekanBakhNoEn-Regular", size: 14))
                                    .padding()
                                    .onTapGesture {
                                        isShwoingEndDatePicker = true
                                        hideKeyboard()
                                    }
                            })
                            .onTapGesture {
                                isShwoingEndDatePicker = true
                                hideKeyboard()
                            }
                        
                        
                        Spacer()
                        
                        TimerView(colors: colors, textValue: $endTimeStr, labelText: "shift_detail_shift_start_time".localized(language), logo: "clock-standby")
                            .overlay(alignment: .bottom, content: {
                                Text("\(startTime, formatter: dateFormatter)")
                                    .font(.custom("YekanBakhNoEn-Regular", size: 14))
                                    .padding()
                                    .onTapGesture {
                                        isShowingStartDatePicker = true
                                        hideKeyboard()
                                    }
                            })
                            .onTapGesture {
                                isShowingStartDatePicker = true
                                hideKeyboard()
                            }
                        
                    }
                    
                    
                    Button {
                        Task {
                            await addDailyShiftViewModel.editShift(startDate: startTime.getFormattedDate(format: "HH:mm:ss"), endDate: endTime.getFormattedDate(format: "HH:mm:ss"), shiftDuration: shiftDuration.getFormattedDate(format: "HH:mm:ss"), shiftTitle: shiftTitle, days: selectedDays, currentShift:  getShiftViewModel.currentShift!, completionHandler: {isSuccessful in
                                if isSuccessful {
                                    isPresented.toggle()
                                }
                            })
                            
                            await addDailyShiftViewModel.getShiftDetails()
                                                    
                        }
                    } label: {
                        GreenFunctionButton(buttonText: "shift_detail_register_shift".localized(language), isAnimated: $addDailyShiftViewModel.isRequesting)
                            .frame(width: UIScreen.screenWidth - 20 , height: 45)
                    }

                    
                    .popup(isPresented: $addDailyShiftViewModel.hasError, view: {
                        FloatBottomView(colors: colors.redColor, errorMessage: addDailyShiftViewModel.errorMessage)
                    }, customize: {
                        $0
                            .animation(.spring())
                            .autohideIn(3)
                            .position(.bottom)
                            .type(.floater())
                    })
                    
                    
                }
                .padding(.bottom)
            
            }
            
            .padding()
            
            .onAppear(perform: {
                selectedDays = generateDay(with: getShiftViewModel.currentShift!.weekDay)

                shiftTitle = getShiftViewModel.currentShift!.name

                shiftDuration = timeFormat.date(from: getShiftViewModel.currentShift!.bookDuration)!

                startTime = timeFormat.date(from: getShiftViewModel.currentShift!.start)!

                endTime = timeFormat.date(from: getShiftViewModel.currentShift!.end)!

                })
        }
        
        
        .overlay(alignment: .bottom) {
            if isShwoingEndDatePicker {
                HourAndMinutePickerView(date: $endTime, isPresented: $isShwoingEndDatePicker)
            }

        }
        
        
        .overlay(alignment: .bottom) {
            if isShowingStartDatePicker {
                HourAndMinutePickerView(date: $startTime, isPresented: $isShowingStartDatePicker)
                
            }
        }
        
        .overlay(alignment: .bottom) {
            if isShowingDurationDatePicker {
                HourAndMinutePickerView(date: $shiftDuration, isPresented: $isShowingDurationDatePicker)
                    .environment(\.locale, .init(identifier: "en_GB"))
                    
            }

        }
            

        
        
    }
        
    
    
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
    
    private func generateDay(with days: [String]) -> [String] {
        
        var selectedDays = [""]
        
        for day in days {
            switch day {
                case "SATURDAY":
                selectedDays.append("saturday".localized(language))
                case "SUNDAY":
                selectedDays.append("sunday".localized(language))
                    
                case "MONDAY":
                selectedDays.append("monday".localized(language))
                    
                case "TUESDAY":
                selectedDays.append("tuesday".localized(language))
                    
                case "WEDNESDAY":
                selectedDays.append("wednesday".localized(language))
                    
                case "THURSDAY":
                selectedDays.append("thursday".localized(language))
                    
                case "FRIDAY":
                selectedDays.append("firday".localized(language))
                    
            default:
                return [""]
            }
        }
        
       
        print("DAYSARE")
        print(selectedDays)
        selectedDays.remove(at: 0)
        return selectedDays
        
    }
    
    
    
}
