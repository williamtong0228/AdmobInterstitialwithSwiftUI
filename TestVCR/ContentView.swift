//
//  ContentView.swift
//  TestVCR
//
//  Created by William Tong on 30/6/2020.
//  Copyright © 2020 William Tong. All rights reserved.
//

import SwiftUI
import GoogleMobileAds

struct ContentView: View {
    @State var showInterstitial = true
    @EnvironmentObject var sharing:SharedValues
    var body: some View {
        ZStack{
//            if showInterstitial{
//                InterstitialVC()
//                   .edgesIgnoringSafeArea(.all)
//            }
            NavigationView{
                List{
                    NavigationLink("Show Second View", destination: SecondView())
                }
            }
           
            
            
        }.onAppear{
            
            let request = GADRequest()
            self.sharing.interstitial.load(request)
        }
        

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct InterstitialVC:UIViewControllerRepresentable{

    
    @EnvironmentObject var sharing:SharedValues
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
        if sharing.popInterstitial{
            
            showAd(uiViewController)
        }
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let vc = UIViewController()
        vc.view.frame = UIScreen.main.bounds
//        vc.view.backgroundColor = .red
        sharing.interstitial.delegate = context.coordinator
        return vc
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator:NSObject,GADInterstitialDelegate{
        var parent:InterstitialVC
        
        init(_ parent: InterstitialVC) {
            self.parent = parent
        }
        func interstitialDidReceiveAd(_ ad: GADInterstitial) {
            //do your things
            parent.sharing.popInterstitial = true
        }
        
        func interstitialDidDismissScreen(_ ad: GADInterstitial) {
            //do your things
            let request = GADRequest()
            parent.sharing.interstitial.load(request)
        }
        
        func interstitialWillPresentScreen(_ ad: GADInterstitial) {
            //do your things
        }
        func interstitialDidFail(toPresentScreen ad: GADInterstitial) {
            //do your things
        }
    }
   
    func showAd(_ controller:UIViewController){
        
        if sharing.interstitial.isReady{
            sharing.interstitial.present(fromRootViewController: controller)
            sharing.popInterstitial = false
        }else{
            print("Not Ready Yet")
        }
    }
    
}
