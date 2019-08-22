//
//  WeekTableViewController.swift
//  Sports Table View App
//
//  Created by Louise Chan on 2019-06-28.
//  Copyright © 2019 Louise Chan. All rights reserved.
//

import UIKit

class WeekTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // Prepare the next seque (League Table View controller) to display the league names
    // by passing the week number in order to determine the correct file to process.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? LeagueTableViewController, let leagueCell = sender as? UITableViewCell{
            if let indexPath = tableView.indexPath(for: leagueCell){
                // Pass the week number (determined by adding 1 to the row index number)
                // to the next view controller.
                vc.setWeek(week: indexPath.row + 1)
            }
        }
    }
}
