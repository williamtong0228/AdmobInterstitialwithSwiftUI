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
    
    @Published var interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
    @Published var popInterstitial = false
}
