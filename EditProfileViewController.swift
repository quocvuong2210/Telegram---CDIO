//  EditProfileTableViewController.swift
//  TELEGRAM_APP_UIKIT
//
//  Created by Cao Hai on 2/3/26.
//

import UIKit

class EditProfileViewController: UITableViewController {


    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var bioTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("🚀 ĐÃ LOAD THÀNH CÔNG FILE CODE EDIT PROFILE!")
        setupAvatarGesture()
    }

    @IBAction func didTapDoneButton(_ sender: Any) {
        print("Đã bấm nút Lưu")
    }
    
    
    
    // MARK: - Setup Actions
    func setupAvatarGesture() {
        avatarImageView.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(avatarTapped))
        avatarImageView.addGestureRecognizer(tapGesture)
    }

    @objc func avatarTapped() {
        print("👉 ĐÃ BẮT ĐƯỢC SỰ KIỆN CHỌT VÀO AVATAR!")
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { _ in
            print("Đang mở Camera Roll...") 
            // TODO: COde anh o day
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Web Search", style: .default, handler: { _ in
            print("Tìm trên web...")
        }))
        
        actionSheet.addAction(UIAlertAction(title: "View Photo", style: .default, handler: { _ in
            print("Xem ảnh to...")
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Remove Photo", style: .destructive, handler: { _ in
            print("Xóa ảnh đại diện...")
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
}
