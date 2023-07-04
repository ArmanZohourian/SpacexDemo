//
//  AddShiftView.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/13/22.
//

import SwiftUI
import ExytePopupView

struct AddShiftView: View {
    
    
    @AppStorage("language")
    
    private var language = LocalizationService.shared.language
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var baseViewModel : BaseViewModel
    
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
    
    
    
    @State var startDate = Date() {
        didSet {
            print("Happening")
        }
    }
    @State var endDate = Date() {
        didSet {
            print("Happening")
        }
    }
    
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }
    
    @State var startDateStr = ""
    
    @State var endDateStr = ""
    
    @State var currentShift = NewShift(serverId: -1, title: "", startHour: "", endHour: "", duration: "", days: [""]) {
        didSet {
            print("Value changed")
        }
    }
    
    
    
    var colors: ConstantColors
    @State var isShowingNewShiftViewPopup = false
    @State var isShowingDatePickerStartDate = false
    @State var isShowingDatePickerEndDate = false
    @State var isShowingEditShift = false
    @State var reservedDays: String = ""
    @State var isHolidaysOn = false
    
    @StateObject var addShiftViewModel = AddShiftViewModel()
    @StateObject var addDailyShiftViewModel = AddDailyShiftViewModel()
    @StateObject var getShiftViewModel = GetShiftViewModel()
    @StateObject var keyboardResponser: KeyboardResponder = KeyboardResponder()
    
    
    var body: some View {
        
        
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 10) {
                    
//                flowName: "shift_header".localized(language)
                    CustomFlowView(colors: colors, flowDescription: "shift_subheader".localized(language), flowImage: "user-shift-flow", flowBgImage: "addshift-flow")
                        
                    
                    HStack(spacing: 15) {
                        TimerView(colors: colors, textValue: $startDateStr , labelText: "shift_end_time".localized(language), logo: "calendar-main")
                            .onTapGesture {
                                isShowingDatePickerEndDate = true
                                hideKeyboard()
                            }
                            .overlay(alignment: .bottom) {
                                Text("\(endDate, formatter: dateFormatter)")
                                    .font(.custom("YekanBakhNoEn-Regular", size: 13))
                                    .environment(\.calendar, language == .english ? .gregorianCalendar : .persianCalendar)
                                    .padding(.bottom)
                                    .onTapGesture {
                                        isShowingDatePickerEndDate = true
                                        hideKeyboard()
                                    }
                            }
                        
                        TimerView(colors: colors, textValue: $endDateStr, labelText: "shift_start_time".localized(language), logo: "calendar-main")
            
                            .onTapGesture {
                                isShowingDatePickerStartDate = true
                                hideKeyboard()
                            }
                        
                            .overlay(alignment: .bottom) {
                                Text("\(startDate, formatter: dateFormatter)")
                                    .font(.custom("YekanBakhNoEn-Regular", size: 13))
                                    .environment(\.calendar, language == .english ? .gregorianCalendar : .persianCalendar)
                                    .padding(.bottom)
                                    .onTapGesture {
                                        isShowingDatePickerStartDate = true
                                        hideKeyboard()
                                    }
                            }
                    }
                    .padding(.top)
                    
                    
                    CustomTextField(colors: colors, labelName: "open_schedule_days".localized(language), placeholder: "open_schedule_placeholder".localized(language), text: $reservedDays, isPassword: false)
                        .keyboardType(.numberPad)
                    
                    HStack(spacing: 10) {
                        
                        Toggle("", isOn: $isHolidaysOn)
                            .frame(width: 20, height: 20)
                            .environment(\.layoutDirection, .leftToRight)
                            .padding([.trailing, .leading])
                        
                        Spacer()
                        Text("shift_holidays_active_description".localized(language))
                            .font(.custom("YekanBakhNoEn-Regular", size: 14))
                            .environment(\.layoutDirection, language == .persian ? .rightToLeft : .leftToRight)
                        
                        Image("info-circle")
                    }
                    .padding()

                    Spacer()
                    
                    Button {
                        //Shift configuration to network

                        Task {
                            
                            await addShiftViewModel.addShift(startDate: startDate,endDate: endDate ,activeDays: reservedDays,isHolidaysOn: isHolidaysOn)
                            
                        }
                    } label: {
                        GreenFunctionButton(buttonText: "shift_button_text".localized(language), isAnimated: $addShiftViewModel.isRequeting)
                            
                    }
                    
                    .frame(width: geometry.size.width - 15, height: 40)
                    .padding(.bottom, 30)

                }
                .frame(width: geometry.size.width, height: geometry.size.height)
                

                
                .popup(isPresented: $addShiftViewModel.hasError, view: {
                    FloatBottomView(colors: colors.redColor, errorMessage: addShiftViewModel.errorMessage)
                }, customize: {
                    $0
                        .type(.floater())
                        .animation(.spring())
                        .autohideIn(3)
                        .position(.bottom)
                })
                
                .environment(\.layoutDirection, language.rawValue == "en" ? .rightToLeft : .leftToRight)
                
            }
            .onTapGesture {
                hideKeyboard()
            }
        }
        
        
        
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: NavigationItemsView(title: "shift_header".localized(language), isBackButtonHidden: false))
        .background(
            NavigationLink(isActive: $addShiftViewModel.isSuccessfull, destination: {

                AddDailyShift(colors: colors)
                    .environmentObject(keyboardResponser)
                    .environmentObject(addDailyShiftViewModel)
                    .environmentObject(getShiftViewModel)
                    .environmentObject(baseViewModel)
                    
            }, label: {
                EmptyView()
            })
        )
        
        .task {
            
            await getShiftViewModel.getShiftDetails()
            
        }
        

        
        .popup(isPresented: $isShowingDatePickerEndDate, view: {
            CustomDatePicker(isPresented: $isShowingDatePickerEndDate, date: $endDate)
        }, customize: {
            $0
                .type(.toast)
                .position(.bottom)
                .backgroundColor(.black.opacity(0.4))
                .closeOnTapOutside(true)
                .closeOnTap(false)
        })
        
        
        .popup(isPresented: $isShowingDatePickerStartDate, view: {
            CustomDatePicker(isPresented: $isShowingDatePickerStartDate, date: $startDate)
        }, customize: {
            $0
                .type(.toast)
                .position(.bottom)
                .backgroundColor(.black.opacity(0.4))
                .closeOnTapOutside(true)
                .closeOnTap(false)
        })
        
        .edgesIgnoringSafeArea([.top,.bottom])
    }
    
    

    
    
    
    
    
}

struct AddShiftView_Previews: PreviewProvider {
    static var previews: some View {
        AddShiftView(colors: ConstantColors())
    }
}
