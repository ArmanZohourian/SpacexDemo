//
//  BusinessInformationHamburgerView.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/16/22.
//

import SwiftUI

struct ReserveReportView: View {
    
    
    @AppStorage("language")
    
    private var language = LocalizationService.shared.language
    
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var colors: ConstantColors
    @StateObject var getReportsViewModel = GetReportsViewModel()
    @StateObject var getReportBookingViewModel = GetReportBookingViewModel()
    
    
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
        
        GeometryReader { geometry in
            
            ScrollView {
                VStack {
                    
                    
                        VStack {
                            
                            
                            CustomNavigationTitle(name: "reserve_reports".localized(language), logo: "clock", colors: colors)
                            
                            HStack {
                                
                                
                                summaryCellView(logo: "clock-gray", name: "average_reports_duration".localized(language), value: String(getReportsViewModel.report.averageTime))

                                
                                Divider()
                                    .frame(width: 0.5)
                                    .background(colors.whiteColor)
                                    .padding([.top, .bottom])
                                    
                                Spacer()
                                
                                summaryCellView(logo: "calendar-tick", name: "done_reserves".localized(language), value: String(getReportsViewModel.report.totalDone))

                                Divider()
                                    .frame(width: 0.5)
                                    .background(colors.whiteColor)
                                    .padding([.top, .bottom])
                                
                                
                                Spacer()
                                
                                
                                summaryCellView(logo: "calendar-remove", name: "canceled_reserves".localized(language), value: String(getReportsViewModel.report.totalCancel))

                
                            }

                        }
                        .padding([.leading, .trailing])
                        .foregroundColor(Color.white)
                        .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight / 3)
                        .background(colors.blueColor)
                        .cornerRadius(10, corners: [.bottomLeft,.bottomRight])
                    
                    
                    

                    ScrollView  {
                        ForEach(getReportBookingViewModel.taskReports) { task in
                            
                            
                            QueueCellView(colors: colors,
                                          time: "Some time" ,
                                          cost: String(task.cost),
                                          userName: task.businessUserName,
                                          startTime: task.start,
                                          endTime: task.end,
                                          duration: haveDuration(with: task) ? getDurationWith(actualEnd: task.actualEnd!, actualStart: task.actualStart!) : "" ,
                                          status: task.status, serviceName: task.serviceName, userImage: task.businessUserPicture)
                            
                            .padding()
                            
                            
                        }
                    }
                    .padding(.top)

                    Spacer()

                }
            }
            .task {
                await getReportsViewModel.getReports()
                await getReportBookingViewModel.getReportBooking()
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
        .edgesIgnoringSafeArea([.top,.bottom])
  
    }
    
    
    
    
    //MARK: Functionalities
    
    
    
    private func haveDuration(with task: Book) -> Bool {
        
        if task.actualStart != nil && task.actualEnd != nil {
            return true
        } else {
            return false
        }
        
    }
    
    private func getDurationWith(actualEnd: String, actualStart: String) -> String {
        
        let intActualEnd = calculateTimeStamp(with: actualEnd)
        let intActualStart = calculateTimeStamp(with: actualStart)
        
        let duration = intActualEnd - intActualStart
        let finalDurationStr = calculateDateFromTimeStampStr(with: duration)
        
        return finalDurationStr
        
    }
    
    
    private func calculateTimeStamp(with date: String) -> Int {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        let calculatedDate = dateFormatter.date(from: date)
        let timeStamp : TimeInterval = calculatedDate!.timeIntervalSince1970
        let calculatedTs = Int(timeStamp)
        
        return calculatedTs
        
        
        
    }
    
    private func calculateDateFromTimeStampStr(with timeStamp: Int) -> String {
        
        let date = Date(timeIntervalSince1970: Double(timeStamp))
        let df = DateFormatter()
        df.dateFormat = "HH:mm:ss"
        let convertedDate = df.string(from: date)
        return convertedDate
    }
}




//struct BusinessInformationHamburgerView_Previews: PreviewProvider {
//    static var previews: some View {
//        BusinessInformationHamburgerView(colors: ConstantColors())
//    }
//}
