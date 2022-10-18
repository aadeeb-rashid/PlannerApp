//
//  TaskViewController.swift
//  PlannerApp
//
//  Created by aadeeb rashid on 4/22/22.
//

import UIKit

class TaskViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    @IBOutlet weak var results: UILabel!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        AppDelegate.sharedManagers()?.errorManager.setDelegate(viewController: self)
        tableView.reloadData()
        
        super.viewDidLoad()
        getWeather()
        // Do any additional setup after loading the view.
    }

    func getWeather()
    {
        
        var url : String = "https://api.openweathermap.org/data/2.5/onecall?"
        
        let lat : Float = 33.4
        let lon : Float = -111.94
        
        url = url + "lat=" + String(lat)
        url = url + "&lon=" + String(lon)
        url = url + "&exclude=" + "daily,hourly,minutely,alerts"
        url = url + "&appid=" + "4fd3f89f509c20f9fb563b945ee67b17"
        
        let urlSession = URLSession.shared
        let urlF = URL(string: url)
        print(urlF)
        let jsonQuery = urlSession.dataTask(with: urlF!, completionHandler: { data, response, error -> Void in
                      
                    let decoder = JSONDecoder()
                    let jsonResult = try! decoder.decode(List.self, from: data!)
                    
            let arr = jsonResult.current.weather[0].main
            
                 
                    DispatchQueue.main.async {
                        self.results.text = arr
                    }
            
                })
                
                jsonQuery.resume()
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        AppDelegate.sharedManagers()?.userManager.getTasks().count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell") as? TaskTableViewCell {
            
            let taskList :[Task] = AppDelegate.sharedManagers()?.userManager.getTasks() ?? []
            let task: Task = taskList[indexPath.row]
            cell.catLabel.text = "CATEGORY:" + task.cat.name!
            cell.taskLabel.text = "TASK:" +  task.name!
            cell.img.image = task.img
            cell.task = task
            
            return cell
        }
            
        return UITableViewCell()

    }
    
    @IBAction func refresh(_ sender: Any) {
        tableView.reloadData()
    }
    @IBAction func unwindToTable(segue: UIStoryboardSegue) {
        tableView.reloadData()
    }
}
