//
//  ViewController.swift
//  PhotoScavengerHunt
//
//  Created by Ujjwal Adhikari on 2/15/23.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var tasks = [Tasks]() {
        didSet {
            tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tasks = Tasks.tasks
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // This will reload data in order to reflect any changes made to a task after returning from the detail screen.
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let task = tasks[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier:"cell", for: indexPath) as! CustomTableViewCell
        cell.configure(with:task)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ComposeSegue" {
        
        // Since the segue is connected to the navigation controller that manages the ComposeViewController
        // we need to access the navigation controller first...
            if let composeNavController = segue.destination as? UINavigationController,
           // ...then get the actual ComposeViewController via the navController's topViewController property.
               let composeViewController = composeNavController.topViewController as? TaskComposeViewController {
                
                
                // Update the tasks array for any new task passed back via the onComposeTask closure.
                composeViewController.onComposeTask = { [weak self] task in
                    self?.tasks.append(task)
                }
            }
        }
        else if let attachViewController = segue.destination as? AttachViewController {
            attachViewController.tasks = tasks[(tableView.indexPathForSelectedRow?.row)!]
            }
    }

}

