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
                if !bookmarkViewModel.bookmarkLaunches.isEmpty {
                    savedBookmarkList
                } else {
                    Text ("You have no bookmarks yet.")
                }
            }
            .navigationTitle("Bookmarks")
            .navigationDestination(for: Launch.self) { launch in
                DetailView(launch: launch)
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
    
}

