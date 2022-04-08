//
//  TopToastView.swift
//  etcd
//
//  Created by taoshumin_vendor on 2022/3/19.
//

import SwiftUI

struct TopToastView: View {
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("The network connection is abnormal, please check the relevant configuration ?")
                    .lineLimit(2)
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                Spacer()
            }
            .padding()
        }
        .background(.red)
        .frame(height: 50.0)
    }
}

struct TopToastView_Previews: PreviewProvider {
    static var previews: some View {
        TopToastView()
    }
}
