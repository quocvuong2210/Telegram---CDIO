import UIKit
import SwiftUI // Bắt buộc phải có dòng này

class CallsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1. Gọi cái màn hình SwiftUI xịn xò ông vừa làm ra
        let swiftUIView = CallsSwiftUIView()
        
        // 2. Bọc nó vào một cái vỏ UIKit (UIHostingController)
        let hostingController = UIHostingController(rootView: swiftUIView)
        
        // 3. Nhét cái vỏ đó vào màn hình Calls hiện tại
        addChild(hostingController)
        view.addSubview(hostingController.view)
        
        // 4. Kéo dãn cho nó phủ kín toàn bộ màn hình
        hostingController.view.frame = view.bounds
        hostingController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // 5. Chốt hạ báo cho hệ thống biết đã nhúng xong
        hostingController.didMove(toParent: self)
    }
}
