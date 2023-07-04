//
//  PasscodeView.swift
//  OKTime
//
//  Created by Arman Zohourian on 12/13/22.
//

import SwiftUI
import Combine
// import Introspect
public struct PasscodeField: View {
    
    
    
    
    var colors = ConstantColors()
    
    var isLoginView: Bool
    
    var maxDigits: Int = 4
    let userDefaults = UserDefaults.standard
    // it is a computed property since we need to check it from the defaults
    var isCreatingPasscode: Bool {
        if UserDefaults.standard.getPasscode() != "" {
            return false
        } else {
            return true
        }
    }
    
    @FocusState private var keyboardFocused: Bool

    
    @State var passcodeLabel = "Enter One Time Passcode"
    

    @State var pin: String = ""
    @State var repeatedPin: String = ""
    @State var shownPin: String = ""

    @State var showPin = false
    @State var isDisabled = false
    
    @Binding var isAuthenticated: Bool
    @Binding var isPresented: Bool
    
    

    
    public var body: some View {
        ScrollView {
            VStack(spacing: 40) {
                
                
                
                VStack(spacing: 20) {
                    passcodeLogo
                    Text(passcodeLabel)
                        .font(.custom("YekanBakhNoEn-Bold", size: 16))
                }
                
                
                
                
                ZStack {
                    
                    pinDots
                    backgroundField
                }
                
                .frame(width: UIScreen.screenWidth - 150)
                
                
                
                
                
                
                
                
            }
            .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight)
            .transition(.move(edge: .bottom))
            .animation(.default, value: 1)
            
        }
        .overlay(alignment: .topTrailing, content: {
            Button {
                UserDefaults.standard.setPasscodeStatus(value: false)
                isPresented.toggle()
            } label: {
                Text("Cancel")
                    .foregroundColor(colors.greenColor)
            }
            .opacity(isLoginView ? 0.0 : 1.0)
            .padding()
            
            
            

        })
        
        
        
    }
    
    private var pinDots: some View {
        HStack {
            Spacer()
            ForEach(0..<maxDigits) { index in
                //Add the recttangle
                getImageName(at: index)
                Spacer()
            }
        }
    }
    
    
    private var passcodeLogo: some View {
        
        Image("passcode-lock")
            .resizable()
            .frame(width: 150, height: 150)
        
        
    }
    
    private var backgroundField: some View {
        let boundPin = Binding<String>(get: { self.shownPin }, set: { newValue in
            
            self.shownPin = newValue

        })
        
        return TextField("", text: boundPin)
            .focused($keyboardFocused)
            .onAppear(perform: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    keyboardFocused = true
                }
            })
      
    //Using combine to keep track of the input , and perfom on it
            .onReceive(Just(shownPin), perform: { _ in
                checkInput(maxDigits)
            })
           .accentColor(.clear)
           .foregroundColor(.clear)
           .keyboardType(.numberPad)
           .disabled(isDisabled)
      
    }
    
    private var showPinStack: some View {
        HStack {
            Spacer()
        }
        .frame(height: 100)
        .padding([.trailing])
    }
    

    private func submitPin() {
        
        guard !shownPin.isEmpty else {
            showPin = false
            
            
            return
        }
        
        if shownPin.count == maxDigits {
            isDisabled = true
            
            
            if isCreatingPasscode {
                
                
                if pin == "" {
                    //fill the Repeated pin
                    passcodeLabel = "Repeat your passcode"
                    isDisabled = false
                    pin = shownPin
                    shownPin = ""
                    
                } else {
                    repeatedPin = shownPin
                    //compare them if match save if not try again
                    if repeatedPin == pin {
                        userDefaults.setPasscode(value: pin)
                        userDefaults.setPasscodeStatus(value: true)
                        isPresented = false
                        print("Passcode has been saved successfully")
                    } else {
                        repeatedPin = ""
                        shownPin = ""
                        pin = ""
                        isDisabled = false
                        passcodeLabel = "Enter one time passcode"
                        print("Passcode is not matched, Try again")
                    }
                }
                
                
                
                
            } else {
                            let savedPasscode = userDefaults.getPasscode()
                            //Check if the the passcode is matched with the one saved
                            if shownPin == savedPasscode {
                                //If matched autheticated true
                                
                                hideKeyboard()
                                
                                //Sleep since the keyaboad ruins the main view
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    isAuthenticated = true
                        
                                }
                
                            } else {
                                //If not try again
                                shownPin = ""
                                isDisabled = false
                                print("Try again")
                
                            }
            }
            

            
           
            
            
            
//            handler(pin) { isSuccess in
//                if isSuccess {
//                    print("pin matched, go to next page, no action to perfrom here")
//                } else {
//                    pin = ""
//                    isDisabled = false
//                    print("this has to called after showing toast why is the failure")
//                }
//            }
        }
        
        // this code is never reached under  normal circumstances. If the user pastes a text with count higher than the
        // max digits, we remove the additional characters and make a recursive call.
//        if !isCreatingPasscode {
//            if shownPin.count > maxDigits {
//                shownPin = String(shownPin.prefix(maxDigits))
//                submitPin()
//            }
//        }
    }
    
    private func getImageName(at index: Int) -> AnyView {
        
        //If the index is larger than the input it means the field is empty
        
        var emptyCircle: some View {
            
            ZStack {
                
                
                RoundedRectangle(cornerRadius: 10)
                        .frame(width: 15, height: 15)
                        .foregroundColor(colors.blueColor)
                
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 13, height: 13)
                    .foregroundColor(Color.white)
                
            }
            

        }
        
        
        var filledCircle: some View {
            RoundedRectangle(cornerRadius: 10)
                    .frame(width: 15, height: 15)
                    .foregroundColor(colors.blueColor)
        }

        
        if index >= self.shownPin.count {
            
            
            return AnyView(emptyCircle)
                        
    
            
        }
        
        return AnyView(filledCircle)
    }
    
    private func checkInput(_ upper: Int) {
        
        if shownPin.count == maxDigits {
            submitPin()
        }
    }
    
}

extension String {
    
    var digits: [Int] {
        var result = [Int]()
        
        for char in self {
            if let number = Int(String(char)) {
                result.append(number)
            }
        }
        
        return result
    }
    
}

extension Int {
    
    var numberString: String {
        
        guard self < 10 else { return "0" }
        
        return String(self)
    }
}
