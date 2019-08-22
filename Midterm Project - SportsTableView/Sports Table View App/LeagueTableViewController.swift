//
//  LeagueTableViewController.swift
//  Sports Table View App
//
//  Created by Louise Chan on 2019-06-28.
//  Copyright © 2019 Louise Chan. All rights reserved.
//

import UIKit

class LeagueTableViewController: UITableViewController {

    var weekNum: Int!
    var leagueNames: Array<String>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the correct json file to read based on the week number value stored in weekNum
        let week = weekNum as Int
        if let path = Bundle(for: AppDelegate.self).path(forResource: "sports_week_\(week)", ofType: "json"){
            let data = NSData(contentsOfFile: path)! as Data
            let json = JSON(data: data)
            // Load all the league names that are read from the json file into the leagueNames array
            self.loadLeagueNames(data: json)
        }

    }

    // Return the number of rows based on the number of league names that were read from the json file.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leagueNames?.count ?? 0
    }


    // Displays each league name and icon in the table view controller
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // Configure each row to display every league name and its icon from the leagueNames array
        // using the cell's built-in imageView and text label properties.
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeagueCell") as! LeagueTableViewCell
        cell.textLabel?.text = self.leagueNames[indexPath.row]
        let imgName = self.leagueNames[indexPath.row].lowercased()
        cell.imageView?.image = UIImage(named: imgName)

        return cell
    }
    
    // Set's up the weekNum variable in order to determine the correct json file to read
    func setWeek(week: Int) {
        self.weekNum = week
    }

    // Sets up the leagueNames array with the league names that were read in the json file.
    func loadLeagueNames(data: JSON) {
        // Initialize the leagueNames array as an array of strings.
        self.leagueNames = Array<String>()
        
        // Get all the array elements of the "league" key in the json file and store it in leagueArray.
        let leagueArray = data["leagues"].arrayValue
        
        // Iterate each json array element to get the name of the leagues that are in the array
        // and save it in the leagueNames string array.
        for league in leagueArray {
            self.leagueNames.append(league["name"].stringValue)
        }
    }
    
    // Prepare to transition to the next segue that will display all games available for a seleted league
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? GameTableViewController, let leagueCell = sender as? LeagueTableViewCell {
            if let indexPath = tableView.indexPath(for: leagueCell){
                // Pass the week number and league name info to the next table view controller.
                vc.setGameLeagueInfo(week: self.weekNum, league: self.leagueNames[indexPath.row])
            }
        }
    }
}
