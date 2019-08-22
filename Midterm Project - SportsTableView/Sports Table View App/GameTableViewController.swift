//
//  GameTableViewController.swift
//  Sports Table View App
//
//  Created by Louise Chan on 2019-06-29.
//  Copyright © 2019 Louise Chan. All rights reserved.
//

import UIKit

class GameTableViewController: UITableViewController {
    var weekNum: Int!
    var leagueName: String!
    var gamesList: Array<GameInfo>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Open the correct json file by using the provided week number during segue transition
        let week = weekNum as Int
        if let path = Bundle(for: AppDelegate.self).path(forResource: "sports_week_\(week)", ofType: "json"){
            
            let data = NSData(contentsOfFile: path)! as Data
            let json = JSON(data: data)
            
            // Load all the games for the selected league in the gamesList array
            self.loadGames(data: json)
        }

    }

    // Return the number of rows to display using the number of games that were stored in the gamesList array
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gamesList?.count ?? 0
    }

    // Populates the rows in the Game table view controller with the games that are available in the league
    // for the specified week number.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        // Display game info for each row in the table view controller
        let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell") as! GameTableViewCell
        cell.setGameInfo(gameData: gamesList[indexPath.row])
        
        return cell
    }

    // Sets up the weekNum and leagueName in order to determine which games to display from the json file
    func setGameLeagueInfo(week: Int, league: String) {
        // save a copy of the week number and league name to use for listing the games in the
        // game table view controller.
        weekNum = week
        leagueName = league
    }
    
    // Load the games for a specified week number and league name and store it in the gamesList array
    func loadGames(data: JSON) {
        // Initialize the gamesList array of GameInfo objects
        self.gamesList = Array<GameInfo>()
        
        // Setup the json array values for the "leagues" key
        let leagueArray = data["leagues"].arrayValue
        
        // Iterate each league name and see if any of the names matches the league name
        // that is being searched.
        for league in leagueArray {
            if league["name"].stringValue == leagueName {
                // leagueName matches one of the league names within the json array
                let gameArray = league["games"].arrayValue
                // Iterate through each game and store the necessary info into the array of GameInfo objects
                for game in gameArray {
                    self.gamesList.append(GameInfo(data: game))
                }
                
                // After all games in the league has been loaded, there is no point to continue with
                // the league name iteration so just exit the for loop.
                break
            }
        }
    }

}
