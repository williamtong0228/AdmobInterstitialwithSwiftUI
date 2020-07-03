//
//  SharedValue.swift
//  TestVCR
//
//  Created by William Tong on 1/7/2020.
//  Copyright © 2020 William Tong. All rights reserved.
//

import Foundation
import GoogleMobileAds
class SharedValues:ObservableObject{
    
    @Published var interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910") //test
    @Published var popInterstitial = false
    @Published var req = GADRequest()
    @Published var rewardedAdUnit = GADRewardedAd(adUnitID: "ca-app-pub-3940256099942544/1712485313") //test
    @Published var rewardedAdRequest = GADRequest()
    @Published var showingUniqueAd = false
    @Published var rewardFunction:(()->Void)? = nil
}
