//
//  ETCDADBannerView.swift
//  etcdWP (iOS)
//
//  Created by FaceBook on 2022/7/23.
//

import SwiftUI
import GoogleMobileAds


struct ETCDADBannerView: View {
    
    @State var height: CGFloat
    
    @State var width: CGFloat
    
    @State var adPosition: ETCDAdBannerPosition
    
    let adBannerId: String
    public enum ETCDAdBannerPosition {
        case top
        case bottom
    }
    public var body: some View {
        VStack {
            if adPosition == .bottom {
                Spacer()
            }
            ETCDADBannerSubView(adBannerId:adBannerId)
                .frame(width: width, height: height, alignment: .center)
                .onAppear {
                    
                    setFrame()
                }
                .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                    setFrame()
                }
            if adPosition == .top {
                Spacer()
            }
        }
    }
    
    func setFrame() {
        let safeAreaInsets = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.safeAreaInsets ?? .zero
        let frame = UIScreen.main.bounds.inset(by: safeAreaInsets)
        
        let adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(frame.width)
        
        self.width = adSize.size.width
        self.height = adSize.size.height
    }
}

class ETCDBannerAdViewController: UIViewController,GADBannerViewDelegate{
    let adBannerId: String
    
    init(adBannerId: String) {
        self.adBannerId = adBannerId
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var bannerView: GADBannerView = GADBannerView()
    override func viewDidLoad() {
        bannerView.adUnitID = adBannerId
        bannerView.rootViewController = self
        bannerView.delegate = self
        view.addSubview(bannerView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadBannerAd()
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate { _ in
            self.bannerView.isHidden = true
        } completion: { _ in
            self.bannerView.isHidden = false
            self.loadBannerAd()
        }
    }

    func loadBannerAd() {
        let frame = view.frame.inset(by: view.safeAreaInsets)
        let viewWidth = frame.size.width
        bannerView.adSize = GADPortraitAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth)
        let adRequest = GADRequest()
        bannerView.load(adRequest)
    }
    
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        guard bannerView.responseInfo?.adNetworkInfoArray != nil else{
            return
        }
        let adSouruceID = String(format:  bannerView.responseInfo?.adNetworkInfoArray.first?.value(forKeyPath: "adSourceID") as! String)
        
        let goodAds: [ETCDGoogleAdsModel]? = ETCDGoogleDBManger.share.getValue(on: ETCDGoogleAdsModel.Properties.all, fromTable: ETCD_GOOGLE_ADS_TABLE_NAME, where: ETCDGoogleAdsModel.Properties.adSourceID.like("%\(adSouruceID)%"))
        if(goodAds != nil && goodAds!.count > 0 ){
            let model = goodAds!.first
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dateformatter.timeZone = TimeZone.current
            let date =  dateformatter.date(from: model!.timeFormat!)
            if(date!.isToday() && model!.hitCount == 1){
                
                bannerView.isUserInteractionEnabled = false
            }else{
                bannerView.isUserInteractionEnabled = true
            }
            return
        }
        bannerView.isUserInteractionEnabled = true
      }
    
    func bannerViewDidRecordClick(_ bannerView: GADBannerView) {
        let adSouruceID = String(format:  bannerView.responseInfo?.adNetworkInfoArray.first?.value(forKeyPath: "adSourceID") as! String)

        let goodAds: [ETCDGoogleAdsModel]? = ETCDGoogleDBManger.share.getValue(on: ETCDGoogleAdsModel.Properties.all, fromTable: ETCD_GOOGLE_ADS_TABLE_NAME, where: ETCDGoogleAdsModel.Properties.adSourceID.like("%\(adSouruceID)%"))
        if(goodAds != nil && goodAds!.count > 0 ){
            let model = goodAds!.first
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dateformatter.timeZone = TimeZone.current
            let date =  dateformatter.date(from: model!.timeFormat!)
            if(date!.isToday() && model!.hitCount == 1){
                
                bannerView.isUserInteractionEnabled = false
            }else{
                bannerView.isUserInteractionEnabled = true
                
                let date = Date()
                let googleAds = ETCDGoogleAdsModel()
                googleAds.adSourceID = adSouruceID
                googleAds.time = date.timeIntervalSince1970
                let dateformatter = DateFormatter()
                model?.hitCount = 1;
                dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                googleAds.timeFormat = dateformatter.string(from: date)
                ETCDGoogleDBManger.share.updateToDb(table: ETCD_GOOGLE_ADS_TABLE_NAME, on: ETCDGoogleAdsModel.Properties.all, with: googleAds)
            }
            return
        }
        bannerView.isUserInteractionEnabled = true
        
        let date = Date()
        let googleAds = ETCDGoogleAdsModel()
        googleAds.adSourceID = adSouruceID
        googleAds.time = date.timeIntervalSince1970
        let dateformatter = DateFormatter()
        googleAds.hitCount = 1;
        dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        googleAds.timeFormat = dateformatter.string(from: date)
        ETCDGoogleDBManger.share.insertToDb(objects: [googleAds], intoTable:ETCD_GOOGLE_ADS_TABLE_NAME)
        
    }
    
    func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
    
    }
    
    func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
        
    }
    
    func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
        
    }
    
    func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
        
    }
    
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        
    }
    
    
}

struct ETCDADBannerSubView :UIViewControllerRepresentable {

    let adBannerId: String


    init(adBannerId: String) {
        self.adBannerId = adBannerId
    }
    func makeUIViewController(context: Context) -> ETCDBannerAdViewController {
        return ETCDBannerAdViewController(adBannerId: adBannerId)
    }
    
    func updateUIViewController(_ uiViewController: ETCDBannerAdViewController, context: Context) {
        uiViewController.loadBannerAd()
    }
    typealias UIViewControllerType = ETCDBannerAdViewController
}
