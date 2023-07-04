//
//  TabBarItemPrefrenceKey.swift
//  Spotify Clone
//
//  Created by Arman Zohourian on 5/9/22.
//

import Foundation
import SwiftUI

struct TabBarItemsPrefrenceKey: PreferenceKey {
   
    static var defaultValue: [TabBarItem] = []
    
    static func reduce(value: inout [TabBarItem], nextValue: () -> [TabBarItem]) {
        
        value += nextValue()
    }
    
    
    
}

struct TabBarViewModifier: ViewModifier {
    
    let tabValue : TabBarItem
    @Binding var  selectedTab : TabBarItem
    
    func body(content: Content) -> some View {
        
        content
            .opacity(selectedTab == tabValue ? 1.0 : 0.0)
            .preference(key: TabBarItemsPrefrenceKey.self, value: [tabValue])
        
    }
}
