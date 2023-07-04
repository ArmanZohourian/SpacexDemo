//
//  CustomTabbarItem.swift
//  OKTime
//
//  Created by Arman Zohourian on 10/13/22.
//

import Foundation
import SwiftUI

//Get size of the screen
extension View {
    func getRect() -> CGRect {
        return UIScreen.main.bounds
    }
    
    func getSafeArea() -> UIEdgeInsets {
        
        return UIApplication.shared.windows.first?.safeAreaInsets ?? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        
    }
    
    func tabBarItem(tab: TabBarItem, selection: Binding<TabBarItem>) -> some View {
        
        self.modifier(TabBarViewModifier(tabValue: tab, selectedTab: selection))
    }
    
    

}
