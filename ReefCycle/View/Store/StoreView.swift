//
//  StoreView.swift
//  ReefCycle
//
//  Created by Alonso Huerta on 23/03/25.
//

import SwiftUI

struct StoreView: View {
    let reefKeeperVM: ReefKeeperViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView {
                Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            }
            
            .navigationTitle("Store")
        }
    }
}

//#Preview {
//    StoreView()
//}
