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
    @State var popSheet = false
    @State var showInterstitial = true
  
   
    var body: some View {
        ZStack{
            if showInterstitial{
                
//                InterstitialVC()
//                RewardedVC()
            }
            VStack{
                Button(action: {
                    self.showInterstitial = true
                    self.popSheet.toggle()
                    print("button pressed showInterstitial \(self.showInterstitial)")
                    
                }) {
                    Text("Button")
                }
                .sheet(isPresented: self.$popSheet) {
                    
                    ThirdView()
                        .environmentObject(self.sharing)
                }
                
                
                
               NavigationLink("Navigate to ThirdView", destination: ThirdView())
                
                Button(action: {
                    Rewarded(ad: self.sharing.rewardedAdUnit).showAd(rewardFunction: {
                    print("Give Reward")
                  })
                }){
                    Text("No VC Rewarded")
                }
                NavigationView{
                    VStack{
                        NavigationLink("Navigate to ThirdView new NaviView", destination: ThirdView())
                    }
                    .background(Color.purple)
                    
                }
            
            }
            
            
        }
        .background(Color.yellow)
        .onAppear{
            
            let req = GADRequest()
            self.sharing.interstitial.load(req)
        }
        .onAppear{
            self.sharing.rewardedAdUnit.load(self.sharing.rewardedAdRequest)
        }
        .onDisappear{
            
            self.sharing.rewardedAdUnit = GADRewardedAd(adUnitID: "ca-app-pub-3940256099942544/1712485313")
            self.sharing.rewardedAdUnit.load(self.sharing.rewardedAdRequest)
        }

    }
}

struct SecondView_Previews: PreviewProvider {
    static var previews: some View {
        SecondView()
    }
}




