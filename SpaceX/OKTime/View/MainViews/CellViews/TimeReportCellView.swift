//
//  TimeReportCellView.swift
//  OKTime
//
//  Created by Arman Zohourian on 12/1/22.
//

import SwiftUI

struct TimeReportCellView: View {
    
    var colors: ConstantColors
    var userName: String
    var generatedDate: String
    var userPicture: String?
    var cost: String
    var status: String
    var language = LocalizationService.shared.language
    
    
    private var dateFormatter: DateFormatter {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: LocalizationService.shared.language == .persian ? "Fa" : "En")
        dateFormatter.dateFormat = "yyyy/MM/dd"
        return dateFormatter
        
    }
    
    
    private var date: Date {
        
        let dateFormmater = DateFormatter()
        return dateFormmater.date(from: generatedDate) ?? Date()
        
    }
    
    
    var generatedColor : Color {
        generateColor(with: status)
    }
    
    var statustText: String {
        generateStatusText(with: status)
    }
    
    
    var body: some View {
        
        VStack {
            
            HStack {
                
                //Price , Edit Stack
                HStack {
                    VStack(alignment: .leading) {
                        HStack {
                            VStack(alignment: .leading) {
                                
                                HStack {
                                    Text("toman".localized(language))
                                        .font(.custom("YekanBakhNoEn-Regular", size: 12))
                                    Text(cost)
                                        .font(.custom("YekanBakhNoEn-SemiBold", size: 14))
                                        .foregroundColor(generatedColor)
                                }
                                
                                Text(statustText)
                                    .foregroundColor(generatedColor)
                                    .font(.custom("YekanBakhNoEn-Regular", size: 10))
                                    .frame(width: 70, height: 20, alignment: .center)
                                    .background(generatedColor.opacity(0.1))
                            }
                            
                           
                        }
                    }
                    Spacer()
                    //Name and time shift
                    VStack(alignment: .trailing) {
                        Text(userName)
                            .foregroundColor(colors.blueColor)
                            .font(.custom("YekanBakhNoEn-SemiBold", size: 14))
                        
                        //Time shifts
                        HStack {
                            
                            Text("\(date, formatter: dateFormatter)")
                                .font(.custom("YekanBakhNoEn-Regular", size: 14))
                                
                            Image("calendar")
                                .resizable()
                                .frame(width: 20, height: 20)
                            
                        }
                        .foregroundColor(Color.gray)
                        .font(.system(size: 14))
                    }
                    //Profile Picture, State
                    
                    if let profileImage = userPicture {
                        ZStack {
                            //MARK: TODO
                            //Add a Zstack to show time, and the foregncolor variable for each state
                            Circle()
                                .foregroundColor(generatedColor)
                                .frame(width: 45,height: 45)

                            AsyncImage(url: URL(string: APIConstanst.imageBaseUrl + profileImage)) { image in
                                image
                                    .resizable()
                                    .clipShape(Circle())
                                    .frame(width: 40,height: 40)
                            } placeholder: {
                                Circle()
                                    .foregroundColor(generatedColor)
                                    .frame(width: 45,height: 45)
                            }

                            
                        }
                    } else {
                        Circle()
                            .foregroundColor(generatedColor)
                            .frame(width: 45,height: 45)
                    }
                   
                }
                .padding([.top, .bottom])
            }
            .background(colors.cellColor)
            .frame(width: UIScreen.screenWidth - 30)
            .frame(height: 120)
        }
    }
    
    
    private func generateStatusText(with status: String) -> String {
        
        if status == "RESERVED" {
            return "reserved".localized(language)
        } else if status == "DONE" {
            return "reserved_done".localized(language)
        } else if status == "IN_PROGRESS" {
            return "reserved_in_progress".localized(language)
        }  else if status == "CANCEL" {
            return "reserved_canceled".localized(language)
        }
        
        return ""
    }
    
    
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
    
    
    
    
}

//struct TimeReportCellView_Previews: PreviewProvider {
//    static var previews: some View {
//        TimeReportCellView()
//    }
//}
