//
//  BookmarksView.swift
//  SpaceX
//
//  Created by Arman Zohourian on 6/30/23.
//

import SwiftUI

struct BookmarksView: View {
    
    
    @StateObject  var bookmarkViewModel = BookmarksViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                savedBookmarkList
            }
            .navigationTitle("Bookmarks")
            .navigationDestination(for: Launch.self) { launch in
                DetailView(launch: launch)
            }
            .overlay(alignment: .center ) {
                bookmarkEmptyText
            }
        }
    }
}

extension BookmarksView {
    
    private var savedBookmarkList: some View {
        LazyVStack {
            ForEach(bookmarkViewModel.bookmarkLaunches) { launch in
                NavigationLink(value: launch) {
                    Cardify(content: {
                        CardView(launch: launch)
                    })
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
    
    private var bookmarkEmptyText: some View {
            Text ("You have no bookmarks yet.")
                .font(.callout)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .frame(alignment: .bottom)
                .opacity(bookmarkViewModel.bookmarkLaunches.isEmpty ? 1.0 : 0.0)
                
    }
    
}

