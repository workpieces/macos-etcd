//
//  logoView.swift
//  etcd
//
//  Created by taoshumin_vendor on 2022/3/11.
//

import SwiftUI

struct LogoView: View {
    var body: some View {
        HStack{
            Image("logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.white)
                .frame(width: 30)
            Text("etcdWp")
                .fontWeight(.semibold)
                .font(.system(size: 25))
                .foregroundColor(.white)
        }
        .background(Color.clear)
    }
}

struct logoView_Previews: PreviewProvider {
    static var previews: some View {
        LogoView()
    }
}
