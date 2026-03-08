import SwiftUI

struct DataStorageSwiftUIView: View {
    // Các biến trạng thái để nhớ xem nút gạt đang bật hay tắt
    @State private var autoPlayGIFs = false
    @State private var autoPlayVideos = false
    @State private var saveEditedPhotos = false
    
    var body: some View {
        Form {
            // CỤM 1: USAGE (Không có tiêu đề)
            Section {
                NavigationLink(destination: Text("Màn hình Storage Usage")) {
                    Text("Storage Usage")
                }
                NavigationLink(destination: Text("Màn hình Network Usage")) {
                    Text("Network Usage")
                }
            }
            
            // CỤM 2: AUTOMATIC MEDIA DOWNLOAD
            Section(header: Text("AUTOMATIC MEDIA DOWNLOAD").font(.footnote).foregroundColor(.gray)) {
                
                NavigationLink(destination: Text("Màn hình Using Cellular")) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Using Cellular")
                        Text("Disabled").font(.system(size: 14)).foregroundColor(.gray)
                    }
                }
                
                NavigationLink(destination: Text("Màn hình Using Wi-Fi")) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Using Wi-Fi")
                        Text("Disabled").font(.system(size: 14)).foregroundColor(.gray)
                    }
                }
                
                // Nút chữ xanh để Reset
                Button(action: {
                    print("Đã bấm Reset")
                }) {
                    Text("Reset Auto-Download Settings")
                        .foregroundColor(.blue)
                }
            }
            
            // CỤM 3: AUTO-PLAY MEDIA (Nút gạt)
            Section(header: Text("AUTO-PLAY MEDIA").font(.footnote).foregroundColor(.gray)) {
                Toggle("GIFs", isOn: $autoPlayGIFs)
                Toggle("Videos", isOn: $autoPlayVideos)
            }
            
            // CỤM 4: VOICE CALLS
            Section(header: Text("VOICE CALLS").font(.footnote).foregroundColor(.gray)) {
                NavigationLink(destination: Text("Màn hình Use Less Data")) {
                    HStack {
                        Text("Use Less Data")
                        Spacer()
                        Text("Never").foregroundColor(.gray)
                    }
                }
            }
            
            // CỤM 5: OTHER
            Section(header: Text("OTHER").font(.footnote).foregroundColor(.gray)) {
                NavigationLink(destination: Text("Màn hình Save Incoming Photos")) {
                    Text("Save Incoming Photos")
                }
                Toggle("Save Edited Photos", isOn: $saveEditedPhotos)
            }
        }
        .navigationBarTitle("Data and Storage", displayMode: .inline)
    }
}

// Chế độ xem trước
struct DataStorageSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DataStorageSwiftUIView()
        }
    }
}
