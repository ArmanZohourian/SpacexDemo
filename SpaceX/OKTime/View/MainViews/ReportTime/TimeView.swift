//
//  TimeView.swift
//  OKTime
//
//  Created by Arman Zohourian on 10/13/22.
//

import SwiftUI
import SwiftUICharts
import ExytePopupView


struct TimeView: View {
    
    
    @AppStorage("language")
    
    private var language = LocalizationService.shared.language
    
    @State var isPresented : Bool = false
    
    @State var isPresentedPickerView : Bool = false
    
    @State var isShowingDatePickerStartDate = false
    
    @State var isShowingDatePickerEndDate = false
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }
    
    @StateObject var timeViewModel: TimeViewModel = TimeViewModel()
    
    @State var isHamburgerPresnted = false
    
    @EnvironmentObject var keyboardResponder : KeyboardResponder
    
    @EnvironmentObject var baseViewModel: BaseViewModel
    
    @EnvironmentObject var profileCellViewModel: ProfileCellViewModel

    var colors: ConstantColors
    
    var body: some View {
        
        VStack {
            
            //Top Search $ Profile rectangle
            
            
            ZStack {
                colors.blueColor
                    
                VStack {
                    ProfileCellView(isPresented: $isHamburgerPresnted)
                        .environmentObject(profileCellViewModel)
                        .environment(\.layoutDirection, .leftToRight)
                        .padding(.top)
    
        
                    //Calculate Report
                    VStack(alignment: .trailing) {
                        Text("get_reports".localized(language))
                            .font(.custom("YekanBakhNoEn-Bold", size: 15))
                            .foregroundColor(colors.whiteColor)
                            .padding(.trailing)
                        
                        
                    //MARK: Date to date Picker
                        HStack {
                            
                            //From Date to Date buttons
                            Button (action: {
                                //Send dates to server
                                Task {
                                    await timeViewModel.getBookingsWithDates(startDate: timeViewModel.startDate ,endDate: timeViewModel.endDate)
                                }
                            }, label: {
                                Text("search".localized(language))
                                    .foregroundColor(colors.whiteColor)
                                    .font(.custom("YekanBakhNoEn-Regular", size: 14))
                            })
                            
                            .frame(width: 70 ,height: 30)
                            .background(colors.blueColor)
                            .cornerRadius(4)
                            .padding(.leading, 8)
                            
                            Spacer()
                                       
                            if timeViewModel.isEndDateSet {
                                Text("\(timeViewModel.endDate, formatter: dateFormatter)")
                                    .font(.system(size: 12))
                                    .environment(\.calendar, language == .persian ? .init(identifier: .persian) : .init(identifier: .gregorian))
                                    .background(Color.white)
                                    .onTapGesture {
                                        isShowingDatePickerEndDate = true
                                        isShowingDatePickerStartDate = false
                                    }
                            } else {
                                Text("to".localized(language))
                                        .foregroundColor(colors.grayColor)
                                        .font(.system(size: 12))
                                        .frame(width: 70, alignment: .trailing)
                                        .onTapGesture {
                                            isShowingDatePickerEndDate = true
                                            isShowingDatePickerStartDate = false
                                        }
                                        
                            }
                            
                            

                            Divider()
                            Spacer()
                            
                            //Date Picker
                            
                            if timeViewModel.isStartDateSet {
                                Text("\(timeViewModel.startDate, formatter: dateFormatter)")
                                    .font(.system(size: 12))
                                    .environment(\.calendar, language == .persian ? .init(identifier: .persian) : .init(identifier: .gregorian))
                                    .background(Color.white)
                                    .onTapGesture {
                                        withAnimation(.default) {
                                            isShowingDatePickerEndDate = false
                                            isShowingDatePickerStartDate = true
                                        }
        
                                    }
                                
                            } else {
                                Text("from".localized(language))
                                    .foregroundColor(colors.grayColor)
                                    .font(.system(size: 12))
                                    .frame(width: 70, alignment: .trailing)
                                    .onTapGesture {
                                        withAnimation(.default) {
                                            isShowingDatePickerEndDate = false
                                            isShowingDatePickerStartDate = true
                                        }
                                    }
                                    
                            }
                            
                            Image("filter-search")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .aspectRatio(contentMode: .fit)
                                .padding()
                        
                            
                        }
                        .frame(height: 40)
                        .background(Color.white)
                        .cornerRadius(5)
                        .padding([.leading, .trailing])
                        
                        
                        
                    }
                    .padding(.bottom)
                    


                    
                }
                
            }
            .frame(width: UIScreen.screenWidth)
            .frame(height: UIScreen.screenHeight / 3.8)
            .cornerRadius(15, corners: [.bottomLeft , .bottomRight])
            
            

            

            ScrollView {
                
                AccountPreview(colors: colors, income: String((timeViewModel.incomeReport?.income) ?? 0) ?? "چیزی برای نمایش وجود ندارد", totalIncome: String((timeViewModel.incomeReport?.totalIncome) ?? 0) ?? "چیزی برای نمایش وجود ندارد")
                    
                
                //MARK: Chart View
                TimeChartView(colors: colors)
                    .padding()
                
                
                //Report Info Stack
                HStack {
                    Button {
                        
                    } label: {
                        Image("sort")
                            .resizable()
                            .frame(width: 20, height: 20)
                    }
                    

                    
                    Spacer()
                    
                    HStack {
                        
                        if timeViewModel.isEndDateSet {
                            Text("\(timeViewModel.endDate, formatter: dateFormatter)")
                                .font(.custom("YekanBakhNoEn-Regular", size: 12))
                                .environment(\.calendar, language == .persian ? .init(identifier: .persian) : .init(identifier: .gregorian))
                        } else {

                            Rectangle()
                                .foregroundColor(Color.black.opacity(0.3))
                                .frame(width: 50,height: 10)

                        }

                        Text("to".localized(language))
                            .font(.custom("YekanBakhNoEn-Regular", size: 12))
                            
                        
                        
                        if timeViewModel.isStartDateSet {
                            Text("\(timeViewModel.startDate, formatter: dateFormatter)")
                                .font(.custom("YekanBakhNoEn-Regular", size: 12))
                                .environment(\.calendar, language == .persian ? .init(identifier: .persian) : .init(identifier: .gregorian))
                        } else {
                            
                            Rectangle()
                                .foregroundColor(Color.black.opacity(0.3))
                                .frame(width: 50,height: 10)
                            
                        }

                        
                        Text("from".localized(language))
                            .font(.custom("YekanBakhNoEn-Regular", size: 12))
        
                       
                    }
                    .foregroundColor(colors.darkGrayColor)
                    
                    
                    
                    Text("reports".localized(language))
                        .foregroundColor(colors.blueColor)
                        .font(.custom("YekanBakhNoEn-Bold", size: 16))
                        
                    
                }
                .frame(width: UIScreen.screenWidth - 10, height: 50, alignment: .trailing)
                .padding()
                
                
                
                ForEach(timeViewModel.bookReports) { book in
                    
                    TimeReportCellView(colors: colors, userName: book.businessUserName, generatedDate: book.date, userPicture: book.businessUserPicture
                                   , cost: String(book.cost), status: book.status)
                    
                    .frame(height: 80)
                    
                }
                
            }
            .padding()

        }
        .edgesIgnoringSafeArea(.top)
        
        .onTapGesture {
            withAnimation(.linear) {
                isShowingDatePickerEndDate = false
                isShowingDatePickerStartDate = false
            }
        }
        
        .onAppear(perform: {
            Task {
                await timeViewModel.getIncomeReports()
                await timeViewModel.getBookings(with: "")
            }
        })
//        .task {
//
//
//        }
//
        .fullScreenCover(isPresented: $isHamburgerPresnted, content: {
            MenuHumbergerView(isPresneted: $isHamburgerPresnted, colors: colors)
                .environmentObject(profileCellViewModel)
                .environmentObject(keyboardResponder)
                .environmentObject(baseViewModel)
        })
        
 
        
        .overlay(alignment: .bottom, content: {
            if isShowingDatePickerStartDate {
                
                CustomDatePicker(isPresented: $isShowingDatePickerStartDate, date: $timeViewModel.startDate)
                    .shadow(radius: 5)
                    .environment(\.calendar, language == .persian ? .persianCalendar : .gregorianCalendar)
                    
            }
        })
        
        
        .overlay(alignment: .bottom, content: {
            if isShowingDatePickerEndDate {

                CustomDatePicker(isPresented: $isShowingDatePickerEndDate, date: $timeViewModel.endDate)
                    .shadow(radius: 5)
                    .environment(\.calendar, language == .persian ? .persianCalendar : .gregorianCalendar)
                
            }
        })

    }
    
    
    
    private func calculateDoneCount() {
        
        var doneCount = 0
        
        for day in timeViewModel.statusReports {
            
            doneCount += day.totalCost
        }
        
        
        
    }
    
    
    
    
}

struct TimeView_Previews: PreviewProvider {
    
    static var colors = ConstantColors()
    
    static var previews: some View {
        TimeView(colors: colors)
    }
}
