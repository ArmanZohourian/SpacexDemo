//
//  ReportCellView.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/24/22.
//

import SwiftUI

struct ReportCellView: View {
    
    var colors: ConstantColors
    var userName: String
    var generatedDate: String
    var cost: String
    var status: String
    
    
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
                            HStack {
                                Text("تومان")
                                    .font(.system(size: 12))
                                Text(cost)
                                    .font(.system(size: 14))
                                    .foregroundColor(generatedColor)
                            }
                        }
                    }
                    Spacer()
                    //Name and time shift
                    VStack(alignment: .trailing) {
                        Text(userName)
                            .foregroundColor(colors.blueColor)
                            .font(.system(size: 17, weight: .medium))
                        
                        //Time shifts
                        HStack {
                            
                            Text(generatedDate)
                            Image("calendar")
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
                        Rectangle()
                            .foregroundColor(generatedColor)
                            .frame(width: 45,height: 45)
                            .cornerRadius(30)
                        
                        Text(statustText)
                            .foregroundColor(generatedColor)
                            .font(.system(size: 10))
                        
                    }
                }
            }
            .background(colors.cellColor)
            .frame(width: UIScreen.screenWidth - 30)
            .frame(height: 120)
        }
    }
    
    
    private func generateStatusText(with status: String) -> String {
        
        if status == "RESERVED" {
            return "در انتظار انجام"
        } else if status == "DONE" {
            return "انجام شده"
        } else if status == "IN_PROGRESS" {
            return "در حال انجام"
        }  else if status == "CANCEL" {
            return "لغو شده"
        }
        
        return ""
    }
    
    
    private func generateColor(with status: String) -> Color {
        
        if status == "RESERVED" {
            return colors.yellowColor
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
    
    

//struct ReportCellView_Previews: PreviewProvider {
//    static var previews: some View {
//        ReportCellView()
//    }
//}
