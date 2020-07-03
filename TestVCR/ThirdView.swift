//
//  SecondView.swift
//  TestVCR
//
//  Created by William Tong on 1/7/2020.
//  Copyright © 2020 William Tong. All rights reserved.
//

import SwiftUI
import GoogleMobileAds

struct ThirdView: View {
    @EnvironmentObject var sharing:SharedValues
    
    @State var showInterstitial = false
    init(){
        UINavigationBar.appearance().tintColor = UIColor.clear
    }
    var body: some View {
        ZStack{
            
            RewardedVC()
        }
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
        .onAppear{
            
            self.sharing.rewardedAdUnit.load(self.sharing.rewardedAdRequest)
        }

        
    }
}

struct ThirdView_Previews: PreviewProvider {
    static var previews: some View {
        ThirdView()
    }
}



