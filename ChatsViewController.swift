import UIKit

struct Message {
    let text: String
    let time: String
    let isIncoming: Bool
}

class ChatsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    struct Chat {
        let name: String
        let avatarName: String
        let messages: [Message]

        var lastMessage: String {
            return messages.last?.text ?? "Chưa có tin nhắn"
        }
        var time: String {
            return messages.last?.time ?? ""
        }
    }

    var chatList: [Chat] = [
        Chat(name: "Cao Hai", avatarName: "avatar1", messages: [
            Message(text: "Ê đang làm gì đó?", time: "09:50", isIncoming: true),
            Message(text: "Đang fix bug app Telegram", time: "09:55", isIncoming: false),
            Message(text: "Hello", time: "10:00", isIncoming: true) 
        ]),
        
        Chat(name: "Bánh Qui", avatarName: "avatar2", messages: [
            Message(text: "Tối qua chạy deadline tới mấy giờ?", time: "Thu", isIncoming: true),
            Message(text: "Tới 2h sáng lận, buồn ngủ vãi", time: "Thu", isIncoming: false),
            Message(text: "Dậy code tiếp đi", time: "Fri", isIncoming: true)
        ]),
        
        Chat(name: "Kim Hoàng", avatarName: "avatar3", messages: [
            Message(text: "Deadline OOP là khi nào vậy?", time: "Mon", isIncoming: false),
            Message(text: "Làm bài xong chưa?", time: "Mon", isIncoming: true)
        ]),
        
        Chat(name: "Cường Wibu", avatarName: "avatar4", messages: [
            Message(text: "Hôm nay có tập Thôn Phệ Tinh Không mới đó", time: "09:00", isIncoming: true),
            Message(text: "Xem rồi, đỉnh vãi!", time: "09:30", isIncoming: false),
            Message(text: "Cho em theo anh đi", time: "10:00", isIncoming: true)
        ]),
        
        Chat(name: "Anh 7", avatarName: "avatar1", messages: [
            Message(text: "Nay đá giải không anh?", time: "8:00", isIncoming: false),
            Message(text: "Siuuuuuuuuu", time: "9:00", isIncoming: true)
        ]),
        
        Chat(name: "Kento Momota", avatarName: "avatar2", messages: [
            Message(text: "Mai làm trận cầu lông nhé?", time: "7:00", isIncoming: false),
            Message(text: "Badminton is fun", time: "7:30", isIncoming: true)
        ])
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
        cell.avatarImageView.image = UIImage(named: chat.avatarName)
        cell.statusLabel.text = "online"
        cell.statusLabel.textColor = .systemBlue 
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedChat = chatList[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let chatDetailVC = storyboard.instantiateViewController(withIdentifier: "ChatDetailVC") as? ChatDetailViewController {
            chatDetailVC.chatName = selectedChat.name
            chatDetailVC.chatAvatar = selectedChat.avatarName
            chatDetailVC.messages = selectedChat.messages 
            
            chatDetailVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(chatDetailVC, animated: true)
        }
    }

    // ==========================================
    // MARK: - LOGIC XỬ LÝ VUỐT (HELPER FUNCTIONS)
    // ==========================================
    func handleDelete(at indexPath: IndexPath) {
        chatList.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .left)
    }
    
    func handleArchive(at indexPath: IndexPath) {
        chatList.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    func handleMute(at indexPath: IndexPath) {
        let name = chatList[indexPath.row].name
        print("Đã tắt thông báo của \(name)")
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }

    // ==========================================
    // MARK: - GIAO DIỆN VUỐT TRÁI / PHẢI
    // ==========================================
    
    // Bắt buộc phải có hàm này để mở khóa tính năng vuốt
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Vuốt từ Phải sang Trái (Delete, Mute, Archive)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completion in
            self?.handleDelete(at: indexPath)
            completion(true)
        }
        deleteAction.image = UIImage(systemName: "trash.fill")
        
        let muteAction = UIContextualAction(style: .normal, title: "Mute") { [weak self] _, _, completion in
            self?.handleMute(at: indexPath)
            completion(true)
        }
        muteAction.backgroundColor = .systemOrange
        muteAction.image = UIImage(systemName: "bell.slash.fill")
        
        let archiveAction = UIContextualAction(style: .normal, title: "Archive") { [weak self] _, _, completion in
            self?.handleArchive(at: indexPath)
            completion(true)
        }
        archiveAction.backgroundColor = .systemGray
        archiveAction.image = UIImage(systemName: "archivebox.fill")
        
        let config = UISwipeActionsConfiguration(actions: [deleteAction, muteAction, archiveAction])
        config.performsFirstActionWithFullSwipe = false // Chống vuốt lố
        return config
    }
    
    // Vuốt từ Trái sang Phải (Unread, Pin)
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let pinAction = UIContextualAction(style: .normal, title: "Pin") { _, _, completion in completion(true) }
        pinAction.backgroundColor = .systemGreen
        pinAction.image = UIImage(systemName: "pin.fill")
        
        let unreadAction = UIContextualAction(style: .normal, title: "Unread") { _, _, completion in completion(true) }
        unreadAction.backgroundColor = .systemBlue
        unreadAction.image = UIImage(systemName: "message.badge.fill")
        
        let config = UISwipeActionsConfiguration(actions: [unreadAction, pinAction])
        config.performsFirstActionWithFullSwipe = false // Chống vuốt lố
        return config
    }

    // ==========================================
    // MARK: - MENU NHẤN GIỮ (CONTEXT MENU)
    // ==========================================
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let chat = chatList[indexPath.row]
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let previewVC = storyboard.instantiateViewController(withIdentifier: "ChatDetailVC") as? ChatDetailViewController {
                previewVC.chatName = chat.name
                previewVC.chatAvatar = chat.avatarName
                previewVC.messages = chat.messages
                return previewVC
            }
            return nil
        }) { _ in
            let unread = UIAction(title: "Đánh dấu là chưa đọc", image: UIImage(systemName: "envelope.badge")) { _ in }
            
            let mute = UIAction(title: "Tắt thông báo", image: UIImage(systemName: "bell.slash")) { [weak self] _ in
                self?.handleMute(at: indexPath)
            }
            
            let archive = UIAction(title: "Lưu trữ", image: UIImage(systemName: "archivebox")) { [weak self] _ in
                self?.handleArchive(at: indexPath)
            }
            
            let delete = UIAction(title: "Xóa", image: UIImage(systemName: "trash"), attributes: .destructive) { [weak self] _ in
                self?.handleDelete(at: indexPath)
            }
            
            let block = UIAction(title: "Chặn", image: UIImage(systemName: "nosign"), attributes: .destructive) { _ in }
            
            return UIMenu(title: "", children: [unread, mute, archive, delete, block])
        }
    }
}


