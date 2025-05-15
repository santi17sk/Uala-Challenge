//
//  ConnectionErrorView.swift
//  Uala Map
//
//  Created by santiago.tito on 14/05/2025.
//

import SwiftUI

struct ConnectionErrorView: View {
    let retryAction: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 60))
                .foregroundColor(.orange)
            
            Text("Connection Error")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("We couldn’t load the cities.\nPlease check your connection and try again.")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
            
            Button(action: retryAction) {
                Text("Retry")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.horizontal)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    ConnectionErrorView(retryAction: {})
}
