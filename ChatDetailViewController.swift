
import UIKit

class ChatDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    struct Message {
        let text: String
        let isIncoming: Bool
        let time: String
    }
    
    let messages = [
        Message(text: "Japan looks amazing!", isIncoming: true, time: "10:10"),
        Message(text: "It's morning in Tokyo 🗼", isIncoming: false, time: "11:43"),
        Message(text: "Do you like it?", isIncoming: true, time: "11:45")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        
        self.preferredContentSize = CGSize(width: UIScreen.main.bounds.width, height: 500)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80 
    }

    // MARK: - TableView Methods

func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return messages.count 
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let message = messages[indexPath.row]

    let cellIdentifier = message.isIncoming ? "IncomingCell" : "OutgoingCell"
    
    let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ChatMessageCell
    
    cell.messageLabel.text = message.text 
    cell.timeLabel.text = message.time
    
    return cell
}
}
