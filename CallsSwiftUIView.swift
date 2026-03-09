import SwiftUI

struct CallItem: Identifiable {
    let id = UUID()
    let name: String
    let status: String
    let date: String
    let avatarImage: String
    let isMissed: Bool
    let isOutgoing: Bool
}

struct CallsSwiftUIView: View {
    @State private var selectedTab = 0
    
    let calls = [
        CallItem(name: "Martin Randolph", status: "Outgoing (2 min)", date: "10/13", avatarImage: "avatar1", isMissed: false, isOutgoing: true),
        CallItem(name: "Karen Castillo", status: "Outgoing, Incoming", date: "10/11", avatarImage: "avatar2", isMissed: false, isOutgoing: true),
        CallItem(name: "Kieron Dotson", status: "Outgoing", date: "10/8", avatarImage: "avatar3", isMissed: false, isOutgoing: true),
        CallItem(name: "Karen Castillo", status: "Missed", date: "9/30", avatarImage: "avatar2", isMissed: true, isOutgoing: false),
        CallItem(name: "Zack John", status: "Incoming", date: "9/24", avatarImage: "avatar4", isMissed: false, isOutgoing: false),
        CallItem(name: "Kieron Dotson", status: "Outgoing (4 min)", date: "9/16", avatarImage: "avatar3", isMissed: false, isOutgoing: true),
        CallItem(name: "Martha Craig", status: "Missed", date: "9/10", avatarImage: "avatar5", isMissed: true, isOutgoing: false),
        CallItem(name: "Kieron Dotson", status: "Outgoing", date: "10/8", avatarImage: "avatar3", isMissed: false, isOutgoing: true),
        CallItem(name: "Karen Castillo", status: "Missed", date: "9/30", avatarImage: "avatar2", isMissed: true, isOutgoing: false),
        CallItem(name: "Zack John", status: "Incoming", date: "9/24", avatarImage: "avatar4", isMissed: false, isOutgoing: false),
        CallItem(name: "Kieron Dotson", status: "Outgoing (4 min)", date: "9/16", avatarImage: "avatar3", isMissed: false, isOutgoing: true),
        CallItem(name: "Martha Craig", status: "Missed", date: "9/10", avatarImage: "avatar5", isMissed: true, isOutgoing: false),
        CallItem(name: "Kieron Dotson", status: "Outgoing", date: "10/8", avatarImage: "avatar3", isMissed: false, isOutgoing: true),
        CallItem(name: "Karen Castillo", status: "Missed", date: "9/30", avatarImage: "avatar2", isMissed: true, isOutgoing: false),
        CallItem(name: "Zack John", status: "Incoming", date: "9/24", avatarImage: "avatar4", isMissed: false, isOutgoing: false),
        CallItem(name: "Kieron Dotson", status: "Outgoing (4 min)", date: "9/16", avatarImage: "avatar3", isMissed: false, isOutgoing: true),
        CallItem(name: "Martha Craig", status: "Missed", date: "9/10", avatarImage: "avatar5", isMissed: true, isOutgoing: false)
        
    ]
    
    var filteredCalls: [CallItem] {
        if selectedTab == 0 {
            return calls
        } else {
            return calls.filter { $0.isMissed }
        }
    }
    
    var body: some View {
        NavigationView {
            List(filteredCalls) { call in
                CallRow(call: call)
                    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
            }
            .listStyle(PlainListStyle())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Edit") {
                        print("Bấm Edit")
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Picker("Tabs", selection: $selectedTab) {
                        Text("All").tag(0)
                        Text("Missed").tag(1)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .frame(width: 160)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        print("Thêm cuộc gọi")
                    }) {
                        Image(systemName: "phone.badge.plus")
                    }
                }
            }
        }
    }
}

struct CallRow: View {
    var call: CallItem
    
    var body: some View {
        HStack(spacing: 12) {
            
            if call.isOutgoing {
                Image(systemName: "phone.arrow.up.right")
                    .foregroundColor(.gray)
                    .font(.system(size: 14))
                    .frame(width: 16)
            } else {
                Color.clear.frame(width: 16, height: 16)
            }
            
            Image(call.avatarImage)
                .resizable()
                .scaledToFill()
                .frame(width: 44, height: 44)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(call.name)
                    .font(.system(size: 18, weight: .regular))
                    .foregroundColor(call.isMissed ? .red : .primary)
                
                Text(call.status)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text(call.date)
                .font(.system(size: 15))
                .foregroundColor(.gray)
            
            Button(action: {
                print("Xem chi tiết \(call.name)")
            }) {
                Image(systemName: "info.circle")
                    .foregroundColor(.blue)
                    .font(.system(size: 22, weight: .light))
            }
        }
        .padding(.vertical, 4)
    }
}

struct CallsSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        CallsSwiftUIView()
    }
}

