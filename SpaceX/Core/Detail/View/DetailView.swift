//
//  DetailView.swift
//  SpaceX
//
//  Created by Arman Zohourian on 6/28/23.
//

import SwiftUI

struct DetailView: View {
    
    @StateObject private var detailViewModel: DetailViewModel
    @State var currentIndex = 0
    @State var showFullDescription = false
        
    init(launch: Doc) {
        _detailViewModel = StateObject(wrappedValue: DetailViewModel(launch: launch))
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    ImageSliderView(imageUrls: detailViewModel.getMissionImageUrls(with: detailViewModel.launch), currentIndex: $currentIndex)
                    HStack {
                        launchDate
                        launchStatus
                    }
                    description
                    sources
                }
            }
        }
        .navigationBarTitle(Text(detailViewModel.launch.name))
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    detailViewModel.updateBookmark(launch: detailViewModel.launch)
                }) {
                    Image(systemName: detailViewModel.checkIsBookmarked(launch: detailViewModel.launch) ? "bookmark.fill" : "bookmark")
                }
            }
        }
    }
}

extension DetailView {
    private var launchDate: some View {
        DetailCellView(title: "Launch date", logoImageName: "calendar.circle.fill", isFullWidth: false, maxHeight: 100) {
            Text(detailViewModel.date)
                .font(.system(size: 14, weight: .light, design: .default))
                .foregroundColor(.white)
        }
        .padding(.leading)
    }
    
    private var launchStatus: some View {
        DetailCellView(title: "Launch Status", logoImageName: "checkmark.circle", isFullWidth: false, maxHeight: 100) {
            Text(detailViewModel.successStatus)
                .font(.system(size: 14, weight: .light, design: .default))
                .foregroundColor(.white)
                
        }
        .padding(.trailing)
    }
    
    private var description: some View {
        Group {
            if let detailDescription = detailViewModel.launchDescription {
                DetailCellView(title: "Description", logoImageName: "note.text", isFullWidth: true) {
                    VStack(alignment: .leading) {
                        Text(detailDescription)
                            .lineLimit(showFullDescription ? nil : 3)
                            .font(.callout)
                            .foregroundColor(Color.white)
                        
                        Button(action: {
                            withAnimation(.easeInOut) {
                                showFullDescription.toggle()
                            }
                        }) {
                            Text(showFullDescription ? "Less" : "Read more..")
                                .font(.caption)
                                .fontWeight(.bold)
                                .padding(.vertical, 4)
                        }
                        .accentColor(.blue)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.leading, .trailing])
                }
                .padding([.trailing,.leading])
            } else {
                EmptyView()
            }
        }
    }

    
    private var sources: some View {
        Group {
            if let wekipediaLink = detailViewModel.wikipediaLink {
                DetailCellView(title: "Sources", logoImageName: "safari", isFullWidth: true) {
                        Link("Wekipedia", destination: URL(string: wekipediaLink)!)
                }
                .padding([.leading,.trailing])
            } else {
                EmptyView()
            }
        }
    }
}
