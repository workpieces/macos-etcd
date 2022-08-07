//
//  ETCDDetialMenuView.swift
//  etcdWP (iOS)
//
//  Created by Google on 2022/8/2.
//

import SwiftUI
import SwiftUIRouter
struct ETCDDetialMenuViewItemView: View {
    var menu:ETCDKVMenuModel
    var body: some View {
        NavLink(to:menu.rounterName) {
            Text(LocalizedStringKey(menu.title))
                .font(.body)
                .foregroundColor(.white)
                .truncationMode(.middle)
                .padding(.leading,5)
                .padding(.trailing,8)
                .frame(maxHeight: 30)
                .background(Color.white.opacity(0.15))
                .cornerRadius(5)
                .listRowBackground(Color(hex: "#262626"))
                .buttonStyle(.plain)
        }
    }
}

struct ETCDDetialMenuView: View {
    @State isEnble:Bool = false
    @EnvironmentObject var storeObj : ItemStore
    var body: some View {
        VStack(alignment: .leading){
            Text("操作")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(1)
                .opacity(0.75)
                .padding(.leading,20)
                .frame(alignment: .leading)
            Divider().frame(height:0.5)
            ScrollView(.horizontal, showsIndicators: false){
                HStack {
                    ForEach(0 ..< menuModels.count){ index in
                        if menuModels[index].rounterName.count == 0 {
                            ETCDCheckBoxView(IsChoice: $isEnable) {  newValue in
                                let keyValue =  storeObj.authEnable(enble: !newValue)
                                if keyValue?.status != 200{
                                    self.isShowToast.toggle()
                                    isEnable = false
                                }
                            }
                        }else {
                            ETCDDetialMenuViewItemView(menu:menuModels[index])
                        }
                    }
                }
            }.frame(height: 30)
             .padding(.leading,5)
             .padding(.trailing,8)
        }
    }
    
}
