//
//  ETCDNodeOutlineGroup.swift
//  etcdWP
//
//  Created by FaceBook on 2022/5/20.
//

import SwiftUI

struct ETCDNodeOutlineGroup: View {
    let node: KVData
    let childKeyPath: KeyPath<KVData, [KVData]?>
    @State var isExpanded: Bool = true
    var body: some View {
        if node[keyPath: childKeyPath] != nil {
            DisclosureGroup(
                isExpanded: $isExpanded,
                content: {
                    if isExpanded {
                        ForEach(node[keyPath: childKeyPath]!) { childNode in
                            ETCDNodeOutlineGroup(node: childNode, childKeyPath:childKeyPath,isExpanded:false)
                        }
                    }
                },
                label: { ETCDKVItemView(item: node)}
            )
        } else {
            ETCDKVItemView(item: node)
        }
    }
}
