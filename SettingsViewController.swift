import UIKit
import SwiftUI // Bắt buộc phải có để gọi được các màn hình giao diện xịn

class SettingsViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Setup giao diện cơ bản lúc mới load màn hình Setting
    }

    // 👇 TRUNG TÂM ĐIỀU KHIỂN: Hàm này sẽ bắt sóng khi ông chạm tay vào bất kỳ dòng nào
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // --- 1. NÚT BẤM SANG MÀN HÌNH PRIVACY ---
        // Nằm ở Cụm 3 (tính từ 0) - Dòng số 1 (tính từ 0)
        if indexPath.section == 3 && indexPath.row == 1 { 
            let privacyView = PrivacySwiftUIView()
            let hostingController = UIHostingController(rootView: privacyView)
            hostingController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(hostingController, animated: true)
        }
        
        // --- 2. NÚT BẤM SANG MÀN HÌNH APPEARANCE ---
        // Nằm ở Cụm 3 (tính từ 0) - Dòng số 3 (tính từ 0)
        if indexPath.section == 3 && indexPath.row == 3 { 
            let appearanceView = AppearanceSwiftUIView()
            let hostingController = UIHostingController(rootView: appearanceView)
            hostingController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(hostingController, animated: true)
        }
        
        // --- NÚT BẤM SANG MÀN HÌNH DATA AND STORAGE ---
        // Nằm ở Cụm 3 (tính từ 0) - Dòng số 2 (tính từ 0)
        if indexPath.section == 3 && indexPath.row == 2 { 
            let dataView = DataStorageSwiftUIView()
            let hostingController = UIHostingController(rootView: dataView)
            hostingController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(hostingController, animated: true)
        }
        
        // Sau này ông muốn làm thêm dòng Data and Storage (Row 2) 
        // thì cứ copy thêm một cái cục if y hệt như trên rồi đổi số là xong!
    }
}
