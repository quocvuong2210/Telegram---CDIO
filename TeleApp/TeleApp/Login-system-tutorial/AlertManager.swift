//
//  AlertManager.swift
//  TeleApp
//
//  Created by Dezhun on 31/1/26.
//

import UIKit

class AlertManager {
    private static func showBasicAlert(on vc: UIViewController,title: String, massage : String?) {
        
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: massage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dimiss", style: .default, handler: nil))
            vc.present(alert, animated: true)
        }
    }
}
extension AlertManager {
    public static func showInvalidEmailAlert(on vc: UIViewController) {
        self.showBasicAlert(on: vc, title: "Invalid Email", massage: "Please enter a valid email")
    }
    public static func showInvalidPasswordAlert(on vc: UIViewController) {
        self.showBasicAlert(on: vc, title: "Invalid Password", massage: "Please enter a valid password")
    }
    public static func showInvalidUsernameAlert(on vc: UIViewController) {
        self.showBasicAlert(on: vc, title: "Invalid Username", massage: "Please enter a valid username")
    }
}

extension AlertManager {
    public static func showRegistrationErrorAlert(on vc: UIViewController) {
        self.showBasicAlert(on: vc, title: "Unknow Registration Error", massage: nil)
    }
    public static func showRegistrationErrorAlert(on vc: UIViewController, with error : Error) {
        self.showBasicAlert(on: vc, title: "Unknow Registration Error", massage: "\(error.localizedDescription)")
    }
}
extension AlertManager {
    public static func showSignInErrorAlert(on vc: UIViewController) {
        self.showBasicAlert(on: vc, title: "Unknow Signing In Error", massage: nil)
    }
    public static func showSignInErrorAlert(on vc: UIViewController, with error : Error) {
        self.showBasicAlert(on: vc, title: "Signing In Error", massage: "\(error.localizedDescription)")
    }
}
extension AlertManager {
    public static func showLogoutError(on vc: UIViewController, with error : Error) {
        self.showBasicAlert(on: vc, title: "Logout Error", massage: "\(error.localizedDescription)")
    }
}
extension AlertManager {
    public static func showPasswordResetSend(on vc: UIViewController) {
        self.showBasicAlert(on: vc, title: "Password Reset Sent", massage: nil)
    }
    public static func showErrorSendingPasswordReset(on vc: UIViewController, with error : Error) {
        self.showBasicAlert(on: vc, title: "Error Sending Password Reset", massage: "\(error.localizedDescription)")
    }
}
extension AlertManager {
    public static func showFetchingUserError(on vc: UIViewController, with error : Error) {
        self.showBasicAlert(on: vc, title: "Error Fetching User", massage: "\(error.localizedDescription)")
    }
    public static func showUnknownFetchingUserError(on vc: UIViewController) {
        self.showBasicAlert(on: vc, title: "Unknwon Error Fetching User", massage: nil)
    }
}
