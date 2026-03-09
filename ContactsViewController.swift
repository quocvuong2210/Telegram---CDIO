
import UIKit

struct Contact {
    let name: String
    let status: String
    let imageName: String
}
class ContactsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var tableView: UITableView!

    let contactData = [
        Contact(name: "Add People Nearby", status: "", imageName: "icon1"),
        Contact(name: "Invite Friends", status: "", imageName: "icon2"),
        Contact(name: "Joshua Lawrence", status: "online", imageName: "avatar1"),
        Contact(name: "Andrew Parker", status: "online", imageName: "avatar2"),
        Contact(name: "Karen Castillo", status: "last seen 1 hour ago", imageName: "avatar3"),
        Contact(name: "Martha Craig", status: "last seen yesterday at 21:22", imageName: "avatar4"),
        Contact(name: "Martin Randolph", status: "online", imageName: "avatar5"),
        Contact(name: "Kieron Dotson", status: "last seen 10 minutes ago", imageName: "avatar6"),
        Contact(name: "Zack John", status: "last seen 25 minutes ago", imageName: "avatar7"),
        Contact(name: "Jamie Franco", status: "last seen 2 hour ago", imageName: "avatar8"),
        Contact(name: "Maximillian Jacobson", status: "last seen 5 hour ago", imageName: "avatar9")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as! ContactCell
        let contact = contactData[indexPath.row]
        
        cell.nameLabel.text = contact.name
        cell.statusLabel.text = contact.status
        cell.avatarImageView.image = UIImage(named: contact.imageName) 
        
        return cell
    }
    

}
