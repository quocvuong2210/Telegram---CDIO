import UIKit

class ChatsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    struct Chat {
        let name: String
        let lastMessage: String
        let time: String
        let avatarImage: UIImage?
    }

    let chatList: [Chat] = [
        Chat(name: "Cao Hai", lastMessage: "Hello", time: "10:00", avatarImage: UIImage(named: "avatar1")),
        Chat(name: "Bánh Qui", lastMessage: "Dậy code tiếp đi", time: "Fri", avatarImage: UIImage(named: "avatar2")),
        Chat(name: "Kim Hoàng", lastMessage: "Làm bài xong chưa?", time: "Mon", avatarImage: UIImage(named: "avatar3")),
        Chat(name: "Cường Wibu", lastMessage: "Cho em theo anh đi", time: "10:00", avatarImage: UIImage(named: "avatar4")),
        Chat(name: "Anh 7", lastMessage: "Siuuuuuuuuu", time: "9:00", avatarImage: UIImage(named: "avatar1")),
        Chat(name: "Kento Momota", lastMessage: "Badminton is fun", time: "7:30", avatarImage: UIImage(named: "avatar2"))
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }
}

extension ChatsViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatCell
        let chat = chatList[indexPath.row]
        
        cell.nameLabel.text = chat.name
        cell.messageLabel.text = chat.lastMessage
        cell.timeLabel.text = chat.time
        cell.avatarImageView.image = chat.avatarImage
        cell.statusLabel.text = "online"
        cell.statusLabel.textColor = .systemBlue 
        
        return cell
    }

    // --- FIX LỖI ẨN THANH 4 NÚT KHI ẤN 1S ---
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedChat = chatList[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let chatDetailVC = storyboard.instantiateViewController(withIdentifier: "ChatDetailVC") as? ChatDetailViewController {
            chatDetailVC.chatData = selectedChat
            
            // 👇 SỬA LỖI TẠI ĐÂY: Phải dùng đúng biến 'chatDetailVC'
            chatDetailVC.hidesBottomBarWhenPushed = true 
            
            self.navigationController?.pushViewController(chatDetailVC, animated: true)
        }
    }

    // --- FIX LỖI TRUYỀN DATA KHI NHẤN GIỮ 2S ---
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let chat = chatList[indexPath.row]
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let previewVC = storyboard.instantiateViewController(withIdentifier: "ChatDetailVC") as? ChatDetailViewController {
                
                // 👉 PHẢI TRUYỀN DATA VÀO ĐÂY THÌ MÀN 2S MỚI HIỆN TÊN + AVATAR ĐƯỢC
                previewVC.chatData = chat 
                return previewVC
            }
            return nil
        }) { _ in
            let unread = UIAction(title: "Đánh dấu là chưa đọc", image: UIImage(systemName: "envelope.badge")) { _ in }
            let mute = UIAction(title: "Tắt thông báo", image: UIImage(systemName: "bell.slash")) { _ in }
            let archive = UIAction(title: "Lưu trữ", image: UIImage(systemName: "archivebox")) { _ in }
            let delete = UIAction(title: "Xóa", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in }
            let block = UIAction(title: "Chặn", image: UIImage(systemName: "nosign"), attributes: .destructive) { _ in }
            
            return UIMenu(title: "", children: [unread, mute, archive, delete, block])
        }
    }
}
