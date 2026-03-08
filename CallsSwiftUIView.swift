import SwiftUI

// 1. Model dữ liệu (Cấu trúc của 1 dòng cuộc gọi)
struct CallItem: Identifiable {
    let id = UUID()
    let name: String
    let status: String       // VD: "Outgoing (2 min)", "Missed"
    let date: String         // VD: "10/13"
    let avatarImage: String  // Tên ảnh trong Assets
    let isMissed: Bool       // Chuyển tên thành màu đỏ nếu true
    let isOutgoing: Bool     // Hiện cái icon điện thoại nhỏ nếu true
}

struct CallsSwiftUIView: View {
    // 0 là All, 1 là Missed
    @State private var selectedTab = 0
    
    // 2. Data giả lập y hệt bản thiết kế của ông
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
    
    // Lọc danh sách dựa vào thanh gạt
    var filteredCalls: [CallItem] {
        if selectedTab == 0 {
            return calls // Hiện tất cả
        } else {
            return calls.filter { $0.isMissed } // Chỉ hiện cuộc gọi nhỡ
        }
    }
    
    var body: some View {
        NavigationView {
            // 3. Khung danh sách
            List(filteredCalls) { call in
                CallRow(call: call)
                    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)) // Căn lề cho thoáng
            }
            .listStyle(PlainListStyle()) // Bỏ đi mấy cái nền xám mặc định
            .navigationBarTitleDisplayMode(.inline)
            // 4. Gắn đồ chơi lên thanh điều hướng
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

// 5. Khuôn đúc từng dòng (Row)
struct CallRow: View {
    var call: CallItem
    
    var body: some View {
        HStack(spacing: 12) {
            
            // Icon điện thoại nhỏ nhô ra (Chỉ hiện khi gọi đi)
            if call.isOutgoing {
                Image(systemName: "phone.arrow.up.right")
                    .foregroundColor(.gray)
                    .font(.system(size: 14))
                    .frame(width: 16)
            } else {
                // Giữ chỗ trống để các Avatar thẳng hàng với nhau
                Color.clear.frame(width: 16, height: 16)
            }
            
            // Avatar tròn vo
            Image(call.avatarImage)
                .resizable()
                .scaledToFill()
                .frame(width: 44, height: 44)
                .clipShape(Circle())
            
            // Tên và Trạng thái
            VStack(alignment: .leading, spacing: 4) {
                Text(call.name)
                    .font(.system(size: 18, weight: .regular))
                    // Gọi nhỡ thì chữ màu đỏ, bình thường màu đen
                    .foregroundColor(call.isMissed ? .red : .primary)
                
                Text(call.status)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            
            Spacer() // Đẩy ngày và nút i sang sát lề phải
            
            // Ngày tháng
            Text(call.date)
                .font(.system(size: 15))
                .foregroundColor(.gray)
            
            // Nút chữ i
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

// Preview để xem trước ngay trong Xcode
struct CallsSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        CallsSwiftUIView()
    }
}

