import UIKit

class ChatDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // Nối dây TableView từ Storyboard vào đây
    @IBOutlet weak var tableView: UITableView!
    
    var chatData: ChatsViewController.Chat?
    
    struct Message {
        let text: String
        let time: String
        let isIncoming: Bool
    }
    
    let messages = [
        Message(text: "Good morning!\nDo you know what time is it?", time: "11:40", isIncoming: true),
        Message(text: "It's morning in Tokyo 😎", time: "11:43", isIncoming: false),
        Message(text: "What is the most popular meal in Japan?", time: "11:45", isIncoming: true),
        Message(text: "Do you like it?", time: "11:45", isIncoming: true)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1. Setup cơ bản
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        
        // 2. Tuyệt kỹ "Tàng hình": Lột áo TableView để hiện ảnh nền Telegram
        tableView.backgroundColor = .clear 
        
        // 3. Tối ưu chiều cao bong bóng
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        
        // 4. Tuyệt chiêu ép kích thước cho bản xem trước 2s (Lơ lửng như mẫu)
        // Chiều cao 380-400 là đẹp nhất cho 4 tin nhắn của ông
        self.preferredContentSize = CGSize(width: self.view.frame.width, height: 350)
        
        setupNavigationBar()
        tableView.reloadData()
        
        // 5. Tự động cuộn xuống cuối cùng để tin nhắn nằm sát thanh Input Bar
        DispatchQueue.main.async {
            if self.messages.count > 0 {
                let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
            }
        }
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
    
    func setupNavigationBar() {
        guard let chat = chatData else { return }
        
        // Tạo Avatar góc phải (Đã bo tròn)
        let avatarImageView = UIImageView(image: chat.avatarImage)
        avatarImageView.frame = CGRect(x: 0, y: 0, width: 36, height: 36)
        avatarImageView.layer.cornerRadius = 18 
        avatarImageView.clipsToBounds = true
        let rightBarBtn = UIBarButtonItem(customView: avatarImageView)
        self.navigationItem.rightBarButtonItem = rightBarBtn
        
        // Tạo Tên và "last seen" ở giữa
        let nameLabel = UILabel()
        nameLabel.text = chat.name
        nameLabel.font = .boldSystemFont(ofSize: 16)
        
        let statusLabel = UILabel()
        statusLabel.text = "last seen just now"
        statusLabel.font = .systemFont(ofSize: 12)
        statusLabel.textColor = .gray
        
        let stackView = UIStackView(arrangedSubviews: [nameLabel, statusLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        self.navigationItem.titleView = stackView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        let cellIdentifier = message.isIncoming ? "IncomingCell" : "OutgoingCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ChatMessageCell
        
        // Đổ data
        cell.messageLabel.text = message.text
        cell.timeLabel.text = message.time
        
        // Đảm bảo nền của từng dòng cũng trong suốt để thấy ảnh nền Rectangle
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        
        return cell
    }
}
