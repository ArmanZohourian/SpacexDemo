//
//  AddShiftHaburgerView.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/16/22.
//

import SwiftUI

struct AddShiftHaburgerView: View {
    
    @AppStorage("language")
    
    private var language = LocalizationService.shared.language
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var startDate = Date() {
        didSet {
            startDateStr = DateFormatter().string(from: startDate)
        }
    }
    @State var endDate = Date() {
        didSet {
            endDateStr = DateFormatter().string(from: startDate)
        }
    }
    
    
    @State var isDateGotten = false
    
    @State var isShowingEditShift = false
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
//        formatter.dateStyle = .long
        formatter.dateFormat = "yyyy/MM/dd"
        formatter.locale = Locale(identifier: "Fa")
        return formatter
    }
    
    
    @State var startDateStr = ""
    @State var endDateStr = ""
    
    
    
    var colors: ConstantColors
    
    @State var isShowingNewShiftViewPopup = false
    
    @State var isShowingDatePickerStartDate = false
    
    @State var isShowingDatePickerEndDate = false
    
    @State var reservedDays: String = ""
    
    @State var isHolidaysOn = false
    
    @StateObject var addShiftViewModel = AddShiftViewModel()
    
    @StateObject var addDailyShiftViewModel = AddDailyShiftViewModel()
    
    @StateObject var getShiftViewModel = GetShiftViewModel()
    
    var backButton: some View {
        Button {
            self.presentationMode.wrappedValue.dismiss()
        } label: {
            Image("arrow-square-left")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30)
        }

    }
    
    var body: some View {
        
        ScrollView {
            VStack(spacing: 10) {
                
                
                CustomNavigationTitle(name: "shifts".localized(language), logo: "briefcase", colors: colors)
                    .foregroundColor(colors.whiteColor)
            
                
                
                
                HStack(spacing: 15) {
                    
                    TimerView(colors: colors, textValue: $startDateStr , labelText: "shift_end_time".localized(language), logo: "calendar-shift")
                    
                        .overlay(alignment: .bottom) {
                            Text("\(endDate, formatter: dateFormatter)")
                                .environment(\.calendar, language == .persian ? .persianCalendar : .gregorianCalendar)
                                .font(.custom("YekanBakhNoEn-Regular", size: 13))
                                .padding(.bottom)
                                .onTapGesture {
                                    isShowingDatePickerEndDate = true
                                    hideKeyboard()
                                }
                        }
                    
                    
                    TimerView(colors: colors, textValue: $endDateStr, labelText: "shift_start_time".localized(language), logo: "calendar-shift")
                        .overlay(alignment: .bottom) {
                            Text("\(startDate, formatter: dateFormatter)")
                                .font(.custom("YekanBakhNoEn-Regular", size: 13))
                                .environment(\.calendar, language == .persian ? .persianCalendar : .gregorianCalendar)
                                .padding(.bottom)
                                .onTapGesture {
                                    isShowingDatePickerStartDate = true
                                    hideKeyboard()
                                }
                        }
                }
                
                
                CustomTextField(colors: colors, labelName: "open_schedule_days".localized(language), placeholder: "open_schedule_placeholder".localized(language), text: $reservedDays, isPassword: false)
                    .keyboardType(.numberPad)
                
                HStack(spacing: 10) {
                    
                    Toggle("", isOn: $isHolidaysOn)
                        .frame(width: 20, height: 20)
                        .environment(\.layoutDirection, .leftToRight)
                        .padding([.trailing,.leading])
                    Spacer()
                    Text("shift_holidays_active_description".localized(language))
                        .font(.custom("YekanBakhNoEn-Regular", size: 14))
                    
                    Image("info-circle")
                }
                .padding()

                //MARK: Show the existing shifts, forEach
                Spacer()
                Button {
                    //Send shifts to network
                    Task {
                        //MARK: FIX THIS , dates have changed type from date to string , changes are in add shift view
                        await addShiftViewModel.addShift(startDate: startDate,endDate: endDate,activeDays: reservedDays,isHolidaysOn: isHolidaysOn)
                        await getShiftViewModel.getShift()
                    }
                } label: {
                    GreenFunctionButton(buttonText: "shift_button_text".localized(language), isAnimated: $addShiftViewModel.isRequeting)
                }
                .disabled(addShiftViewModel.isRequeting)
                .frame(width: UIScreen.screenWidth - 15, height: 40)
                .padding(.bottom, 30)
                
            }
            .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight)
        }
            
            .onTapGesture {
                hideKeyboard()
            }
            
        
            .task {
                
                await getShiftViewModel.getShift()
        
                reservedDays = getShiftViewModel.activeDays
                isHolidaysOn = getShiftViewModel.isHolidaysActivated
                startDate = getShiftViewModel.startDate ?? Date()
                endDate = getShiftViewModel.endDate ?? Date()
            }
            
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: backButton)
        
            .popup(isPresented: $isShowingNewShiftViewPopup, view: {
                NewShiftView(isPresneted: $isShowingNewShiftViewPopup, colors: colors, isPresented: $isShowingNewShiftViewPopup)
                    .environmentObject(getShiftViewModel)
                    .environmentObject(addDailyShiftViewModel)
            }, customize: {
                $0
                    .type(.toast)
                    .position(.bottom)
                    .closeOnTap(false)
                    .closeOnTapOutside(true)
                    .backgroundColor(.black.opacity(0.4))
            })
        
        
            .popup(isPresented: $addDailyShiftViewModel.isSuccessfull, view: {
                ErrorMessageToastView(colors: Color.green, errorText: $addShiftViewModel.errorMessage)
                    .padding(.top)
            }, customize: {
                $0
                    .position(.top)
                    .autohideIn(3)
                    .type(.toast)
            })
            
        
            .popup(isPresented: $addShiftViewModel.hasError, view: {
                ErrorMessageToastView(colors: Color.red, errorText: $addShiftViewModel.errorMessage)
                    .padding(.top)
            }, customize: {
                    $0
                    .type(.toast)
                    .position(.top)
                    .autohideIn(3)
                
            })
        
        
            .popup(isPresented: $isShowingDatePickerEndDate, view: {
                CustomDatePicker(isPresented: $isShowingDatePickerEndDate, date: $endDate)
            }, customize: {
                $0
                    .position(.bottom)
                    .type(.toast)
                    .closeOnTapOutside(true)
                    .backgroundColor(.black.opacity(0.4))
            })
        
            .popup(isPresented: $isShowingDatePickerStartDate, view: {
                CustomDatePicker(isPresented: $isShowingDatePickerStartDate, date: $startDate)
            }, customize: {
                $0
                    .closeOnTapOutside(true)
                    .position(.bottom)
                    .type(.toast)
                    .backgroundColor(.black.opacity(0.4))
            })
        
            
            .edgesIgnoringSafeArea([.top,.bottom])
        
        
            .popup(isPresented: $isShowingEditShift, view: {
                NewShiftEditView(colors: colors, isPresented: $isShowingEditShift)
                    .environmentObject(getShiftViewModel)
                    .environmentObject(addDailyShiftViewModel)
                    .environmentObject(KeyboardResponder())
            }, customize: {
                $0
                    .closeOnTap(false)
                    .type(.toast)
                    .position(.bottom)
                    .backgroundColor(.black.opacity(0.4))
                
            })
        
    }
    
    
    
    private func setCurrentShift(with shift: ShiftDetail) {
        
        getShiftViewModel.currentShift = shift
        isShowingEditShift = true
    }
}

struct AddShiftHaburgerView_Previews: PreviewProvider {
    static var previews: some View {
        AddShiftHaburgerView(colors: ConstantColors())
    }
}
