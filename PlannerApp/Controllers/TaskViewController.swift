//
//  TaskViewController.swift
//  PlannerApp
//
//  Created by aadeeb rashid on 4/22/22.
//

import UIKit

class TaskViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad()
    {
        self.prepViewController()
        super.viewDidLoad()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        AppDelegate.sharedManagers()?.userManager.getTasks().count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell") as! TaskTableViewCell
        let task: Task? = AppDelegate.sharedManagers()?.userManager.getTasks()[indexPath.row] ?? nil
        cell.catLabel.text = "CATEGORY:" + (task?.cat.name ?? "Category")
        cell.taskLabel.text = "TASK:" +  (task?.name ?? "Task Name")
        cell.img.image = task?.img
        cell.task = task
        return cell
    }
    
    @IBAction func refresh(_ sender: Any)
    {
        tableView.reloadData()
    }
    
    @IBAction func unwindToTable(segue: UIStoryboardSegue)
    {
        tableView.reloadData()
    }
}
