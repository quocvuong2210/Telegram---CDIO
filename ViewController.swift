
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
    let chatData = [
    ChatMessage(name: "Cao Hai", message: "Hello", time: "10:00", imageName: "Image 1", isSender: false),
    ChatMessage(name: "Bánh Qui", message: "Dậy code tiếp đi", time: "Fri", imageName: "Image 2", isSender: true),
    ChatMessage(name: "Kim Hoàng", message: "Làm bài xong chưa?", time: "Mon", imageName: "Image 2", isSender: false),
    ChatMessage(name: "Cường Wibu", message: "Cho em theo anh đi", time: "10:00", imageName: "Image 2", isSender: false),
    ChatMessage(name: "Anh 7", message: "Siuuuuuuuuu", time: "9:00", imageName: "Image 2", isSender: true),
    ChatMessage(name: "Kento Momota", message: "Badminton is fun", time: "7:30", imageName: "Image 2", isSender: false),
    ChatMessage(name: "Kento Momota", message: "Badminton is fun", time: "7:30", imageName: "Image 2", isSender: true)
]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search for messages or users"
        searchController.obscuresBackgroundDuringPresentation = false
        
        navigationItem.searchController = searchController
        
        navigationItem.hidesSearchBarWhenScrolling = false
        
        definesPresentationContext = true
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Chat"
        navigationItem.largeTitleDisplayMode = .always
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetail",
            let destinationVC = segue.destination as? ChatDetailViewController,
            let chatInfor = sender as? ChatMessage {
                destinationVC.title = chatInfor.name
        }
    }
 
    @IBAction func editBtnTapped(_ sender: Any) {
    }
    
    @IBAction func composeBtnTapped(_ sender: Any) {
    }
    
    


}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
    
    let previewProvider: () -> UIViewController? = {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let detailVC = storyboard.instantiateViewController(withIdentifier: "ChatDetailVC") as? ChatDetailViewController {
            
            let chatItem = self.chatData[indexPath.row]
            detailVC.title = chatItem.name
            
            return detailVC
        }
        return nil
    }
    
    return UIContextMenuConfiguration(identifier: nil, previewProvider: previewProvider) { suggestedActions in
        
        let markUnread = UIAction(title: "Đánh dấu là chưa đọc", image: UIImage(systemName: "envelope.badge")) { _ in }
        let mute = UIAction(title: "Tắt thông báo", image: UIImage(systemName: "bell.slash")) { _ in }
        let archive = UIAction(title: "Lưu trữ", image: UIImage(systemName: "archivebox")) { _ in }
        let delete = UIAction(title: "Xóa", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in }
        let block = UIAction(title: "Chặn", image: UIImage(systemName: "nosign"), attributes: .destructive) { _ in }
        
        return UIMenu(title: "", children: [markUnread, mute, archive, delete, block])
    }
}
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 95
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedNam = chatData[indexPath.row]
        
        let alert = UIAlertController(title: "Vào cuộc trò chuyện với\(selectedNam.name)", message: "Bạn đang mở cuộc trò chuyện với \(selectedNam.name)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
        
        performSegue(withIdentifier: "goToDetail", sender: selectedNam)
        
         
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, completion in completion(true) }
        deleteAction.image = UIImage(systemName: "trash.fill")
        
        let muteAction = UIContextualAction(style: .normal, title: "Mute") { _, _, completion in completion(true) }
        muteAction.backgroundColor = .systemOrange
        muteAction.image = UIImage(systemName: "bell.slash.fill")
        
        let archiveAction = UIContextualAction(style: .normal, title: "Archive") { _, _, completion in completion(true) }
        archiveAction.backgroundColor = .systemGray
        archiveAction.image = UIImage(systemName: "archivebox.fill")
        
        return UISwipeActionsConfiguration(actions: [deleteAction, muteAction, archiveAction])
    }

    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let pinAction = UIContextualAction(style: .normal, title: "Pin") { _, _, completion in completion(true) }
        pinAction.backgroundColor = .systemGreen
        pinAction.image = UIImage(systemName: "pin.fill")
        
        let unreadAction = UIContextualAction(style: .normal, title: "Unread") { _, _, completion in completion(true) }
        unreadAction.backgroundColor = .systemBlue
        unreadAction.image = UIImage(systemName: "message.badge.fill")
        
        return UISwipeActionsConfiguration(actions: [unreadAction, pinAction])
    }
    
    
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatData.count
    }
    
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
    
}

