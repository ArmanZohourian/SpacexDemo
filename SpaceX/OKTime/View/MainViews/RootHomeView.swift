//
//  HomeView.swift
//  OKTime
//
//  Created by ok-ex on 10/10/22.
//

import SwiftUI

struct RootHomeView: View {
    
    @State var selection : String = "graph"
    
    @State var selectedTab: TabBarItem = TabBarItem(image: "empty-wallet", foregroundColor: Color.gray, selectedImage: "empty-wallet-selected")
    
    @StateObject var contactObject = ContactsViewModel()
    
    var colors: ConstantColors
    
    @StateObject var calendarViewModel = CalendarViewModel()
    
    @StateObject var todayTaskViewModel = TodayTaskViewModel()
    
    @StateObject var profileCellViewModel = ProfileCellViewModel()
    
    @StateObject var timeViewModel: TimeViewModel = TimeViewModel()
    
    @ObservedObject var keyboardResponder = KeyboardResponder()
    
    @EnvironmentObject var baseViewModel: BaseViewModel
    
    var body: some View {
        
        CustomTabBarContainer(selection: $selectedTab) {
            
            AddContactView(colors: colors)
                .environmentObject(contactObject)
                .environmentObject(keyboardResponder)
                .environmentObject(baseViewModel)
                .environmentObject(profileCellViewModel)
                .tabBarItem(tab: TabBarItem(image: "profile-user", foregroundColor: Color.gray, selectedImage: "profile-user-selected"), selection: $selectedTab)
            
            TimeView(colors: colors)
                .environmentObject(baseViewModel)
                .environmentObject(keyboardResponder)
                .environmentObject(profileCellViewModel)
                .tabBarItem(tab: TabBarItem(image: "empty-wallet", foregroundColor: Color.gray, selectedImage: "empty-wallet-selected"), selection: $selectedTab)
            
            TodaysTaskView(colors: colors)
                .environmentObject(todayTaskViewModel)
                .environmentObject(calendarViewModel)
                .environmentObject(keyboardResponder)
                .environmentObject(baseViewModel)
                .environmentObject(profileCellViewModel)
                .environmentObject(timeViewModel)
                .tabBarItem(tab: TabBarItem(image: "calendar", foregroundColor: Color.gray, selectedImage: "calendar-selected"), selection: $selectedTab)

            HomeView(colors: colors)
                .environmentObject(keyboardResponder)
                .environmentObject(baseViewModel)
                .environmentObject(profileCellViewModel)
                .environmentObject(timeViewModel)
                .tabBarItem(tab: TabBarItem(image: "graph", foregroundColor: Color.blue, selectedImage: "graph-selected"), selection: $selectedTab)
            
        }
        
        
        .environmentObject(calendarViewModel)
        .environmentObject(contactObject)
        .environmentObject(todayTaskViewModel)
        .environmentObject(keyboardResponder)
        .ignoresSafeArea(.keyboard, edges: .bottom)

    }
}

struct Previews_RootHomeView_Previews: PreviewProvider {
    
    static var constantColors = ConstantColors()
    
    static var previews: some View {
        RootHomeView(colors: constantColors)
    }
}
