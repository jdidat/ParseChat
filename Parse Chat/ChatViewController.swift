//
//  ChatViewController.swift
//  Parse Chat
//
//  Created by Jackson Didat on 2/6/18.
//  Copyright © 2018 jdidat. All rights reserved.
//

import UIKit
import Parse
import AlamofireImage

class ChatViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var TableView: UITableView!
    @IBOutlet weak var messageBox: UITextField!
    
    var messages: [PFObject] = []
    let refreshControl = UIRefreshControl()
    
    @IBAction func sendButton(_ sender: Any) {
        let chatMessage = PFObject(className: "Message")
        chatMessage["text"] = messageBox.text ?? ""
        chatMessage["user"] = PFUser.current()
        chatMessage.saveInBackground { (success, error) in
            if success {
                print("The message was saved!")
            } else if let error = error {
                print("Problem saving message: \(error.localizedDescription)")
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        messageBox.layer.cornerRadius = 10
        TableView.dataSource = self
        TableView.delegate = self
        // Auto size row height based on cell autolayout constraints
        TableView.rowHeight = UITableViewAutomaticDimension
        // Provide an estimated row height. Used for calculating scroll indicator
        TableView.estimatedRowHeight = 50
        getMessages()
    }
    
    @objc func getMessages() {
        DispatchQueue.global().asyncAfter(deadline: DispatchTime(uptimeNanoseconds: UInt64(1e9))) {
            let query = PFQuery(className: "Message")
            query.addDescendingOrder("createdAt")
            query.includeKey("user")
            query.findObjectsInBackground(block: { (messages, error) in
                if let error = error {
                    print(error.localizedDescription)
                    self.getMessages()
                    self.refreshControl.endRefreshing()
                } else if let messages = messages {
                    self.messages = messages
                    DispatchQueue.main.async {
                        self.TableView.reloadData()
                        self.getMessages()
                        self.refreshControl.endRefreshing()
                    }
                }
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatCell
        
        let message = messages[indexPath.row]
        
        if let user = message["user"] as? PFUser {
            // User found! update username label with username
            cell.usernameLabel.text = user.username
        } else {
            // No user found, set default username
            cell.usernameLabel.text = "🤖"
        }
        
        
        cell.chatLabel.text = message["text"] as? String ?? ""
        cell.chatLabel.sizeToFit()
        
        //cell.chatView.layer.cornerRadius = 16
        
        return cell
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
