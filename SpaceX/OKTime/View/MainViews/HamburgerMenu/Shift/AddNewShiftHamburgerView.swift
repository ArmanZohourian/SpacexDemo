//
//  AddNewShiftHamburgerView.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/22/22.
//

//
//  NewShiftView.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/15/22.
//

import SwiftUI
import ExytePopupView

struct AddNewShiftHamburgerView: View {
    
    
    
    
    @EnvironmentObject var addDailyShiftViewModel: AddDailyShiftViewModel
    
    
    
    @State var daysOfWeek: [String] = ["جمعه","پنج شنبه","چهار شنبه","سه شنبه","دو شنبه","یکشنبه","شنبه"]
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
//        formatter.dateStyle = .long
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
//    var startTimeStr : String {
//        let dateFormatter = DateFormatter()
//        return dateFormatter.string(from: startTime)
//    }
    
    @State var endTimeStr = ""
   
    @State var isShowingStartDatePicker = false
   
    @State var isShwoingEndDatePicker = false
   
    @State var isShowingDurationDatePicker = false
    @Binding var isPresented : Bool
    var body: some View {
     
            VStack(alignment: .trailing ,spacing: 10) {
                
                HStack {
                    Image("close-circle")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .onTapGesture {
                            isPresented = false
                        }
                    Spacer()
                    Text("ایام هفته")
                }
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
                CustomTextField(colors: colors, labelName: "عنوان شیفت", placeholder: "به عنوان مقال شیفت صبح", text: $shiftTitle, isPassword: false)
                
                CustomTextField(colors: colors, labelName: "مدت زمان هر نوبت", placeholder: "", text: $shiftDurationStr, isPassword: false)
                    .onTapGesture {
                        isShowingDurationDatePicker = true
                    }
                    
                    .overlay(alignment: .trailing) {
                        Text("\(shiftDuration, formatter: dateFormatter)")
                            .offset(y: 25)
                            .padding()
                            .onTapGesture {
                                isShowingDurationDatePicker = true
                            }
                    }
                
                
                HStack(spacing: 5) {
                    
                    TimerView(colors: colors, textValue: $startTimeStr , labelText: "ساعت پایان", logo: "clock-standby")
                        .onTapGesture {
                            isShwoingEndDatePicker = true
                        }
                    
                        .overlay(alignment: .leading) {
                            Text("\(endTime, formatter: dateFormatter)")
                                .offset(y: 10)
                                .padding()
                                .onTapGesture {
                                    isShwoingEndDatePicker = true
                                }
                        }
                    
                    
                    Spacer()
                    
                    TimerView(colors: colors, textValue: $endTimeStr, labelText: "ساعت شروع", logo: "clock-standby")
                        .onTapGesture {
                            isShowingStartDatePicker = true
                        }
                    
                        .overlay(alignment: .leading) {
                            Text("\(startTime, formatter: dateFormatter)")
                                .offset(y: 10)
                                .padding()
                                .onTapGesture {
                                    
                                    isShowingStartDatePicker = true
                                }
                        }
                    
                }
                
                
                GreenFunctionButton(buttonText: "ثبت شیفت", isAnimated: .constant(false))
                    .frame(width: UIScreen.screenWidth - 20 , height: 45)
                    .onTapGesture {
                        //Send request to server
                        Task {
                            await addDailyShiftViewModel.addNewShift(startDate: startTime.getFormattedDate(format: "HH:mm:ss"), endDate: endTime.getFormattedDate(format: "HH:mm:ss"), shiftDuration: shiftDuration.getFormattedDate(format: "HH:mm:ss"), shiftTitle: shiftTitle, days: selectedDays)
                            
                        }
                        isPresneted.toggle()
                    }
                
            }
            .padding()
            .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight / 1.7)
            .background(colors.whiteColor)

            .popup(isPresented: $isShowingDurationDatePicker, type: .toast, position: .bottom, closeOnTap: false, backgroundColor: .black.opacity(0.4)) {
                HourAndMinutePickerView(date: $shiftDuration, isPresented: $isShowingDurationDatePicker)
                    .environment(\.locale, .init(identifier: "en_GB"))
                    .frame(width: UIScreen.screenWidth)
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
                .padding(.bottom)
//                .offset(y: 120)
            
        }
        
        .edgesIgnoringSafeArea([.top,.bottom])
        
        
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
