//
//  ChatViewController.swift
//  ParseChat
//
//  Created by Simona Virga on 2/1/18.
//  Copyright © 2018 Simona Virga. All rights reserved.
//

import UIKit
import Parse

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
  
  @IBOutlet weak var textMessageTextField: UITextField!
  @IBOutlet weak var tableView: UITableView!
  let logoutAlert = UIAlertController(title: "Confirm", message: "Are you sure you want to log out?", preferredStyle: .alert)
  

  var messages: [PFObject] = []
  var refreshController: UIRefreshControl!
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    tableView.dataSource = self
    tableView.delegate = self
    
    let logoutAction = UIAlertAction(title: "Log Out", style: .destructive) { (action) in
      NotificationCenter.default.post(name: NSNotification.Name("didLogout"), object: nil)
    }
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
    }
    logoutAlert.addAction(logoutAction)
    logoutAlert.addAction(cancelAction)
    
    tableView.rowHeight = UITableViewAutomaticDimension
    
    tableView.estimatedRowHeight = 70
    
    
    refreshController = UIRefreshControl()
    refreshController.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
    tableView.insertSubview(refreshController, at: 0)
    
   
    getTextMessages()
    
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return messages.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell") as! ChatCell
    
    
    cell.chatLabel.text = messages[indexPath.row]["text"] as! String?
    if let user = messages[indexPath.row]["user"] as? PFUser {
      cell.userLabel.text = user.username
    } else
    {
      cell.userLabel.text = "🤖"
    }
    
    return cell
  }
  
  @IBAction func sendPressed(_ sender: Any)
  {
        
    let chatMessage = PFObject(className: "Message")
    chatMessage["user"] = PFUser.current()
    chatMessage["text"] = textMessageTextField.text ?? ""
    
    chatMessage.saveInBackground { (success, error) in
      if success {
        print("The message was saved!")
        
        self.textMessageTextField.text = ""
        
      } else if let error = error {
        print("Problem saving message: \(error.localizedDescription)")
      }
    }
    
    getTextMessages()
  }
  
  @IBAction func onLogOut(_ sender: Any)
  {
    present(logoutAlert, animated: true)
    {
    }
  }
  
  @objc func refreshControlAction(_ refreshControl: UIRefreshControl)
  {
    
    getTextMessages()
    
    tableView.reloadData()
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.75)
    {
      self.refreshController.endRefreshing()
    }
    
  }
  
  
  @objc func getTextMessages()
  {
    let query = PFQuery(className: "Message")
    query.includeKey("user")
    query.addDescendingOrder("createdAt")
    
    query.findObjectsInBackground { (messages: [PFObject]?, error: Error?) in
      if error != nil {
        print("Error: \(error?.localizedDescription ?? "")")
      } else {
        self.messages = messages!
        DispatchQueue.main.async {
          self.tableView.reloadData()
        }
      }
    }
  }
  
  override func didReceiveMemoryWarning()
  {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
}
