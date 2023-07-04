//
//  SettingView.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/21/22.
//

import SwiftUI
import LocalAuthentication

struct SettingView: View {
    
    @AppStorage("language", store: .standard) var defaultLanguage = "English"
    
    @AppStorage("calendar", store: .standard) var calendar = "Jalali"
    
    
    
    var language = LocalizationService.shared.language
    
    var calendarType = LocalizationService.shared.calendarType
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @EnvironmentObject var baseViewModel: BaseViewModel
    
    var colors: ConstantColors
    
    
    @State var isPasscodeActivated = UserDefaults.standard.getPasscodeStatus()
    @State var isBiometricActivated = UserDefaults.standard.getBiometricStatus()
    
    @State var isShowingLanguagePicker = false
    @State var isShowingCalendarPicker = false
    @State var isShowingPasscodeSheet = false
    
    
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
    //Based on the available biometric
    var biometricView: some View {
        
        
        if isFaceIdAvailable {
            return BiometricCellView(isActivated: $isBiometricActivated, logo: "scan-bio", name: "faceId".localized(language), colors: colors, type: .faceId, isShowingPasscodeSheet: $isShowingPasscodeSheet)
        } else {
            return BiometricCellView(isActivated: $isBiometricActivated, logo: "finger-bio", name: "fingerprint".localized(language), colors: colors, type: .touchId, isShowingPasscodeSheet: $isShowingPasscodeSheet)
        }
        
    }

    var body: some View {
        
        GeometryReader { geometry in
            
                ScrollView {
                    
                        VStack {
                            
                                
                            CustomNavigationTitle(name: "settings".localized(language), logo: "setting-green", colors: colors)
                                .foregroundColor(colors.whiteColor)
                    
                            CustomLanguagePickerView(colors: colors)
                                .onTapGesture {
                                    withAnimation {
                                        isShowingLanguagePicker.toggle()
                                        isShowingCalendarPicker = false
                                    }
                                }
                            
                            CustomCalendarPickerView(colors: colors)
                                .onTapGesture {
                                    withAnimation {
                                        isShowingCalendarPicker.toggle()
                                        isShowingLanguagePicker = false
                                    }
                                }
                            
                            BiometricCellView(isActivated: $isPasscodeActivated, logo: "lock-bio", name: "pincode".localized(language), colors: colors, type: .passcode, isShowingPasscodeSheet: $isShowingPasscodeSheet)
                            
                            //Either FaceId or TouchId
                            biometricView
                            
                            Button {
                                
                                UserDefaults.standard.erasePasscode()
                                UserDefaults.standard.setPasscodeStatus(value: false)
                                UserDefaults.standard.removeToken()
                                baseViewModel.isLoggedIn = false
                                baseViewModel.appState = UUID()
                                
                                
                            } label: {
                                LogoutCell(colors: colors, logo: "logout", name: "logout".localized(language))
                            }
        
                        }
                }
        }
        
        //Language picker overlay
        .overlay(alignment: .bottom) {
            
            if isShowingLanguagePicker {
                CustomLanguagePicker(isPresented: $isShowingLanguagePicker, selectedValue: "setting_language".localized(language), selectionTitle: "language".localized(language), options: ["English", "فارسی"])
            }
            
        }
        
        //Calendar picker overlay
        .overlay(alignment: .bottom) {
            
            if isShowingCalendarPicker {
                
                CustomCalendarPicker(isPresented: $isShowingCalendarPicker, selectedValue: calendarTypeEvaluation(type: calendarType.rawValue) , selectionTitle: "calendar".localized(language), options: ["jalali".localized(language), "gregorian".localized(language)])

            }
            
        }
        
        .fullScreenCover(isPresented: $isShowingPasscodeSheet, content: {
            PasscodeField(isLoginView: false, isAuthenticated: .constant(true), isPresented: $isShowingPasscodeSheet)
        })
        .edgesIgnoringSafeArea([.top,.bottom])
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)

    }
    
    
    //Checking if the FaceId or TouchId is the biometric
    private var isFaceIdAvailable: Bool {
        
        let context = LAContext()
        var error: NSError?
        
        
        context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error)
        switch context.biometryType {
        case .faceID:
            return true
        case .touchID:
            return false
        case .none:
            return false
            
        default:
            break
        }
        return false
    }
    
    private func calendarTypeEvaluation(type: String) -> String {
        
        switch type {
            
        case "Gregorian":
            return "gregorian".localized(language)
            
        case "Jalali":
            return "jalali".localized(language)
            
        default:
            return ""
            
        }
        
    }
    
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView(colors: ConstantColors())
    }
}
