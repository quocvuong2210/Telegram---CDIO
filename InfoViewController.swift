import UIKit

class InfoViewController: UITableViewController {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel! 
    @IBOutlet weak var bioLabel: UILabel!   
    
    var infoName: String = ""
    var infoAvatar: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        nameLabel.text = infoName
        
        if infoAvatar != "" {
            avatarImageView.image = UIImage(named: infoAvatar)
        }
        
        // Bo tròn avatar 
        avatarImageView.layer.cornerRadius = avatarImageView.frame.height / 2
        avatarImageView.clipsToBounds = true
        
        // Mấy cái râu ria khác
        phoneLabel.text = "+84 987 654 321"
        bioLabel.text = "Sinh viên Công nghệ phần mềm "
    }
}
