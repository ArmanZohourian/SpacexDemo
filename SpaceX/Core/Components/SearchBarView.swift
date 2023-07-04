//
//  SearchBarView.swift
//  SpaceX
//
//  Created by Arman Zohourian on 6/30/23.
//

import SwiftUI

struct SearchBarView: View {
    
    @Binding var searchText : String
    var body: some View {
        HStack {
            searchIcon
            searchTextField
        }
        .font(.headline)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.black.opacity(0.8))
                .shadow(color: Color.white.opacity(0.5), radius: 5)
                
        )
    }
}
extension SearchBarView {
    private var searchTextField: some View {
        TextField("Seach launch name ", text: $searchText)
            .foregroundColor(Color.white)
            .overlay(alignment: .trailing) {
                Image(systemName: "xmark.circle.fill")
                    .padding(.trailing)
                    .offset(x: 10)
                    .opacity(searchText.isEmpty ? 0.0 : 1.0)
                    .onTapGesture {
                        searchText = ""
                    }
            }
    }
    private var searchIcon: some View {
        Image(systemName: "magnifyingglass")
            .foregroundColor(Color.white)
    }
}
