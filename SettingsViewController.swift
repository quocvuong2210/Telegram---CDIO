import UIKit
import SwiftUI

class SettingsViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // 👇 Them dong nay de bam vao no tu dong nha mau xam ra cho muot
        tableView.deselectRow(at: indexPath, animated: true)

        // --- 0. NOTIFICATIONS AND SOUNDS ---
        if indexPath.section == 3 && indexPath.row == 0 { 
            let notiView = NotificationsView() // Cai man hinh SwiftUI anh em minh vua tao
            let hostingController = UIHostingController(rootView: notiView)
            hostingController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(hostingController, animated: true)
        }

        // --- 1. PRIVACY AND SECURITY ---
        if indexPath.section == 3 && indexPath.row == 1 { 
            let privacyView = PrivacySwiftUIView()
            let hostingController = UIHostingController(rootView: privacyView)
            hostingController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(hostingController, animated: true)
        }
        
        // --- 2. DATA AND STORAGE ---
        if indexPath.section == 3 && indexPath.row == 2 { 
            let dataView = DataStorageSwiftUIView()
            let hostingController = UIHostingController(rootView: dataView)
            hostingController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(hostingController, animated: true)
        }

        // --- 3. APPEARANCE ---
        if indexPath.section == 3 && indexPath.row == 3 { 
            let appearanceView = AppearanceSwiftUIView()
            let hostingController = UIHostingController(rootView: appearanceView)
            hostingController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(hostingController, animated: true)
        }
    }
}
