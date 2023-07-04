//
//  QueueCellView.swift
//  OKTime
//
//  Created by Arman Zohourian on 10/31/22.
//

import SwiftUI


struct QueueCellView: View {
    
    @AppStorage("language")
    
    private var language = LocalizationService.shared.language
    
    var colors : ConstantColors = ConstantColors()
    
    var time: String
    var cost: String
    var userName: String
    var startTime: String
    var endTime: String
    var duration: String
    var status: String
    var serviceName: String
    var userImage: String?
    
    let screenWidthSize = Int(UIScreen.screenWidth) - 30
    
    @State var isTimerActive = false
    
    var generatedColor : Color {
        generateColor(with: status)
    }
    
    var statustText: String {
        generateStatusText(with: status)
    }
    
    var generatedStartTime: String {
        generateTimeFormat(with: startTime)
    }
    
    var generatedEndTime: String {
        generateTimeFormat(with: endTime)
    }
    
    
    var imagePlaceholder: some View {
        Rectangle()
            .foregroundColor(generatedColor)
            .frame(width: 45,height: 45)
            .blur(radius: 5 , opaque: !isInProgress(with: status))
            .clipShape(Circle())
    }
    
    
//    var scheduleStatus = ScheduleStatus.done
    
    var body: some View {
        VStack {
            
            HStack {
                
                //Price , Edit Stack
                HStack {
                    VStack(alignment: .leading) {
                        HStack {
                            
                            
                            Text(duration)
                                .foregroundColor(colors.moderateGray)
                                .font(.custom("YekanBakhNoEn-Regular", size: 12))
                                
                                .foregroundColor(colors.lightGrayColor)
                            Image("timer-shift")
                                .resizable()
                                .frame(width: 20, height: 20)
                        }
                        .padding(.top)
                        Spacer()
                        HStack {
                            
                            Text("toman".localized(language))
                                .font(.custom("YekanBakhNoEn-Regular", size: 12))
                            
                            
                            Text(cost)
                                .font(.custom("YekanBakhNoEn-SemiBold", size: 14))
                                .foregroundColor(generatedColor)
                        }
                    }
                }
                Spacer()
                //Name and time shift
                VStack(alignment: .trailing) {
                    
                    
                    Text(userName)
                        .foregroundColor(colors.blueColor)
                        .font(.custom("YekanBakhNoEn-Bold", size: 16))
                    
                    //Time shifts
                    HStack {
                    
                        Text(generatedEndTime)
                            .font(.custom("YekanBakhNoEn-Regular", size: 12))
                        
                        Text("to_hour".localized(language))
                            .font(.custom("YekanBakhNoEn-Regular", size: 12))
                        
                        Text(generatedStartTime)
                            .font(.custom("YekanBakhNoEn-Regular", size: 12))
                        
                        
                        Image("clock-standby")
                            .resizable()
                            .frame(width: 20, height: 20)
                        
                    }
                    .foregroundColor(Color.gray)
                    .font(.system(size: 14))
                }
                //Profile Picture, State
                VStack {
                    //MARK: TODO
                    //Add a Zstack to show time, and the foregncolor variable for each state
                    imagePlaceholder
                        .overlay(alignment: .center) {
                            TimeCountView(isTimerRunning: $isTimerActive)
                                .opacity(isInProgress(with: status) ? 1.0 : 0.0)
                        }
                        .overlay(content: {
                            if let cellImage = userImage {
                                AsyncImage(url: URL(string: APIConstanst.imageBaseUrl + cellImage)) { image in
                                    
                                    
                                    image
                                        .resizable()
                                        .frame(width: 42, height: 42)
                                        .clipShape(Circle())
                                    
                                    
                                } placeholder: {
                                    
                                    imagePlaceholder
                                }
                            }
                        })
                        .onAppear {
                            isInProgress(with: status)
                        }
                    
                        
                    
                    Text(statustText)
                        .foregroundColor(generatedColor)
                        .font(.custom("YekanBakhNoEn-Regular", size: 12))

                }
            }
              
            //MARK: Line seperator
            HStack {
                ForEach(0 ..< 30) { _ in
                    Text("-")
                        .foregroundColor(colors.grayColor)
                }
            }
            .frame(height: 5)
            

            HStack {
                //MARK: ForEach should be assigned
                EmptyView()
                Spacer()
                Text(serviceName)
                    .frame(width: 70,height: 30)
                    .font(.custom("YekanBakhNoEn-Regular", size: 12))
                    .background(colors.lightGrayColor)
                    .cornerRadius(10)
 
            }
        }
        .padding([.trailing,.leading])
        .background(colors.cellColor)
        .frame(width: UIScreen.screenWidth - 30)
        .frame(height: 120)
        
        
    }
    
    
    
    
    //MARK: Functions
    
    private func generateColor(with status: String) -> Color {
        
        if status == "RESERVED" {
            return colors.blueColor
        } else if status == "DONE" {
            return colors.greenColor
        } else if status == "IN_PROGRESS" {
            return colors.yellowColor
        }  else if status == "CANCEL" {
            return colors.redColor
        }
        return colors.blueColor
    }
    
    private func generateStatusText(with status: String) -> String {
        
        if status == "RESERVED" {
            return "reserved_waiting".localized(language)
        } else if status == "DONE" {
            return "reserved_done".localized(language)
        } else if status == "IN_PROGRESS" {
            return "reserved_in_progress".localized(language)
        }  else if status == "CANCEL" {
            return "reserved_canceled".localized(language)
        }
        
        return ""
    }
    
    private func generateTimeFormat(with time: String) -> String {
        
        let string = String(time.dropLast())
        let secondString = String(string.dropLast())
        let finalString = String(secondString.dropLast())
        
        return finalString
        
    }
    
    private func isInProgress(with status: String) -> Bool {
        
        if status == "IN_PROGRESS" {
            isTimerActive = true
            return true
            
        } else {
            DispatchQueue.main.async {
                self.isTimerActive = false
            }
            
            return false
            
        }
        
    }
    
    
    
}

enum ScheduleStatus {
    
    case RESERVED
    case CANCELED
    case DONE
    case INPROGRESS
    
}




//struct QueueCellView_Previews: PreviewProvider {
//    static var previews: some View {
//        QueueCellView()
//    }
//}
