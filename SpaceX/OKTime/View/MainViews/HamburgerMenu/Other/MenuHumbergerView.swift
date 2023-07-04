//
//  MenuHumbergerView.swift
//  OKTime
//
//  Created by Arman Zohourian on 10/16/22.
//

import SwiftUI

struct MenuHumbergerView: View {
    
    @AppStorage("language")
    
    private var language = LocalizationService.shared.language
    
    @Binding var isPresneted: Bool
    
    @State var isProfileActive = false
    
    @StateObject var loginViewModel = LoginViewModel()
    
    @EnvironmentObject var keyboardResponder : KeyboardResponder
    
    @EnvironmentObject var baseViewModel: BaseViewModel
    
    @EnvironmentObject var profileCellViewModel: ProfileCellViewModel
    
    
    var colors: ConstantColors
    var body: some View {
        
        NavigationView {
            
            VStack {
                
                
                ProfileCellHamburgerView(isPresented: $isPresneted)
                    .environmentObject(profileCellViewModel)
                    .padding([.leading, .trailing], 1)
                    .environment(\.layoutDirection, .leftToRight)
                    
                
                //MARK: All should be assinged as Navigation Link
                Divider()
                    .background(colors.grayColor)
                VStack(spacing: 10) {
                    
                    NavigationLink {
                        
                        ProfileDetailsView(colors: colors)
                            .environmentObject(keyboardResponder)
                            .environmentObject(profileCellViewModel)
                            .environment(\.layoutDirection, language.rawValue == "en" ? .rightToLeft : .leftToRight)
                        
                    } label: {
                        HaburgerMenuCellView(cellText: "profile_details".localized(language), cellIcon: "profile", colors: colors)
                    }
                    
                    NavigationLink {
                        ReserveReportView(colors: colors)
                            .environment(\.layoutDirection, language.rawValue == "en" ? .rightToLeft : .leftToRight)
                    } label: {
                        HaburgerMenuCellView(cellText: "reserve_reports".localized(language), cellIcon: "clock", colors: colors)
                    }
                    
                    NavigationLink {
                        BussinessInformationHamburgerView(colors: colors)
                            .environment(\.layoutDirection, language.rawValue == "en" ? .rightToLeft : .leftToRight)
                            .environmentObject(loginViewModel)
                            .environmentObject(keyboardResponder)
                        
                    } label: {
                        HaburgerMenuCellView(cellText: "business_information".localized(language), cellIcon: "briefcase", colors: colors)
                    }

                    NavigationLink {
                        
                        AddShiftHaburgerView(colors: colors)
                            .environment(\.layoutDirection, language.rawValue == "en" ? .rightToLeft : .leftToRight)
                            .environmentObject(keyboardResponder)
                        
                    } label: {
                        
                        HaburgerMenuCellView(cellText: "shifts".localized(language), cellIcon: "timer", colors: colors)
                    }
                    
                    
                    NavigationLink {
                        
                        DailyShiftHamburger(colors: colors)
                            .environmentObject(keyboardResponder)
                            
                        
                    } label: {
                        
                        HaburgerMenuCellView(cellText: "daily_shifts".localized(language), cellIcon: "daily-shift", colors: colors)
                    }
                    
                    
                    NavigationLink {
                        
                        ServicesView(colors: colors)
                            .environment(\.layoutDirection, language.rawValue == "en" ? .rightToLeft : .leftToRight)
                            .environmentObject(keyboardResponder)
                    } label: {
                        HaburgerMenuCellView(cellText: "services".localized(language), cellIcon: "service", colors: colors)
                    }

                    
                    NavigationLink {
                        SettingView(colors: colors)
                            .environment(\.layoutDirection, language.rawValue == "en" ? .rightToLeft : .leftToRight)
                            .environmentObject(baseViewModel)
                    } label: {
                        HaburgerMenuCellView(cellText: "settings".localized(language), cellIcon: "setting-green", colors: colors)
                    }
                    
                    
                }
                .frame(width: UIScreen.screenWidth - 20)
                Spacer()
           
                    Divider()
                        .background(Color.gray)
                    Text("Version 1.0")
                        .foregroundColor(Color.white)
                        .padding(.bottom, 20)
                

            }
            .background(ConstantColors().blueColor)

        }
        
        .task {
            await profileCellViewModel.getUserInfo()
        }

    }
}

//struct MenuHumbergerView_Previews: PreviewProvider {
//    static var previews: some View {
//        MenuHumbergerView()
//    }
//}
