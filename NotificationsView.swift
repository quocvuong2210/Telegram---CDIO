import SwiftUI

struct NotificationsView: View {
    // May cai bien @State nay de luu trang thai bat/tat cua nut gat
    @State private var allAccounts = true
    @State private var msgShowNotifications = true
    @State private var msgPreview = true
    @State private var groupShowNotifications = false
    @State private var groupPreview = false
    
    var body: some View {
        // Dung Form de iOS tu dong tao giao dien bang Cai dat chuan xin
        Form {
            // --- SECTION 1 ---
            Section(header: Text("SHOW NOTIFICATIONS FROM"),
                    footer: Text("Turn this off if you want to receive notifications only from your active account.")) {
                Toggle("All Accounts", isOn: $allAccounts)
            }
            
            // --- SECTION 2 ---
            Section(header: Text("MESSAGE NOTIFICATIONS"),
                    footer: Text("Set custom notifications for specific users.")) {
                Toggle("Show Notifications", isOn: $msgShowNotifications)
                Toggle("Message Preview", isOn: $msgPreview)
                
                // Dong chu co kem mui ten mờ mờ ben phai
                HStack {
                    Text("Sound")
                    Spacer()
                    Text("None")
                        .foregroundColor(.secondary)
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray).font(.system(size: 14))
                }
                
                HStack {
                    Text("Exceptions")
                    Spacer()
                    Text("66 chats")
                        .foregroundColor(.secondary)
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray).font(.system(size: 14))
                }
            }
            
            // --- SECTION 3 ---
            Section(header: Text("GROUP NOTIFICATIONS"),
                    footer: Text("Set custom notifications for specific groups.")) {
                Toggle("Show Notifications", isOn: $groupShowNotifications)
                Toggle("Message Preview", isOn: $groupPreview)
                
                HStack {
                    Text("Sound")
                    Spacer()
                    Text("None")
                        .foregroundColor(.secondary)
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray).font(.system(size: 14))
                }
                
                HStack {
                    Text("Exceptions")
                    Spacer()
                    Text("Add")
                        .foregroundColor(.secondary)
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray).font(.system(size: 14))
                }
            }
        }
        // Ép tiêu đề nhỏ lại cho giống Telegram
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// Cai nay de preview truc tiep tren man hinh Xcode thoi
#Preview {
    NavigationView {
        NotificationsView()
    }
}
