//
//  MainCalendarView.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/7/22.
//

import SwiftUI
import ExytePopupView

struct TodaysTaskView: View {
    
//    @AppStorage("language", store: .standard)
    
    @AppStorage("calendar", store: .standard) var calendarType = "jalali"
    
    var language = LocalizationService.shared.language
    
    var colors: ConstantColors
    
    @State var isShowingActionPopup = false
    
    @State var isShowingEndActionPopup = false
    
    @State var isShwoingCancelActionPopup = false
    
    @State var isCalendarExpanded = true
    
    @State var isActiveState : Bool = false
    
    @State var selectedTask: Book = Book(status: "", date: "", end: "", serviceName: "", userPhone: "", createdAt: "", businessUserName: "", id: -1, cost: 1, start: "", businessUserId: -1, serviceId: -1)
    
    @State var isScrollActivated = false
    
    @State var isShowingEditPopup = false
    
    @State var isHamburgerPresnted = false
    
    @EnvironmentObject var todayTaskViewModel : TodayTaskViewModel
    
    @EnvironmentObject var calendarViewModel : CalendarViewModel
    
    @EnvironmentObject var timeViewModel: TimeViewModel
    
    @State private var timeRemaining = 60
    
    @State var isEventsPresented = false
    
    @EnvironmentObject var keyboardResponder : KeyboardResponder
    
    @EnvironmentObject var baseViewModel: BaseViewModel
    
    @EnvironmentObject var profileCellViewModel: ProfileCellViewModel
    
    @State var selectedDate = Date()
    
    var body: some View {
        
        content
        
    }
    
    
    //MARK: Since the DidSet doesn't work on @State properties, a binding with a random get and set is created
    //This could also be used in the viewmodel, but that way the property should also be tracked
    var content: some View {
        
        let dateBinding = Binding(
            get: { self.selectedDate },
            set: {
                print("Old value was \(self.selectedDate) and new date is \($0)")
                self.selectedDate = $0
                Task {
                    await todayTaskViewModel.getBookings(with: selectedDate)
                    await calendarViewModel.getCalendarStatus(withDate: selectedDate)
                    
                }
                
            }
        )
        
        
        return VStack {
            ZStack {
                VStack(spacing: 0) {
                    
                    ProfileCellView(isPresented: $isHamburgerPresnted)
                        .environmentObject(profileCellViewModel)
                        .environment(\.layoutDirection, .leftToRight)
                        .padding(.top, 25)
                    
                    if isCalendarExpanded {
                        
                        CalendarRectangle(colors: colors, isEventsPresented: $isEventsPresented, selectedDate: dateBinding, isCalendarExpanded: $isCalendarExpanded)
                            .environmentObject(todayTaskViewModel)
                            .environmentObject(calendarViewModel)
                            .overlay(content: {
                                if calendarViewModel.isRequesting {
                                    Color.black.opacity(0.4)
                                }
                            })
                            .onAppear {
                                print("Getting again")
                                if calendarViewModel.reports.count == 0 {
                                    Task {
                                        await calendarViewModel.getCalendarStatus()
                                    }
                                }
                            }
                        
                    } else {
                        
                        
                        CalendarShrinkView(colors: colors)
                            .environmentObject(calendarViewModel)
                            .disabled(true)
                            .onTapGesture {
                                withAnimation(Animation.linear(duration: 0.3)) {
                                    isCalendarExpanded = true
                                }
                            }
                            .frame(width: UIScreen.screenWidth, height: 100)
                    }

                }
                .background(colors.blueColor)


            }
            .frame(width: UIScreen.screenWidth)
            .edgesIgnoringSafeArea(.top)
            .cornerRadius(15, corners: [.bottomLeft, .bottomRight])
            
            
            
            
            //MARK: Events
            if isEventsPresented {
                
                EventsView(colors: colors, selectedDate: $selectedDate)
                    .environment(\.layoutDirection, language == .persian ? .leftToRight : .rightToLeft)
                    .environmentObject(calendarViewModel)
                    .padding()
                
            } else {
                
                
                //MARK: Task Reports
                
                List {
                        
                        TodaysIncomeView(cancelCount: checkCancelCounts(withSelectedDate: selectedDate), doneCount: checkDoneCount(withSelectedDate: selectedDate), queueCount: checkWaitingCount(withSelected: selectedDate), dayIncome: checkIncome(withSelected: selectedDate), colors: colors)
                            .padding([.leading,.trailing])
                            .listRowSeparator(.hidden)
                        
                        
                        ForEach(todayTaskViewModel.todayTasks) { task in
                            
                            
                            QueueCellView(colors: colors,
                                          time: "Some time" ,
                                          cost: String(task.cost),
                                          userName: task.businessUserName,
                                          startTime: task.start,
                                          endTime: task.end,
                                          duration: haveDuration(with: task) ? getDurationWith(actualEnd: task.actualEnd!, actualStart: task.actualStart!) : "" ,
                                          status: task.status, serviceName: task.serviceName, userImage: task.businessUserPicture)
                            
                            .listRowSeparator(.hidden)
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                
                                if !isInPrgoress(with: task.status) {
                                    Button {
                                        //Bring pop up view
                                        isShowingActionPopup.toggle()
                                        //Send the id to the child view
                                        select(task: task)
                                        
                                    } label: {
                                        VStack {
                                            Image("timer-start")
                                                .foregroundColor(colors.whiteColor)
                                            Text("start".localized(language))
                                        }
                                    }
                                    .tint(.green)
                                    
                                    Button {
                                        //Edit from list
                                        select(task: task)
                                        isShowingEditPopup.toggle()
                                    } label: {
                                        VStack {
                                            Image("edit-button")
                                                .foregroundColor(colors.whiteColor)
                                            Text("edit".localized(language))
                                        }
                                    }
                                    
                                    .tint(.orange)
                                    
                                    Button {
                                        //Delete from list
                                        select(task: task)
                                        isShwoingCancelActionPopup.toggle()
                                    } label: {
                                        VStack {
                                            Image("close-circle-3")
                                            Text("cancel".localized(language))
                                        }
                                    }
                                    .tint(.red)
                                    
                                    
                                    
                                } else {
                                    Button {
                                        //Bring pop up view
                                        select(task: task)
                                        isShwoingCancelActionPopup.toggle()
                                        
                                    } label: {
                                        VStack {
                                            Image("timer-start")
                                                .foregroundColor(colors.whiteColor)
                                            Text("cancel".localized(language))
                                        }
                                    }
                                    .tint(colors.redColor)
                                    
                                    Button {
                                        //Edit from list
                                        isShowingEndActionPopup.toggle()
                                        select(task: task)
                                        
                                    } label: {
                                        VStack {
                                            Image("close-circle-3")
                                                .foregroundColor(colors.whiteColor)
                                            Text("end".localized(language))
                                        }
                                    }
                                    .tint(colors.darkRed)
                                }
                                
                                
                            }
                            .padding([.leading, .trailing])
                        }
                        .listRowSeparator(.hidden)
                        
                        
                    
                    .padding([.leading, .trailing])
                }
                .listStyle(.plain)
                .padding([.leading,.trailing])
            }

        }
        
