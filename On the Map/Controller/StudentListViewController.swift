//
//  StudentListViewController.swift
//  On the Map
//
//  Created by Ben Lewis on 10/9/19.
//  Copyright © 2019 Ben Lewis. All rights reserved.
//

import UIKit

class StudentListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var studentTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        OTMClient.shared.getStudentLocations { result in
            switch result{
            case .error(let message):
                self.showError(message)
            case .success(let response):
                OTMSession.shared.setStudentLocations(response.results)
                self.studentTableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return OTMSession.shared.studentLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentCell")!
        let loc = OTMSession.shared.studentLocations[indexPath.row]
        cell.textLabel?.text = "\(loc.firstName) \(loc.lastName)"
        cell.detailTextLabel?.text = loc.mediaURL
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mediaUrl = OTMSession.shared.studentLocations[indexPath.row].mediaURL
        openUrl(URL(string: mediaUrl)!)
    }
    
    @IBAction func onLogOutClicked(_ sender: Any) {
        OTMClient.shared.logOut { _ in
            OTMSession.shared.clearSession()
            self.tabBarController?.navigationController?.popViewController(animated: true)
        }
    }
    
}
