//
//  DailyShiftHamburger.swift
//  OKTime
//
//  Created by Arman Zohourian on 1/5/23.
//

import SwiftUI

struct DailyShiftHamburger: View {
    
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var keyboardResponder : KeyboardResponder
    
    @State var isShowingNewShiftViewPopup = false
    @State var isShowingEditShift = false
    
   
    
    
    
    @StateObject var getShiftViewModel = GetShiftViewModel()
    @StateObject var addDailyShiftViewModel = AddDailyShiftViewModel()
    
    var language = LocalizationService.shared.language
    var colors: ConstantColors
    
    var body: some View {
        dailyShift
            
    }
    
    
    var dailyShift: some View {
        GeometryReader { geometry in
            VStack {
                
                CustomNavigationTitle(name: "daily_shifts".localized(language), logo: "daily-shift", colors: colors)
                    .foregroundColor(Color.white)
                
                //MARK: Daily Shift
                Button {
                    //Bring up New Shift pop up
                    isShowingNewShiftViewPopup = true
                    hideKeyboard()
                } label: {
                    AddButtonView(buttonText: "shift_add_shift_button".localized(language), colors: colors)
                }

                
                //Current Shifts
            
                VStack {
                    List(getShiftViewModel.shiftDetails) { shift in
                        ShiftCellHamburgerView(shift: shift, colors: colors)
                            .swipeActions(edge: .trailing, allowsFullSwipe: false, content: {
                                Button {
                                    //Delete daily shift
                                    Task  {
                                        await getShiftViewModel.deleteShift(with: shift)
                                        await getShiftViewModel.getShiftDetails()
                                    }
                                    
                                    //Fetch new shifts
                                } label: {
                                    VStack {
                                        Text("delete".localized(language))
                                            .font(.custom("YekanBakhNoEn-Regular", size: 10))
                                        
                                        Image("trash")
                                            .resizable()
                                            .frame(width: 20, height: 20, alignment: .bottom)
                                    }
                                }
                                .tint(.red)
                                
                                Button {
                                    setCurrentShift(with: shift)
                                } label: {
                                    Text("edit".localized(language))
                                        .font(.custom("YekanBakhNoEn-Regular", size: 10))
                                    
                                    Image("edit-button")
                                        .resizable()
                                        .frame(width: 20, height: 20, alignment: .bottom)
                                }
                                .tint(.orange)


                            })
                            .environment(\.defaultMinListRowHeight, geometry.size.height / 10)
                            
                            .listRowSeparator(.hidden)
                    }
                    .frame(width: UIScreen.screenWidth)
                    .listStyle(.plain)
                    
                }
                .padding()
                

                
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            
        }
        .edgesIgnoringSafeArea(.top)
        
        .task {
            await getShiftViewModel.getShiftDetails()
        }
        
        
        

        
        .popup(isPresented: $isShowingEditShift, view: {
            EditShiftHamburgerView(colors: colors, isPresented: $isShowingEditShift)
                        .environment(\.layoutDirection, language.rawValue == "en" ? .rightToLeft : .leftToRight)
                        .environmentObject(getShiftViewModel)
                        .environmentObject(keyboardResponder)
        }, customize: {
            $0
                .backgroundColor(.black.opacity(0.4))
                .position(.bottom)
                .type(.toast)
                .closeOnTap(false)
        })
        
        
        .popup(isPresented: $isShowingNewShiftViewPopup, view: {
            
            NewShiftHamburgerView(isPresneted: $isShowingNewShiftViewPopup, colors: colors, isPresented: $isShowingNewShiftViewPopup)
                .environment(\.layoutDirection, language.rawValue == "en" ? .rightToLeft : .leftToRight)
                .environmentObject(getShiftViewModel)
                .environmentObject(keyboardResponder)
        }, customize: {
            $0
                .backgroundColor(.black.opacity(0.4))
                .closeOnTap(false)
                .type(.toast)
                .position(.bottom)
        })
        
        .environment(\.layoutDirection, language == .persian ? .leftToRight : .rightToLeft)
        .navigationBarBackButtonHidden()
        .navigationBarItems(leading: NavigationItemsView(title: "", isBackButtonHidden: false))
        
    }
    
    
    private func setCurrentShift(with shift: ShiftDetail) {
        
        getShiftViewModel.currentShift = shift
        isShowingEditShift = true
    }
    
    
}
