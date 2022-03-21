//
//  CardItemView.swift
//  etcd
//
//  Created by taoshumin_vendor on 2022/3/11.
//

import SwiftUI

struct CardItemView: View {
    @EnvironmentObject var homeData: HomeViewModel
    @State private var showAlert = false
    @State private var pushEdit = false
    var options: EtcdClientOption
    var idx : Int
    var body: some View {
        VStack {
            ZStack(alignment: .topLeading) {
                Button {
                    self.showAlert.toggle()
                } label: {
                    Image(systemName: "ellipsis")
                        .resizable()
                        .foregroundColor(.white)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25)
                }
                .padding(.vertical,15.0)
                .padding(.horizontal,15.0)
                .contentShape(Rectangle())
                .buttonStyle(PlainButtonStyle())
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Want to modify etcd service data?"),
                        message: Text("The connection to the server was lost."),                    
                        primaryButton: .default(
                            Text("Edit"),
                            action: {
                                self.pushEdit.toggle()
                            }
                        ),
                        secondaryButton: .destructive(
                            Text("Delete"),
                            action: {
                                self.homeData.Delete(id:self.homeData.GetUUID(idx: idx))
                            }
                        )
                    )
                }
                
                HStack {
                    Spacer()
                    VStack(spacing: 8.0){
                        Text("Service Name")
                            .foregroundColor(Color.orange)
                            .fontWeight(.semibold)
                            .font(.system(size: 16))
                            .bold()
                        
                        Text(options.serviceName)
                            .foregroundColor(Color.white)
                            .fontWeight(.semibold)
                            .font(.system(size: 14))
                            .bold()
                            .minimumScaleFactor(0.5)
                            .truncationMode(.middle)
                        
                        Spacer()
                    }
                }
                .padding()
            }
            
            VStack(alignment: .center,spacing: 10.0) {
                Text("Endpoints")
                    .foregroundColor(Color.orange)
                    .fontWeight(.semibold)
                    .font(.system(size: 16))
                    .bold()
                Text(options.endpoints.first!)
                    .foregroundColor(Color.white)
                    .fontWeight(.semibold)
                    .font(.system(size: 14))
                    .lineLimit(1)
                    .truncationMode(.middle)
                
                Text("Connection Status")
                    .foregroundColor(Color.orange)
                    .fontWeight(.semibold)
                    .font(.system(size: 16))
                    .bold()
                    .padding(.top,15)
                Text(options.status == true ? "Scuess" : "Failed")
                    .foregroundColor(options.status == true ? Color(hex:"#00FF7F") : Color.red)
                    .fontWeight(.semibold)
                    .font(.system(size: 14))
                    .lineLimit(1)
                    .truncationMode(.middle)
                Spacer()
            }
            .offset(x: -10, y: -15)
        }
        .frame(minHeight: 210, maxHeight: 260)
        .background(Color(hex: "#5B9BD4").opacity(0.25))
        .cornerRadius(10.0)
    }
}
