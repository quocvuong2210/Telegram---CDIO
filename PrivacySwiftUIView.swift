import SwiftUI

struct PrivacySwiftUIView: View {
    var body: some View {
        // Dùng Form để tạo giao diện cài đặt chuẩn của iOS
        Form {
            // CỤM 1: SECURITY (Không có tiêu đề)
            Section {
                SettingsIconRow(icon: "nosign", color: .red, title: "Blocked Users", value: "9")
                SettingsIconRow(icon: "laptopcomputer", color: .orange, title: "Active Sessions", value: "2")
                SettingsIconRow(icon: "faceid", color: .green, title: "Passcode & Face ID", value: "Off")
                SettingsIconRow(icon: "key.fill", color: .blue, title: "Two-Step Verification", value: "On")
            }
            
            // CỤM 2: PRIVACY (Có Header và Footer)
            Section(
                header: Text("PRIVACY").font(.footnote).foregroundColor(.gray),
                footer: Text("Change who can add you to groups and channels.")
            ) {
                SettingsTextRow(title: "Phone Number", value: "My Contacts")
                SettingsTextRow(title: "Last Seen & Online", value: "Nobody (+14)")
                SettingsTextRow(title: "Profile Photo", value: "Everybody")
                SettingsTextRow(title: "Voice Calls", value: "Nobody (+7)")
                SettingsTextRow(title: "Forwarded Messages", value: "Everybody")
                SettingsTextRow(title: "Groups & Channels", value: "Everybody")
            }
            
            // CỤM 3: XÓA TÀI KHOẢN
            Section(
                header: Text("AUTOMATICALLY DELETE MY ACCOUNT").font(.footnote).foregroundColor(.gray),
                footer: Text("If you do not come online at least once within this period, your account will be deleted along with all messages and contacts.")
            ) {
                SettingsTextRow(title: "If Away For", value: "6 months")
            }
        }
        .navigationBarTitle("Privacy and Security", displayMode: .inline)
    }
}

// 🛠️ KHUÔN ĐÚC CÓ ICON (Cho cụm 1)
struct SettingsIconRow: View {
    var icon: String
    var color: Color
    var title: String
    var value: String
    
    var body: some View {
        // Dùng NavigationLink rỗng để nó tự hiện cái dấu ">" ở cuối dòng
        NavigationLink(destination: Text("Màn hình \(title)")) {
            HStack(spacing: 12) {
                // Khung vuông bo tròn chứa Icon
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 28, height: 28)
                    .background(color)
                    .cornerRadius(6)
                
                Text(title)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Text(value)
                    .foregroundColor(.gray)
            }
        }
    }
}

// 🛠️ KHUÔN ĐÚC CHỈ CÓ TEXT (Cho cụm 2 và 3)
struct SettingsTextRow: View {
    var title: String
    var value: String
    
    var body: some View {
        NavigationLink(destination: Text("Màn hình \(title)")) {
            HStack {
                Text(title)
                    .foregroundColor(.primary)
                Spacer()
                Text(value)
                    .foregroundColor(.gray)
            }
        }
    }
}

// Xem trước ngay trong Xcode
struct PrivacySwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PrivacySwiftUIView()
        }
    }
}
