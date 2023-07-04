//
//  ContentView.swift
//  SpaceX
//
//  Created by Arman Zohourian on 6/27/23.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject private var shuttlesViewModel: ShuttleViewModel
    
    
    var body: some View {
        content
            .overlay(alignment: .center) {
                if shuttlesViewModel.isLoading {
                    ProgressView()
                }
                
            }
    }
    
    var content: some View {
        
        TabView {
            
            HomeView()
                .environmentObject(shuttlesViewModel)
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            
            
            BookmarksView()
                .tabItem {
                    Image(systemName: "bookmark")
                    Text("Bookmarks")
                }
        }
    }

}
