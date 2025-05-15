//
//  CitySkeletonRowView.swift
//  Uala Map
//
//  Created by santiago.tito on 14/05/2025.
//

import SwiftUI

struct CitySkeletonRowView: View {
    @State private var isAnimating = false
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                skeletonRectangle(width: 150, height: 16)
                skeletonRectangle(width: 100, height: 12)
            }
            Spacer()
            skeletonCircle(size: 24)
            skeletonCircle(size: 24)
        }
        .onAppear {
            withAnimation(Animation.linear(duration: 1.4).repeatForever(autoreverses: false)) {
                isAnimating = true
            }
        }
    }
    
    func skeletonRectangle(width: CGFloat, height: CGFloat) -> some View {
        ZStack {
            Color.gray.opacity(0.25) // 👈 base más suave
                .frame(width: width, height: height)
                .cornerRadius(4)
            
            if isAnimating {
                shimmer()
                    .frame(width: width, height: height)
                    .cornerRadius(4)
            }
        }
    }
    
    func skeletonCircle(size: CGFloat) -> some View {
        ZStack {
            Color.gray.opacity(0.25) // 👈 base más suave
                .frame(width: size, height: size)
                .clipShape(Circle())
            
            if isAnimating {
                shimmer()
                    .frame(width: size, height: size)
                    .clipShape(Circle())
            }
        }
    }
    
    func shimmer() -> some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color.white.opacity(0.2),
                Color.white.opacity(0.6),
                Color.white.opacity(0.2)
            ]),
            startPoint: .leading,
            endPoint: .trailing
        )
        .offset(x: isAnimating ? 250 : -250)
        .animation(Animation.linear(duration: 1.4).repeatForever(autoreverses: false), value: isAnimating)
    }
}

#Preview {
    CitySkeletonRowView()
}
