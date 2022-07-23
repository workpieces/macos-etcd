//
//  ETCDADBannerView.swift
//  etcdWP (iOS)
//
//  Created by FaceBook on 2022/7/23.
//

import SwiftUI
import GoogleMobileAds

struct ETCDADBannerView: View {
    
    @State var height: CGFloat = 0
    
    @State var width: CGFloat = 0
    
    @State var adPosition: ETCDAdBannerPosition
    
    let adBannerId: String
    public init(adPosition: ETCDAdBannerPosition, adBannerId: String) {
        self.adPosition = adPosition
        self.adBannerId = adBannerId
    }
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

class ETCDBannerAdViewController: UIViewController {
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
        bannerView.adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth)
        bannerView.load(GADRequest())
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
        
    }
    typealias UIViewControllerType = ETCDBannerAdViewController
}
