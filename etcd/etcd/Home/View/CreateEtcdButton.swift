//
//  CreateEtcdButton.swift
//  etcd
//
//  Created by taoshumin_vendor on 2022/3/20.
//

import SwiftUI
import NavigationStack

struct CreateEtcdButton: View {
    @Binding var isLinkActive : Bool
    var body: some View {
        HStack {
            Spacer()            
            PushView(destination: HomeClientCreateView(), isActive: $isLinkActive) {
                Button {  self.isLinkActive.toggle() } label: {
                    HStack {
                        Image(systemName: "plus")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 16)
                            .foregroundColor(.white)
                        Text("Add Etcd Client")
                            .fontWeight(.semibold)
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                    }
                }
                .frame(width: 180.0,height: 60.0)
                .buttonStyle(PlainButtonStyle())
                .background(Capsule().fill(Color(hex:"#00FFFF").opacity(0.30)))
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}
