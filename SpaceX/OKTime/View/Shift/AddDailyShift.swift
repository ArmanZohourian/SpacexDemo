//
//  AddDailyShift.swift
//  OKTime
//
//  Created by Arman Zohourian on 1/5/23.
//

import SwiftUI
import ExytePopupView

struct AddDailyShift: View {
    
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var isShowingNewShiftViewPopup = false
    
    @State var isShowingEditShift = false
    
    var colors: ConstantColors
    
    var language = LocalizationService.shared.language
    
    @EnvironmentObject var getShiftViewModel : GetShiftViewModel
    @EnvironmentObject var addDailyShiftViewModel: AddDailyShiftViewModel
    @EnvironmentObject var keyboardResponder: KeyboardResponder
    @EnvironmentObject var baseViewModel: BaseViewModel
    
    
    var body: some View {
        dailyShift
            .task {
                await getShiftViewModel.getShiftDetails()
            }
    }
    
    
    
    var dailyShift: some View {
        GeometryReader { geometry in
            VStack {
                
                CustomFlowView(colors: colors, flowDescription: "add_your_daily_shifts".localized(language), flowImage: "user-daily-shift-flow", flowBgImage: "addshift-flow")
                
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
                    List(addDailyShiftViewModel.shiftDetails) { shift in
                        ShiftCellHamburgerView(shift: shift, colors: colors)
                            .swipeActions(edge: .trailing, allowsFullSwipe: false, content: {
                                Button {
                                    //Delete daily shift
                                    Task  {
                                        await addDailyShiftViewModel.deleteShift(with: shift)
                                        await addDailyShiftViewModel.getShiftDetails()
                                    }
                                    
                                    //Fetch new shifts
                                } label: {
                                    VStack {
                                        Text("Delete")
                                        Image("trash")
                                            .resizable()
                                            .frame(width: 20, height: 20, alignment: .bottom)
                                    }
                                }
                                .tint(.red)
                                
                                Button {
                                    setCurrentShift(with: shift)
                                } label: {
                                    Text("Edit")
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
                

                NavigationLink(destination:
                                SuccessRegisteration(colors: colors)
                                    .environmentObject(baseViewModel)
                )
                    {
                        GreenFunctionButton(buttonText: "submit".localized(language), isAnimated: .constant(false))
                            .frame(width: UIScreen.screenWidth - 35 , height: 40)
                    }
                    .disabled(getShiftViewModel.isAllowedToPass)
                    .onTapGesture {
                        getShiftViewModel.checkShiftDetails()
                    }
                
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        
        
        .edgesIgnoringSafeArea(.top)
        
        .popup(isPresented: $isShowingEditShift, view: {
            
            NewShiftEditView(colors: colors, isPresented: $isShowingEditShift)
                          .environment(\.layoutDirection, language.rawValue == "en" ? .rightToLeft : .leftToRight)
                          .environmentObject(getShiftViewModel)
                          .environmentObject(addDailyShiftViewModel)
                          .environmentObject(keyboardResponder)
        }, customize: {
            $0
                .position(.bottom)
                .type(.toast)
                .backgroundColor(.black.opacity(0.4))
                .closeOnTap(false)
            
        })
        
        
        .popup(isPresented: $isShowingNewShiftViewPopup, view: {
            
            NewShiftView(isPresneted: $isShowingNewShiftViewPopup, colors: colors, isPresented: $isShowingNewShiftViewPopup)
                .environment(\.layoutDirection, language.rawValue == "en" ? .rightToLeft : .leftToRight)
                .environmentObject(getShiftViewModel)
                .environmentObject(addDailyShiftViewModel)
                .environmentObject(keyboardResponder)
        }, customize: {
            $0
                .type(.toast)
                .position(.bottom)
                .closeOnTap(false)
                .backgroundColor(.black.opacity(0.4))
        })

        .environment(\.layoutDirection, language == .persian ? .leftToRight : .rightToLeft)
        .navigationBarBackButtonHidden()
        .navigationBarItems(leading: NavigationItemsView(title: "daily_shifts".localized(language), isBackButtonHidden: false))
        
    }
    
    
    private func setCurrentShift(with shift: ShiftDetail) {
        
        getShiftViewModel.currentShift = shift
        isShowingEditShift = true
    }
    
    
}
