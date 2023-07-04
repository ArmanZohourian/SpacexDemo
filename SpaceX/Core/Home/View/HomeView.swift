//
//  HomeView.swift
//  SpaceX
//
//  Created by Arman Zohourian on 6/29/23.
//

import SwiftUI

struct HomeView: View {
    
    
    @EnvironmentObject  var shuttlesViewModel : ShuttleViewModel
    
    @State var isDetailPresented = false
    
    var body: some View {
        content
            .task {
                await shuttlesViewModel.getLaunches()
                shuttlesViewModel.dismissLaunchScreen()
            }
    }
    var content: some View {
        NavigationStack {
            ScrollView {
                SearchBarView(searchText: $shuttlesViewModel.searchText)
                    .padding()
                shuttlesListView
            }
                .navigationTitle("Launches")
                .navigationDestination(for: Doc.self) { launch in
                    DetailView(launch: launch)
                }
                .overlay {
                Button(action: {
                    Task {
                        await shuttlesViewModel.getLaunches()
                    }
                }) {
                    refreshMessage
                }
                .opacity(shuttlesViewModel.hasError ? 1.0 : 0.0)
            }
        }
    }
    
}

extension HomeView {
    
    private var shuttlesListView: some View {
        LazyVStack {
            ForEach(shuttlesViewModel.filteredLaunches) { launch in
                NavigationLink(value: launch) {
                    Cardify(content: {
                        CardView(launch: launch)
                    })
                }
                .buttonStyle(PlainButtonStyle())
                .task {
                    if shuttlesViewModel.checkIfHasReachedEnd(with: launch) {
                        await shuttlesViewModel.getNextSetOfLaunches()
                    }
                }
            }
        }
    }
    
    private var refreshMessage: some View {
        VStack {
            Image(systemName: "arrow.clockwise")
                .font(.system(size: 24))
                .foregroundColor(.white)

            Text("Could not reach the server , try again.")
                .padding(.top)
        }
        .padding()
    }
    
}
