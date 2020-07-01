//
//  SecondView.swift
//  TestVCR
//
//  Created by William Tong on 1/7/2020.
//  Copyright © 2020 William Tong. All rights reserved.
//

import SwiftUI
import GoogleMobileAds

struct SecondView: View {
    @EnvironmentObject var sharing:SharedValues
    
    @State var showInterstitial = true
    var body: some View {
        ZStack{
            if showInterstitial{
                
                InterstitialVC()
            }
            
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        }
        .background(Color.yellow)
        .onAppear{
            
            let request = GADRequest()
            self.sharing.interstitial.load(request)
        }
        
    }
}

struct SecondView_Previews: PreviewProvider {
    static var previews: some View {
        SecondView()
    }
}
