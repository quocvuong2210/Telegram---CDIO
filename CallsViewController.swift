import UIKit
import SwiftUI 

class CallsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swiftUIView = CallsSwiftUIView()
        
        let hostingController = UIHostingController(rootView: swiftUIView)
        
        addChild(hostingController)
        view.addSubview(hostingController.view)
        
        hostingController.view.frame = view.bounds
        hostingController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        hostingController.didMove(toParent: self)
    }
}
