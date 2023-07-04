//
//  CustomTabBarContainer.swift
//  Spotify Clone
//
//  Created by Arman Zohourian on 5/9/22.
//

import SwiftUI

struct CustomTabBarContainer<Content:View>: View {
    
    @State var isShowingSetShift = false
    
    @Binding var selectedTab: TabBarItem
    
    @EnvironmentObject var todayTaskViewModel : TodayTaskViewModel
    
    @EnvironmentObject var calendarViewModel: CalendarViewModel
    
    @EnvironmentObject var keyboardResponder : KeyboardResponder
    
    @EnvironmentObject var contactViewModel: ContactsViewModel
    
    let content: Content
    
    @State var tabs : [TabBarItem] = []

    init(selection: Binding<TabBarItem>, @ViewBuilder content: () -> Content) {
        
        self._selectedTab = selection
        self.content = content()
        
    }
    
    var body: some View {
  
        
        
        ZStack {
            VStack(spacing: -2) {
                
                ZStack(alignment: .bottom) {
                    content
                        .sheet(isPresented: $isShowingSetShift) {
                            ScheduleView(colors: ConstantColors(), isPresented: $isShowingSetShift)
                                .environmentObject(contactViewModel)
                                .environmentObject(todayTaskViewModel)
                                .environmentObject(calendarViewModel)
                                .environmentObject(keyboardResponder)
                        }
                }
                .onPreferenceChange(TabBarItemsPrefrenceKey.self) { value in
                    self.tabs = value
                }
                
                CustomTabBarView(selectedTab: $selectedTab, isShowingSheet: $isShowingSetShift, tabs: tabs)
                    .frame(width: UIScreen.screenWidth)
                    .edgesIgnoringSafeArea(.bottom)
                
            }

        }

    }
}
