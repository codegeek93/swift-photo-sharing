//
//  CreatorScreen.swift
//  memories
//
//  Created by Toan Nguyen Dinh on 11/14/19.
//  Copyright © 2019 Toan Nguyen Dinh. All rights reserved.
//

import SwiftUI

struct CreatorScreen: View {
    @EnvironmentObject var store: Store
    var body: some View {
        VStack(alignment: .leading, spacing: 1.0){
//            List{
//               NavigationLink(destination: Albums()){
//                    MenuItemView(title: "Memory Book")
//                }
//                NavigationLink(destination: ContributeScreen()){
//                    MenuItemView(title: "Contribute")
//                }
//                NavigationLink(destination: ShareScreen()){
//                    MenuItemView(title: "Share")
//                }
//                NavigationLink(destination: AboutScreen()){
//                    MenuItemView(title: "About")
//                }
//            }
//
            Albums()
                .onAppear(){
                    self.store.isMemoryBook = false
                }
        }.navigationBarTitle("Yaad", displayMode: .inline)
        
    }
}

struct CreatorScreen_Previews: PreviewProvider {
    static var previews: some View {
        CreatorScreen()
    }
}
