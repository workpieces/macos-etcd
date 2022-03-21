//
//  AboutView.swift
//  etcd
//
//  Created by taoshumin_vendor on 2022/3/11.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        HStack {
            Link("git地址",
                  destination: URL(string: "https://github.com/shumintao")!)
                .font(.headline)
                .foregroundColor(.black)
        }
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
