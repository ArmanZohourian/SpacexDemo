//
//  EditTaskView.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/21/22.
//

import SwiftUI

struct EditTaskView: View {
    
    @AppStorage("language")
    
    private var language = LocalizationService.shared.language
    
    var colors: ConstantColors
    
    @StateObject var timeTableViewModel = TimeTableViewModel()
    
    @StateObject var contactsViewModel = ContactsViewModel()
    
    @StateObject var serviceViewModel = ServiceViewModel()
    
    @EnvironmentObject var todayTaskViewModel: TodayTaskViewModel
    
    
    @State var isShowingContactPopup = false
    
    @State var isServiceViewPersented = false
    
    @State var selectedTimeTable : GeneratedTimeTable = GeneratedTimeTable(title: "", time: "", day: "", id: -1, parentId: -1, isReserved: nil)
    
    @State var servicePrice = ""
    
    @Binding var isPresented: Bool
    
    @Binding var task: Book
    
    @Binding var selectedDate: Date
    
    var body: some View {
        
        ActionSheetView {
            VStack(spacing: 10){
    
                CustomTextView(text: ""  , colors: colors, labelName: "select_user".localized(language))
                    .overlay(alignment: .trailing, content: {
                        Text(timeTableViewModel.choosenContact.name == "" ? task.businessUserName : timeTableViewModel.choosenContact.name)
                            .padding()
                            .offset(y: 25)
                    })
                    .onTapGesture {
                        isShowingContactPopup.toggle()
                    }

                VStack {
                    ZStack(alignment: .leading) {
                        
                        
                        CustomTextField(colors: colors, labelName: "services".localized(language), placeholder: "", text: .constant(""))
                            .disabled(true)
                            .overlay(alignment: .trailing, content: {
                                Text(timeTableViewModel.choosenService.name == "" ? task.serviceName : timeTableViewModel.choosenService.name)
                                    .padding()
                                    .offset(y: 25)
                            })
                            
                            .onTapGesture {
                                isServiceViewPersented = true
                            }
                        
                        Button (action: {
                            //Add service
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
                                    .onTapGesture {
                                        isServiceViewPersented = true
                                    }
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
                            .padding()
                            .padding(.bottom, -20)
                            
                    }
                    .padding([.leading, .trailing])
                    ScrollView(.horizontal) {
                        
                        HStack {
                            
                            ForEach(timeTableViewModel.generatedTimeTableCollection) { collection in
                                ForEach(collection.generateTimeTable) { shift in
                                    
                                     if shift.title !=  "+" {

                                        CustomShiftView(colors: colors ,name: shift.title, time: shift.time, day: shift.day)
                                            .onTapGesture {
    //                                                selectShift(with: shift, colletion: collection)
                                                selectedTimeTable = shift
                                                print("Enabled")
                                            }
                                            .disabled(isTimeTableAvailable(with: shift))
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
                                         
                                            .overlay(content: {
                                                Rectangle()
                                                    .frame(width: 60, height: 60)
                                                    .foregroundColor(isSelectedEditTimeTable(with: shift) ? colors.lightBlueColor : Color.clear)
                                                   
                                            })
                                           
                                    }
                                    
                                    
                                    
                                   
                                }
                            }
                            
                            }
                            .flipsForRightToLeftLayoutDirection(false)
                            .environment(\.layoutDirection, .rightToLeft)
                            
                        }
                        .padding()
                    
                        
                    }
                Button {
                    Task {
                        await timeTableViewModel.editBookTime(choosenTime: selectedTimeTable, selectedDate: selectedDate, selectedTask: task)
                        
                        await todayTaskViewModel.getBookings(with: selectedDate)
                        
                        isPresented = false
                    }
                    
                } label: {
                    GreenFunctionButton(buttonText: "confirm_edit".localized(language), isAnimated: $timeTableViewModel.isRequesting)
                        .frame(width: UIScreen.screenWidth - 10, height: 40)
                        .padding(.bottom, 30)
                }

                
                }
        
            
                .sheet(isPresented: $isShowingContactPopup) {
                    ContactView(isPresneted: $isShowingContactPopup, colors: colors)
                        .environmentObject(contactsViewModel)
                        .environmentObject(timeTableViewModel)

                }
            
            
            
                .sheet(isPresented: $isServiceViewPersented , content: {
                    
                    SelectServiceView(colors: colors, isPresented: $isServiceViewPersented)
                        .environmentObject(timeTableViewModel)
                        .environmentObject(serviceViewModel)

                })
            

                .task {
                    timeTableViewModel.selectedDate = selectedDate
                    await timeTableViewModel.getTimeTables(selectedDate: selectedDate)
                }
                
                .onAppear {
                    timeTableViewModel.choosenService = SubCategory(serverId: task.serviceId ,name: "", price: "")
                    timeTableViewModel.choosenContact = ContactData(id: task.businessUserId, name: "", phone: "")
                }
            


                
        }

        }
    
    private func isSelectedTimeTable(with timeTable: GeneratedTimeTable) -> Bool {
        
        if selectedTimeTable.localId == timeTable.localId {
                    return true
            } else {
                    return false
            }
    }
    
    private func isSelectedEditTimeTable(with timeTable: GeneratedTimeTable) -> Bool {
        if timeTable.time == task.start {
            return true
        } else {
            return false
        }
    }
    
    private func isTimeTableAvailable(with timeTable: GeneratedTimeTable) -> Bool {
        if isTimeTableBooked(with: timeTable) && isSelectedEditTimeTable(with: timeTable) {
            return false
        } else {
            return isTimeTableBooked(with: timeTable)
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
