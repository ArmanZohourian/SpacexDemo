//
//  CustomTabBarView.swift
//  Spotify Clone
//
//  Created by Arman Zohourian on 5/8/22.
//

import SwiftUI

struct CustomTabBarView: View {
    
    @Binding var selectedTab: TabBarItem
    @Binding var isShowingSheet: Bool
    
   

    let tabs: [TabBarItem]
    
    var body: some View {
        
            

            VStack {
                ZStack {
                    
                    Button (action: {
                        isShowingSheet.toggle()
                    }, label: {

//                        tabBarItemView(tab: TabBarItem(image: "add-shift", foregroundColor: Color.green))
//                            .onTapGesture {
//                                switchToTab(tab: TabBarItem(image: "add-shift", foregroundColor: Color.green))
//                            }

                            Circle()
                                .frame(width: 65, height: 65, alignment: .center)
                                .foregroundColor(Color(red: 0 / 255, green: 255 / 255, blue: 171 / 255, opacity: 1))
                                .overlay(alignment: .center) {
                                    Text("+")
                                        .font(.system(size: 25))
                                        .foregroundColor(Color(red: 14 / 255, green: 31 / 255, blue: 80 / 255, opacity: 1))
                                }

                    })
                    .offset(y: -35)

                    
                    HStack(spacing: 4) {
                        //Add button
                        ForEach(tabs, id:\.self) { tab in
                            
                            if tab.image == "add-Shift" {
                                
                                tabBarItemView(tab: tab)
                                    .offset(y: -35)
                                    .onTapGesture {
                                        switchToTab(tab: tab)
                                    }
                                
                            } else {
                                tabBarItemView(tab: tab)
                                    .onTapGesture {
                                        switchToTab(tab: tab)
                                    }
                            }
                            
                            
                            
                        }
                    }
                }
                
            }
            .frame(maxWidth: .infinity, maxHeight: 60, alignment: .center)
            .ignoresSafeArea()
            
        }
    }
//
//struct CustomTabBarView_Previews: PreviewProvider {
//    
//    static let tabs: [TabBarItem] = [
//        
//        TabBarItem(image: "profile-user", foregroundColor: Color.teal),
//        TabBarItem(image:  "empty-wallet", foregroundColor: Color.gray),
//        TabBarItem(image: "calendar", foregroundColor: Color.clear),
//        TabBarItem(image: "graph", foregroundColor: Color.red)
//        
//
//    ]
//    
////    static var previews: some View {
////        CustomTabBarView(selectedTab: .constant(tabs.first!), tabs: tabs)
////    }
//}

extension CustomTabBarView {
    
    private func tabBarItemView(tab: TabBarItem) -> some View {
        
//        Image(tab.image)
        
        VStack(spacing: -5) {
            
            
            Rectangle()
                .frame(width: 5, height: 5, alignment: .top)
                .foregroundColor(Color(red: 0 / 255, green: 255 / 255 , blue: 171 / 255))
                .cornerRadius(10)
                .opacity(selectedTab == tab ? 1 : 0)
                
            Image(selectedTab == tab ? tab.selectedImage : tab.image)
                .foregroundColor(selectedTab == tab ? Color.yellow : Color.gray)
                    .padding()
                    .frame(width: 100, height: 50, alignment: .center)
        }
        

        //MARK: Should be assigned
//                .frame(height: getRect().height/2.3)
                 
        
    }
    
    private func switchToTab(tab: TabBarItem) {
        
        withAnimation(.easeInOut) {
            
            selectedTab = tab
            
        }
    }
    
    
}


struct TabBarItem : Hashable {
    
    let image: String
    let foregroundColor: Color
    let selectedImage: String
    
}
