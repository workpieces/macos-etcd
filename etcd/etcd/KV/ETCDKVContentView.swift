//
//  HomeConnectView.swift
//  etcd
//
//  Created by taoshumin_vendor on 2022/3/12.
//

import SwiftUI
import NavigationStack

struct ETCDKVContentView: View {
    @StateObject var homeData = HomeViewModel()
    var body: some View {
        ETCDDetailTabBarView()
    }
}


struct HomeConnectView_Previews: PreviewProvider {
    static var previews: some View {
        ETCDKVContentView()
    }
}
