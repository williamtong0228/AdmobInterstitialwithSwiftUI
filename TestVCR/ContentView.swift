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
    @State var popSheet = false
    @EnvironmentObject var sharing:SharedValues
    var body: some View {
        VStack{
//            if showInterstitial{
//                InterstitialVC()
//                   .edgesIgnoringSafeArea(.all)
//            }

            Button(action: {
                self.popSheet = true
            }) {
                Text("Pop Sheet Second View")
            }
            .sheet(isPresented: self.$popSheet) {
                SecondView()
                    .environmentObject(self.sharing)
            }
            NavigationView{
                 NavigationLink("Show Second View", destination: SecondView())
            }
           
                
            
           
            
            
        }.onAppear{
            
            
            self.sharing.interstitial.load(self.sharing.req)
        }
//        .onAppear{
//            
//            self.sharing.rewardedAdUnit.load(self.sharing.rewaredAdRequest)
//            
//        }
        

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
            let req = GADRequest()
            parent.sharing.interstitial.load(req)
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



struct RewardedVC:UIViewControllerRepresentable{
   
    @EnvironmentObject var sharing:SharedValues
    
    var counterRewardedAd = 0
    
    
    func makeCoordinator() -> Coordinator {
        
        Coordinator(self)
    }
    
    class Coordinator:NSObject, GADRewardedAdDelegate{
        
        
        var parent:RewardedVC!
        
        init(_ parent: RewardedVC) {
            
            self.parent = parent
        }
        
        func rewardedAd(_ rewardedAd: GADRewardedAd, userDidEarn reward: GADAdReward) {
            
            print("Unlocking feature")
                   
                 
       NotificationCenter.default.post(name: NSNotification.Name("channelUnlockMonthlyChart"), object: nil)
                        
        }
        
        func rewardedAdDidDismiss(_ rewardedAd: GADRewardedAd) {
            print("debugging rewarded ad rewardedAdDidDismiss \(String(describing: rewardedAd))")
            parent.loadRewarded()
        }
        
        func rewardedAdDidPresent(_ rewardedAd: GADRewardedAd) {
             print("debugging rewarded ad rewardedAdDidPresent \(String(describing: rewardedAd))")
            parent.sharing.showingUniqueAd = true
        }
        
        func rewardedAd(_ rewardedAd: GADRewardedAd, didFailToPresentWithError error: Error) {
            print("debugging rewarded ad rewardedAdDidPresent \(String(describing: error.localizedDescription))")
            parent.sharing.showingUniqueAd = false
            parent.loadRewarded()
        }
        
        
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        print("sending rewards? \(uiViewController)")
        if sharing.showingUniqueAd == false{
//
//            if sharing.rewardedAdUnit.isReady {
//                sharing.showingUniqueAd = true
                showAD(controller: uiViewController, delegate: context.coordinator){

                    print("sending rewards? \(uiViewController)")

                }

//            }else{
//                print("rewarded ad ready \(sharing.rewardedAdUnit)")
//            }
        }
        
    }
    
    
    func makeUIViewController(context: Context) -> UIViewController{

        for vc in UIApplication.shared.windows{
            
            print("debugging views \(String(describing: vc.rootViewController?.classForCoder))")
            
        }
//        let viewController = UIViewController()
        let viewController = UIApplication.shared.windows.first?.rootViewController
        
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
        viewController!.view.frame = UIScreen.main.bounds
        
//        }
//        loadRewarded()

        return viewController ?? UIViewController()
    }
    
        func loadRewarded(){
            guard counterRewardedAd == 0 else {
                return
            }
            sharing.rewardedAdUnit.load(sharing.rewardedAdRequest)
        
        }
        
    func showAD(controller:UIViewController, delegate:Coordinator, rewardFunction: @escaping() -> Void){
            guard counterRewardedAd == 0 else {
                return
            }
            
    //        let root = UIApplication.shared.windows.first?.rootViewController
             
            if sharing.rewardedAdUnit.isReady{
                self.sharing.rewardFunction = rewardFunction
    //            let root = UIApplication.shared.windows.first?.rootViewController
    //            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
    //                 let root = controller
               sharing.showingUniqueAd = true
                sharing.rewardedAdUnit.present(fromRootViewController:controller , delegate: delegate)
    //            }
                
            }

            }
    
}


final class Rewarded: NSObject, GADRewardedAdDelegate{
   
    var rewardFunction: (() -> Void)? = nil
    
    var rewardedAd:GADRewardedAd!
    
    init(ad:GADRewardedAd!) {
        super.init()
        rewardedAd = ad
        LoadRewarded()
    }
    
    func LoadRewarded(){
        let req = GADRequest()
        self.rewardedAd.load(req)
    }
    
    func showAd(rewardFunction: @escaping () -> Void){
        
        if self.rewardedAd.isReady{
            self.rewardFunction = rewardFunction
            for vc in UIApplication.shared.windows{
                
                print("debugging views \(String(describing: vc))")
                
            }
            print("debugging views \(UIApplication.shared.windows.count)")
            let root = UIApplication.shared.windows.last?.rootViewController
//            let root = UIViewController()
            self.rewardedAd.present(fromRootViewController: root!, delegate: self)
            print("no vc root \(String(describing: root))")
        }
       else{
           print("Not Ready")
       }
    }
    
    func rewardedAd(_ rewardedAd: GADRewardedAd, userDidEarn reward: GADAdReward) {
        if let rf = rewardFunction {
            rf()
        }
    }
    func rewardedAdDidPresent(_ rewardedAd: GADRewardedAd) {
        print("debugging error rewardedAdDidPresent \(rewardedAd)")
    }
    func rewardedAdDidDismiss(_ rewardedAd: GADRewardedAd) {
        self.rewardedAd = GADRewardedAd(adUnitID: "ca-app-pub-3940256099942544/1712485313")
        LoadRewarded()
    }
    
    func rewardedAd(_ rewardedAd: GADRewardedAd, didFailToPresentWithError error: Error) {
        print("debugging error didFailToPresentWithError \(String(describing: rewardedAd))")
        print("debugging error didFailToPresentWithError \(error.localizedDescription)")
    }
}
