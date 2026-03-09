import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    struct ChatMessage {
        let name: String
        let message: String
        let time: String
        let imageName: String
        let isSender: Bool
    }
    
    // Bien luu data danh sach tin nhan
    var chatData = [
        ChatMessage(name: "Cao Hai", message: "Hello", time: "10:00", imageName: "avatar1", isSender: false),
        ChatMessage(name: "Bánh Qui", message: "Dậy code tiếp đi", time: "Fri", imageName: "avatar2", isSender: true),
        ChatMessage(name: "Kim Hoàng", message: "Làm bài xong chưa?", time: "Mon", imageName: "avatar3", isSender: false),
        ChatMessage(name: "Cường Wibu", message: "Cho em theo anh đi", time: "10:00", imageName: "avatar3", isSender: false),
        ChatMessage(name: "Anh 7", message: "Siuuuuuuuuu", time: "9:00", imageName: "avatar4", isSender: true),
        ChatMessage(name: "Kento Momota", message: "Badminton is fun", time: "7:30", imageName: "avatar1", isSender: false),
        ChatMessage(name: "Kento Momota", message: "Badminton is fun", time: "7:30", imageName: "avatar3", isSender: true)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Xoa dong ke thua o cuoi
        tableView.tableFooterView = UIView()
        
        // Uy quyen quan ly table view cho class nay
        tableView.delegate = self
        tableView.dataSource = self
        
        // Khoi tao thanh tim kiem
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search for messages or users"
        searchController.obscuresBackgroundDuringPresentation = false
        
        // Gan thanh tim kiem vao thanh dieu huong
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        definesPresentationContext = true
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Chat"
        navigationItem.largeTitleDisplayMode = .always
    }
    
    // Ham chuan bi du lieu truoc khi chuyen man hinh bang Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetail",
           let destinationVC = segue.destination as? ChatDetailViewController,
           let chatInfor = sender as? ChatMessage {
            
            // Truyen ten va hinh anh vao bien tu tao, KHONG dung .title nua
            destinationVC.chatName = chatInfor.name
            destinationVC.chatAvatar = chatInfor.imageName
            
            // An Tab Bar (Dong nay ong giu dung roi ne)
            destinationVC.hidesBottomBarWhenPushed = true
        }
    }
    
    @IBAction func editBtnTapped(_ sender: Any) {}
    @IBAction func composeBtnTapped(_ sender: Any) {}
    

    
    // Ham xu ly xoa
    func handleDelete(at indexPath: IndexPath) {
        chatData.remove(at: indexPath.row) // Xoa data truoc
        tableView.deleteRows(at: [indexPath], with: .left) // Hieu ung xoa hang tren giao dien
    }
    
    // Ham xu ly luu tru 
    func handleArchive(at indexPath: IndexPath) {
        chatData.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade) 
    }
    
    // Ham xu ly tat thong bao
    func handleMute(at indexPath: IndexPath) {
        let name = chatData[indexPath.row].name
        print("Da tat thong bao cua \(name)")
        // Load lai dong do de cap nhat UI
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        // Tao man hinh xem truoc (Preview)
        let previewProvider: () -> UIViewController? = {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let detailVC = storyboard.instantiateViewController(withIdentifier: "ChatDetailVC") as? ChatDetailViewController {
                let chatItem = self.chatData[indexPath.row]
                detailVC.title = chatItem.name
                return detailVC
            }
            return nil
        }
        
        // Tao cac nut trong menu tha xuong
        return UIContextMenuConfiguration(identifier: nil, previewProvider: previewProvider) { suggestedActions in
            let markUnread = UIAction(title: "Đánh dấu là chưa đọc", image: UIImage(systemName: "envelope.badge")) { _ in }
            
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
            
            return UIMenu(title: "", children: [markUnread, mute, archive, delete, block])
        }
    }
    
    // Chinh do cao 1 dong chat
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedNam = chatData[indexPath.row]
        
        // Da xoa doan code hien UIAlertController gay ra loi crash
        // Thuc hien chuyen man hinh luon bang Segue
        performSegue(withIdentifier: "goToDetail", sender: selectedNam)
        
        // Bo hieu ung to mau xam sau khi bam
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // 2. MENU VUOT NGANG (SWIPE ACTIONS)
    // Vuot tu phai sang trai
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
        // Cam vuot max man hinh de luon hien menu
        config.performsFirstActionWithFullSwipe = false
        return config
    }
    
    // Vuot tu trai sang phai
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let pinAction = UIContextualAction(style: .normal, title: "Pin") { _, _, completion in completion(true) }
        pinAction.backgroundColor = .systemGreen
        pinAction.image = UIImage(systemName: "pin.fill")
        
        let unreadAction = UIContextualAction(style: .normal, title: "Unread") { _, _, completion in completion(true) }
        unreadAction.backgroundColor = .systemBlue
        unreadAction.image = UIImage(systemName: "message.badge.fill")
        
        let config = UISwipeActionsConfiguration(actions: [unreadAction, pinAction])
        // Cam vuot max man hinh de luon hien menu
        config.performsFirstActionWithFullSwipe = false
        return config
    }
}

extension ViewController: UITableViewDataSource {
    // So luong dong can ve
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatData.count
    }
    
    // Do du lieu vao tung dong
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatCell
        let chat = chatData[indexPath.row]
        
        let attachment = NSTextAttachment()
        attachment.image = UIImage(systemName: "pin.fill")?.withTintColor(.lightGray)
        let imageString = NSAttributedString(attachment: attachment)
        
        cell.nameLabel.text = chat.name
        cell.messageLabel.text = chat.message
        cell.timeLabel.text = chat.time
        
        cell.avatarImageView.image = UIImage(named: chat.imageName)
        cell.avatarImageView.layer.cornerRadius = cell.avatarImageView.frame.height / 2
        cell.avatarImageView.clipsToBounds = true
        
        cell.statusLabel.attributedText = imageString
        
        return cell
    }
    
    // Mo khoa chuc nang vuot
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Ham bu nhin de chong loi vuot tren may that
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    }
}
