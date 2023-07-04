//
//  CardView.swift
//  SpaceX
//
//  Created by Arman Zohourian on 6/28/23.
//

import SwiftUI

struct CardView: View {
    
    
    @StateObject var cardViewModel : CardViewModel
    
    init(launch: Launch) {
        _cardViewModel = StateObject(wrappedValue: CardViewModel(launch: launch))
    }
    
    var body: some View {
        HStack {
            missionLogo
            VStack(alignment: .leading, spacing: 5) {
                launchDate
                launchName
                flightNumber
            }
            Spacer()
            launchStatus
        }
        .padding()
    }
}

extension CardView {
    
    private var missionLogo: some View {
        CachedImage(imageUrl: cardViewModel.launchLogoUrl) { image in
            image
                .resizable()
                .frame(width: 70, height: 70 , alignment: .leading)
                .cornerRadius(10)
        } placeholder: {
            ProgressView()
                .frame(width: 70, height: 70 , alignment: .center)
        }
    }
    
    private var launchDate: some View {
        Text(cardViewModel.launchDate)
            .font(.footnote)
            .frame(maxWidth: 150, alignment: .leading)
    }
    
    private var launchName: some View {
        Text(cardViewModel.launch.name)
            .font(.headline)
            .frame(maxWidth: 100, alignment: .leading)
            .foregroundColor(.gray)
    }
    
    private var flightNumber: some View {
        HStack {
            Text("Flight number:")
                .fontDesign(.serif)
                .fontWeight(.light)
                .font(.system(size: 13))
            Text(String(cardViewModel.launch.flightNumber))
                .font(.system(size: 12))
                .font(.subheadline)
        }
        .foregroundColor(.white)
    }
    
    private var launchStatus: some View {
        Text(cardViewModel.launchStatus)
            .font(.caption2)
            .frame(alignment: .topTrailing)
            .padding()
            .foregroundColor(cardViewModel.launchStatusColor)
    }
    
}