        .fullScreenCover(isPresented: $isHamburgerPresnted, content: {
            MenuHumbergerView(isPresneted: $isHamburgerPresnted, colors: colors)
                .environmentObject(profileCellViewModel)
                .environmentObject(keyboardResponder)
                .environmentObject(baseViewModel)
            
        })
        
        .background(Color.white)
        .edgesIgnoringSafeArea(.top)

        
        .popup(isPresented: $isShowingActionPopup, view: {
            

            StartActionView(isPresented: $isShowingActionPopup, colors: colors,task : $selectedTask)
                .environmentObject(todayTaskViewModel)
                .environmentObject(calendarViewModel)
        }, customize: {
            $0
                .closeOnTap(false)
                .backgroundColor(.black.opacity(0.4))
                
        })
        
        
        .popup(isPresented: $isShwoingCancelActionPopup, view: {
            
            CancelActionView(colors: colors, isPresented: $isShwoingCancelActionPopup, task: $selectedTask)
                 .environmentObject(todayTaskViewModel)
                 .environmentObject(calendarViewModel)
        }, customize: {
            $0
                .closeOnTap(false)
                .backgroundColor(.black.opacity(0.4))
        })
        
        
        .popup(isPresented: $isShowingEditPopup, view: {
            BottomSheetView(isPresenteed: $isShowingEditPopup) {
                EditTaskView(colors: colors, isPresented: $isShowingEditPopup, task: $selectedTask, selectedDate: $selectedDate)
                    .environmentObject(todayTaskViewModel)

            }

        }, customize: {
            $0
                .closeOnTap(false)
                .backgroundColor(.black.opacity(0.4))
                .position(.bottom)
                .type(.toast)
                .isOpaque(true)

        })
        
        
        
