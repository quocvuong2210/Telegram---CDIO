import UIKit

class ChatDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    
    // Các biến hứng data từ màn hình ngoài truyền vào
    var chatName: String = ""
    var chatAvatar: String = ""
    var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        
        self.preferredContentSize = CGSize(width: self.view.frame.width, height: 300)
        
        setupNavigationBar()
        tableView.reloadData()
        
        // Cuộn xuống tin nhắn cuối cùng khi vừa vào
        DispatchQueue.main.async {
            self.scrollToBottom(animated: false)
        }
        
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
    
    func setupNavigationBar() {
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
        
        let avatarImageView = UIImageView(image: UIImage(named: chatAvatar))
        avatarImageView.frame = containerView.bounds
        avatarImageView.layer.cornerRadius = 18
        avatarImageView.clipsToBounds = true
        avatarImageView.contentMode = .scaleAspectFill
        containerView.addSubview(avatarImageView)

        avatarImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(avatarTapped))
        avatarImageView.addGestureRecognizer(tapGesture)
        
        let rightBarBtn = UIBarButtonItem(customView: containerView)
        self.navigationItem.rightBarButtonItem = rightBarBtn
        
        let nameLabel = UILabel()
        nameLabel.text = chatName 
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
    
    // --- CHUYỂN TRANG INFO ---
    @objc func avatarTapped() {
        print("Đã bấm vào Avatar góc phải!")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // Nhớ đảm bảo cái màn Info trên Storyboard có ID là InfoVC nha
        if let infoVC = storyboard.instantiateViewController(withIdentifier: "InfoVC") as? InfoViewController {
            // Truyền tên và avatar sang cho InfoVC
            infoVC.infoName = self.chatName
            infoVC.infoAvatar = self.chatAvatar
            
            infoVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(infoVC, animated: true)
        }
    }
    
    // --- GỬI TIN NHẮN ---
    @IBAction func sendButtonTapped(_ sender: Any) {
        guard let text = messageTextField.text, !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let currentTime = formatter.string(from: Date())
        
        let newMessage = Message(text: text, time: currentTime, isIncoming: false)
        messages.append(newMessage)
        
        let newIndexPath = IndexPath(row: messages.count - 1, section: 0)
        tableView.insertRows(at: [newIndexPath], with: .bottom)
        
        scrollToBottom(animated: true)
        
        messageTextField.text = ""
    }
    
    // Hàm hỗ trợ: Tự động cuộn bảng xuống dòng cuối cùng
    func scrollToBottom(animated: Bool) {
        if messages.count > 0 {
            let indexPath = IndexPath(row: messages.count - 1, section: 0)
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: animated)
        }
    }
    
    // --- VẼ BẢNG TIN NHẮN DỰA TRÊN DATA VỪA HỨNG ĐƯỢC ---
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        let cellIdentifier = message.isIncoming ? "IncomingCell" : "OutgoingCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ChatMessageCell
        
        cell.messageLabel.text = message.text
        cell.timeLabel.text = message.time
        
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        
        return cell
    }
}
