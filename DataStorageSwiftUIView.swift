import SwiftUI

struct DataStorageSwiftUIView: View {
    @State private var autoPlayGIFs = false
    @State private var autoPlayVideos = false
    @State private var saveEditedPhotos = false
    
    var body: some View {
        Form {
            Section {
                NavigationLink(destination: Text("Màn hình Storage Usage")) {
                    Text("Storage Usage")
                }
                NavigationLink(destination: Text("Màn hình Network Usage")) {
                    Text("Network Usage")
                }
            }
            
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
                
                Button(action: {
                    print("Đã bấm Reset")
                }) {
                    Text("Reset Auto-Download Settings")
                        .foregroundColor(.blue)
                }
            }
            
            Section(header: Text("AUTO-PLAY MEDIA").font(.footnote).foregroundColor(.gray)) {
                Toggle("GIFs", isOn: $autoPlayGIFs)
                Toggle("Videos", isOn: $autoPlayVideos)
            }
            
            Section(header: Text("VOICE CALLS").font(.footnote).foregroundColor(.gray)) {
                NavigationLink(destination: Text("Màn hình Use Less Data")) {
                    HStack {
                        Text("Use Less Data")
                        Spacer()
                        Text("Never").foregroundColor(.gray)
                    }
                }
            }
            
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

struct DataStorageSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DataStorageSwiftUIView()
        }
    }
}
