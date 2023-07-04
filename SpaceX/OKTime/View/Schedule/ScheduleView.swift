//
//  ScheduleView.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/9/22.
//

import SwiftUI
import ExytePopupView

struct ScheduleView: View {
    
    
    @AppStorage("language")
    
    private var language = LocalizationService.shared.language

    var colors: ConstantColors
    
    @EnvironmentObject var contactViewModel: ContactsViewModel
    
    @StateObject var timeTableViewModel: TimeTableViewModel = TimeTableViewModel()
    //MARK: Should be an environment , creating extra instance
    @StateObject var serviceViewModel: ServiceViewModel = ServiceViewModel()
    
    @State var servicePrice = ""
    
    @State var isShowingContactPopup = false
    
    @State var isServiceViewPersented = false
    
    
    @State var selectedDate = Date()
    
    @EnvironmentObject var keyboardResponder : KeyboardResponder
    
    @EnvironmentObject var calendarViewModel: CalendarViewModel
    
    @EnvironmentObject var todayTaskViewModel: TodayTaskViewModel
    
    
    @State var selectedTimeTable = GeneratedTimeTable(title: "", time: "", day: "", id: nil, parentId: -100, isReserved: nil) {
        didSet {
            print(selectedTimeTable)
        }
    }
    
    @State var isSelected = true
    
    @Binding var isPresented : Bool
    