        .customPopupView(isPresented: $isShowingEndActionPopup, content: {
            EndActionView(colors: colors, isPresented: $isShowingEndActionPopup, task: $selectedTask)
                    .environmentObject(todayTaskViewModel)
                    .environmentObject(keyboardResponder)
                    .environmentObject(timeViewModel)
        
        })
        
        
        .task {
            
            if todayTaskViewModel.todayTasks.count == 0 {
                await todayTaskViewModel.getBookings(with: selectedDate)
            }
        }
        
        

    }
    
    
    //MARK: Functions
    
    
    private func getStringDate(withDate date: Date) -> String {
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "En")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
        
    }

    private func getDurationWith(actualEnd: String, actualStart: String) -> String {
        
        let intActualEnd = calculateTimeStamp(with: actualEnd)
        let intActualStart = calculateTimeStamp(with: actualStart)
        
        let duration = intActualEnd - intActualStart
        let finalDurationStr = calculateDateFromTimeStampStr(with: duration)
        
        return finalDurationStr
        
    }
    
    private func calculateDateFromTimeStampStr(with timeStamp: Int) -> String {
        
        let date = Date(timeIntervalSince1970: Double(timeStamp))
        let df = DateFormatter()
        df.dateFormat = "HH:mm:ss"
        df.timeZone = .init(secondsFromGMT: 0)
        let convertedDate = df.string(from: date)
        return convertedDate
    }
    
    private func calculateTimeStamp(with date: String) -> Int {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        let calculatedDate = dateFormatter.date(from: date)
        let timeStamp : TimeInterval = calculatedDate!.timeIntervalSince1970
        let calculatedTs = Int(timeStamp)
        
        return calculatedTs
        
        
        
    }
    
    private func isInPrgoress(with status: String) -> Bool {
        
        if status == "IN_PROGRESS" {
            return true
        } else {
            return false
        }
        
    }
    
    private func haveDuration(with task: Book) -> Bool {
        
        if task.actualStart != nil && task.actualEnd != nil {
            return true
        } else {
            return false
        }
        
    }
    
    private func select(task: Book) {
        
        self.selectedTask = task
        print(selectedTask)
        
    }
    
    private func checkCancelCounts(withSelectedDate date: Date) -> String {
        //MARK: ADD A ESTIMATED VAR FOR DATE FORMATTER
        let dateFormatter : DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            formatter.locale = Locale(identifier: "En")
            return formatter
        }()

        
        var cancelCount = 0
    
        for day in calendarViewModel.reports {

            if day.date == dateFormatter.string(from: date) {
                cancelCount = day.cancelCount
                break
            } else {
                cancelCount = 0
            }
        }
        print(cancelCount)
        return String(cancelCount)
    }
    
    private func checkDoneCount(withSelectedDate date: Date) -> String {
        
        let dateFormatter : DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            formatter.locale = Locale(identifier: "En")
            return formatter
        }()

        
        var doneCount = 0
    
        for day in calendarViewModel.reports {

            if day.date == dateFormatter.string(from: date) {
                doneCount = day.doneCount
                break
            } else {
                doneCount = 0
            }
        }
        
        return String(doneCount)
        
    }
    
    private func checkWaitingCount(withSelected date: Date) -> String {
        
        let dateFormatter : DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            formatter.locale = Locale(identifier: "En")
            return formatter
        }()
        
        var waitingCount = 0
    
        for day in calendarViewModel.reports {

            if day.date == dateFormatter.string(from: date) {
                waitingCount = day.reserveCount
                break
            } else {
                waitingCount = 0
            }
        }
        return String(waitingCount)
    }
    
    private func checkIncome(withSelected date: Date) -> String {
        
        let dateFormatter : DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            formatter.locale = Locale(identifier: "En")
            return formatter
        }()

        
        var income = 0
    
        for day in calendarViewModel.reports {

            if day.date == dateFormatter.string(from: date) {
                income = day.totalCost
                break
            } else {
                income = 0
            }
        }
        
        return String(income)
    }
    
    
    
 
}


struct MainCalendarView_Previews: PreviewProvider {
    
    static var colors : ConstantColors = ConstantColors()
    static var previews: some View {
        TodaysTaskView(colors: colors)
    }
}


//// Pop up extention view

