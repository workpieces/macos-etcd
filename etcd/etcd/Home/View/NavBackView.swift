//
//  NavBackView.swift
//  etcd
//
//  Created by taoshumin_vendor on 2022/3/20.
//

import SwiftUI
import NavigationStack

struct NavBackView: View {
    @Binding var isPopView: Bool
    var title : String
    var body: some View {
        HStack {
            PopView(isActive: $isPopView ) {
                Button {
                    self.isPopView.toggle()
                } label: {
                    Image(systemName: "arrow.backward")
                        .withDefaultImage(width: 25.0)
                }
                .buttonStyle(PlainButtonStyle())
            }
            Spacer()
            Text(title)
                .fontWeight(.semibold)
                .font(.system(size: 30.0))
                .foregroundColor(.white)
            
            Spacer()
        }
    }
}
