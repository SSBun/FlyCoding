//
//  InstallationGuideView.swift
//  FlyCoding
//
//  Created by SSBun on 2022/9/24.
//  Copyright © 2022 SSBun. All rights reserved.
//

import SwiftUI

struct InstallationGuideView: View {
    private let guideImage = NSImage(named: "FlyCodingHomePage")!
    
    var body: some View {
        Image(nsImage: guideImage)
            .resizable()
            .scaledToFit()
            .frame(width: guideImage.size.width / 2, height:guideImage.size.height / 2)
    }
}

struct InstallationGuideView_Previews: PreviewProvider {
    static var previews: some View {
        InstallationGuideView()
    }
}
