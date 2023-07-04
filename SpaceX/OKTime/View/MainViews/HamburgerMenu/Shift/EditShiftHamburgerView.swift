//
//  EditShiftHamburgerView.swift
//  OKTime
//
//  Created by Arman Zohourian on 12/1/22.
//

import SwiftUI

struct EditShiftHamburgerView: View {
    
    
    
    @EnvironmentObject var getShiftViewModel: GetShiftViewModel
    
    var language = LocalizationService.shared.language
    
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
    
    
    
    var body: some View {
     
        ActionSheetView {
            VStack(alignment: .trailing ,spacing: 10) {

                Text("shift_detail_days_label".localized(language))
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        
                        ForEach(daysOfWeek, id:\.self) { day in
                            
                            Rectangle()
                                .frame(width: 50, height: 50)
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
                CustomTextField(colors: colors, labelName: "shift_detail_shift_label".localized(language), placeholder: getShiftViewModel.currentShift?.name ?? "", text: $shiftTitle, isPassword: false)
                
                CustomTextField(colors: colors, labelName:"shift_detail_shift_duration_label".localized(language), placeholder:  "" , text: $shiftDurationStr , isPassword: false)
                    .disabled(true)
                    .onTapGesture {
                        isShowingDurationDatePicker = true
                    }
                    .overlay(alignment: .bottomTrailing) {
                        Text("\(shiftDuration, formatter: dateFormatter)")
                            .padding()
                            .onTapGesture {
                                isShowingDurationDatePicker = true
                            }
                    }
                
                
                
                HStack(spacing: 5) {
                    
                    TimerView(colors: colors, textValue: $startTimeStr , labelText: "shift_detail_shift_end_time".localized(language), logo: "clock-standby")
                        .overlay(alignment: .bottom, content: {
                            Text("\(endTime, formatter: dateFormatter)")
                                .padding()
                                .onTapGesture {
                                    isShwoingEndDatePicker = true
                                }
                        })
                        .onTapGesture {
                            isShwoingEndDatePicker = true
                        }
                    
                    
                    Spacer()
                    
                    TimerView(colors: colors, textValue: $endTimeStr, labelText: "shift_detail_shift_start_time".localized(language), logo: "clock-standby")
                        .overlay(alignment: .bottom, content: {
                            Text("\(startTime, formatter: dateFormatter)")
                                .padding()
                                .onTapGesture {
                                    isShowingStartDatePicker = true
                                }
                        })
                        
                    
                }
                
                
                GreenFunctionButton(buttonText: "shift_detail_register_shift".localized(language), isAnimated: .constant(false))
                    .frame(width: UIScreen.screenWidth - 20 , height: 45)
                    .onTapGesture {
                        //Send request to server
                        Task {
                            await getShiftViewModel.editShiftDetail(startDate: startTime.getFormattedDate(format: "HH:mm:ss"), endDate: endTime.getFormattedDate(format: "HH:mm:ss"), shiftDuration: shiftDuration.getFormattedDate(format: "HH:mm:ss"), shiftTitle: shiftTitle, days: selectedDays, currentShift:  getShiftViewModel.currentShift!)
                            
                            await getShiftViewModel.getShiftDetails()
                            
                        }
                        isPresented.toggle()
                    }
                
            }
            .onAppear(perform: {
                selectedDays = generateDay(with: getShiftViewModel.currentShift!.weekDay)

                shiftTitle = getShiftViewModel.currentShift!.name

                shiftDuration = timeFormat.date(from: getShiftViewModel.currentShift!.bookDuration)!

                startTime = timeFormat.date(from: getShiftViewModel.currentShift!.start)!

                endTime = timeFormat.date(from: getShiftViewModel.currentShift!.end)!

                })
            .padding()
            .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight / 1.7)
            .background(colors.whiteColor)

            .popup(isPresented: $isShowingDurationDatePicker, type: .toast, position: .bottom, closeOnTap: false, backgroundColor: .black.opacity(0.4)) {
                HourAndMinutePickerView(date: $shiftDuration, isPresented: $isShowingDurationDatePicker)
                    .environment(\.locale, .init(identifier: "en_GB"))
                    .frame(width: UIScreen.screenWidth)
                    .background(Color.red)
                    .padding()
                    .offset(y: 120)
                    
                
        }
        
        
        
        .popup(isPresented: $isShowingStartDatePicker, type: .toast, position: .bottom, closeOnTap: false, backgroundColor: .black.opacity(0.4)) {
            HourAndMinutePickerView(date: $startTime, isPresented: $isShowingStartDatePicker)
                .frame(width: UIScreen.screenWidth)
                .background(Color.red)
                .padding()
                .offset(y: 120)
            
        }
        .popup(isPresented: $isShwoingEndDatePicker, type: .toast, position: .bottom, closeOnTap: false, backgroundColor: .black.opacity(0.4)) {
            HourAndMinutePickerView(date: $endTime, isPresented: $isShwoingEndDatePicker)
                .frame(width: UIScreen.screenWidth)
                .background(Color.red)
                .padding()
                .offset(y: 120)
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
    
    private func setCurrentDays() {
        self.selectedDays = getShiftViewModel.currentShift!.weekDay
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