    var body: some View {
            
        
        ScrollView {
            content
                .padding(.bottom, keyboardResponder.currentHeight)
                .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight)
        }

        
        .overlay(alignment: .center) {
            if !timeTableViewModel.isLoaded {
                ZStack {
                    Color.black.opacity(0.4)
                    ProgressView()
                        
                        .frame(width: 200, height: 200, alignment: .center)
                        
                }
                .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight)
            }
            
        }
        
        
            
                
        .environment(\.layoutDirection, language == .persian ? .leftToRight : .rightToLeft)
        .sheet(isPresented: $isServiceViewPersented , content: {
                    
            SelectServiceView(colors: colors, isPresented: $isServiceViewPersented)
                .environmentObject(timeTableViewModel)
                        
                })
        
        
        .sheet(isPresented: $isShowingContactPopup) {
                ContactView(isPresneted: $isShowingContactPopup, colors: colors)
                    .environmentObject(contactViewModel)
                    .environmentObject(timeTableViewModel)

                }
                
        .popup(isPresented: $timeTableViewModel.hasError, view: {
            FloatBottomView(colors: colors.redColor, errorMessage: timeTableViewModel.errorMessage)

        }, customize: {
            $0
                .position(.bottom)
                .animation(.spring())
                .autohideIn(5)
                .type(.floater())
            
        })

        .popup(isPresented: $timeTableViewModel.isSuccessfull, view: { 
            FloatBottomView(colors: colors.greenColor, errorMessage: timeTableViewModel.errorMessage)
        }, customize: {
            $0
                .position(.bottom)
                .animation(.spring())
                .autohideIn(5)
                .type(.floater())
        })
        
    }
    
    var content: some View {
        
        let dateBinding = Binding(
            get: { self.selectedDate },
            set: {
                print("Old value was \(self.selectedDate) and new date is \($0)")
                self.selectedDate = $0
                timeTableViewModel.selectedDate = selectedDate
                Task {
//                    await todayTaskViewModel.getBookings(with: selectedDate)
//                    await calendarViewModel.getCalendarStatus(withDate: selectedDate)
                    await timeTableViewModel.getTimeTables(selectedDate: selectedDate)
                    
                    
                }
            }
        )
        
        return VStack(spacing: 0) {

            VStack {
                    
                ScheduleCalendarView(colors: colors, selectedDate: dateBinding)
                    .environment(\.calendar, .persianCalendar)
                    .environmentObject(timeTableViewModel)
                    .frame(width: UIScreen.screenWidth, height: 120)
                    .background(
                        colors.blueColor)
                    
                    
                
            }
            .cornerRadius(10, corners: [.bottomLeft,.bottomRight])
            
            
                
            
            VStack(spacing: 10){
                
                CustomTextView(text: ""  , colors: colors, labelName: "select_user".localized(language))
                    .overlay(alignment: .trailing, content: {
                        Text(timeTableViewModel.choosenContact.name)
                            .padding()
                            .offset(y: 25)
                    })
                    .onTapGesture {
                        isShowingContactPopup.toggle()
                    }
                //Service Stack
                VStack {
                    ZStack(alignment: .leading) {
                        
                        
                        CustomTextView(text: "", colors: colors, labelName: "services".localized(language))
                            .overlay(alignment: .trailing, content: {
                                Text(timeTableViewModel.choosenService.name)
                                    .padding()
                                    .offset(y: 25)
                            })
                           
                        
                        Button (action: {
                            //Add service
                            isServiceViewPersented = true
                        }, label: {
                            ZStack {
                                
                                Rectangle()
                                    .frame(width: 40, height: 40, alignment: .leading)
                                    .cornerRadius(5)
                                
                                Text("+")
                                    .foregroundColor(Color.white)
                                    .frame(alignment: .center)
                                    .font(.system(size: 30))
                                    .padding()
                            }
                        })
                        .foregroundColor(colors.blueColor)
                        .padding(.top, 50)
                        .padding(.leading, 5)
                        
                        
                    }
                    //Services cell , Hstack
                }
                
                VStack() {
                    
                    HStack {
                        EmptyView()
                        Spacer()
                        Text("schedule".localized(language))
                            .padding(.trailing)
                            .padding(.bottom, -20)
                    }
                   
                    ScrollView(.horizontal, showsIndicators: false){
                        
                        HStack {
                            
                            //MARK: Should be assigned
                            ForEach(timeTableViewModel.generatedTimeTableCollection) { collection in
                                ForEach(collection.generateTimeTable) { shift in
                                    switch checkShiftStatus(with: shift) {
                                    case .addLast :
                                        Rectangle()
                                            .frame(width: 20, height: 60)
                                            .overlay(alignment: .center) {
                                            Text("+")
                                                .foregroundColor(colors.blueColor)
                                                }
                                            .onTapGesture(perform: {
                                        
                                                    addTimeOutofRange(shift: shift, collection: collection)
                                            })
                                            .foregroundColor(Color.white)
                                            .overlay(
                                            RoundedRectangle(cornerRadius: 5)
                                            .stroke(colors.blueColor, lineWidth: 1)
                                            
                                    )
                                        Divider()

                                    case .addFirst:
                                        Rectangle()
                                        .frame(width: 20, height: 60)
                                        .overlay(alignment: .center) {
                                                Text("+")
                                                .foregroundColor(colors.blueColor)
                                        }
                                        .onTapGesture(perform: {
                                            addTimeOutofRange(shift: shift, collection: collection)
                                            })
                                        .foregroundColor(Color.white)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 5)
                                                .stroke(colors.blueColor, lineWidth: 1)
                                        )
                                        
                                        
                                        
                                    case .shift:
                                        CustomShiftView(colors: colors ,name: shift.title, time: shift.time, day: shift.day)
                                            .onTapGesture {
                                            selectedTimeTable = shift
                                        }
                                    .disabled(isTimeTableBooked(with: shift))
                                    .overlay(content: {
                                            Rectangle()
                                                .frame(width: 60, height: 60)
                                                .foregroundColor(isTimeTableBooked(with: shift) ? colors.lightRedColor : Color.clear)


                                    })
                                            
                                    .overlay(content: {
                                            Rectangle()
                                                .frame(width: 60, height: 60)
                                                .foregroundColor(isSelectedTimeTable(with: shift) ? colors.lightBlueColor : Color.clear)
                                                
                                        
                                        })
                                    }
                                
                                }
                            }
                        }
                            .flipsForRightToLeftLayoutDirection(false)
                            .environment(\.layoutDirection, .leftToRight)
                            
                        }
                        .frame(height: 80)
                        .padding()
                    
                    }
                
                Spacer()
                
                //MARK: Schedule action
                Button {
                    
                    
                    Task {
                        await timeTableViewModel.bookTime(with: servicePrice, choosenTime: selectedTimeTable, selectedDate: selectedDate)
                        
                        await todayTaskViewModel.getBookings(with: selectedDate)
                        
                        await calendarViewModel.getCalendarStatus(withDate: selectedDate)
                        
                        if timeTableViewModel.isSuccessfull {
                            
                            //Fetch the calendar
                            
                            //Fetch the tasks
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                // Dismiss sheet
                                isPresented = false
                            }
                        }
                        
                    }
                    
                } label: {
                    AddButtonView(buttonText: "confirm_schedule".localized(language), colors: colors)
                        .padding(.bottom, 50)
//                        .padding(.bottom, keyboardResponder.currentHeight)
                    }
                }
            
            
            }
        .padding(.bottom)

        .task {
            await timeTableViewModel.getTimeTables(selectedDate: selectedDate)
        }
        
}
        
        
        
    //MARK: Functions
    private func isSelectedTimeTable(with timeTable: GeneratedTimeTable) -> Bool {
        
        if selectedTimeTable.localId == timeTable.localId {
                    return true
            } else {
                    return false
            }
    }
        
    private func selectTimeTable(with timeTable: GeneratedTimeTable) {
        
        selectedTimeTable =  timeTable
    }
        
    private func addTimeOutofRange(shift: GeneratedTimeTable, collection: GeneratedTimeTableCollection) {
        
        //Call View Model
//            timeTableViewModel.generateShiftOutOfRange(with: shift)
        timeTableViewModel.generateShiftOutOfRange(with: shift, collection: collection)
//        print(shift)
        
    }

    private func isSelectedShift(with shift: GeneratedTimeTable, collection: GeneratedTimeTableCollection) {
        
        selectedTimeTable = shift
        //Use the parent Id to send the shift to server
        
    }
    
    private func checkShiftStatus(with shift: GeneratedTimeTable) -> ShiftStatus {
        
        if shift.id == -1 {
            return .addFirst
        } else if shift.id == -2 {
            return .addLast
        }
        
        return .shift
        
    }
    
    
    private func isValidShift(with shift: GeneratedTimeTable) -> Bool {
        if shift.id != -1 && shift.id != -2 {
            return true
        } else {
            return false
        }
    }
    
    
    private func isTimeTableBooked(with shift: GeneratedTimeTable) -> Bool {
        
        let reserve = timeTableViewModel.timeTableReserves.first { reserve in
            reserve.start == shift.time
        }
        
        if reserve != nil {
            return true
        }
        return false
        
    }
    
    
    
    
    
    
}
