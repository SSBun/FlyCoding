//
//  Homepage.swift
//  
//
//  Created by caishilin on 2022/4/21.
//

import SwiftUI

public struct RootView: View {
    public var body: some View {
        VStack {
            Text("Hello, Worlds!")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.red)
    }
    
    public init() {}
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
