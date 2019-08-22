//
//  GameInfo.swift
//  Sports Table View App
//
//  Created by Louise Chan on 2019-06-29.
//  Copyright © 2019 Louise Chan. All rights reserved.
//

import Foundation

// This class contains all the necessary info that will be used for displaying
// games within a selected league
class GameInfo {
    // Member variables holding the two teams' name (city and name), logo, status, scores and schedule
    var homeTeamName: String
    var homeTeamLogo: String
    var visitTeamName: String
    var visitTeamLogo: String
    var gameStatus: String
    var gameSked: String!
    var homeTeamScore: Int!
    var visitTeamScore: Int!
    
    // Initializer receives JSON formatted game info and saves it in the object's instance variables
    init(data: JSON) {
        // Setup home team name to include the team city and name
        self.homeTeamName = "\(data["home_team_city"].stringValue) \(data["home_team_name"])"
        // Setup member variable to hold the string name used for displaying the team logo
        self.homeTeamLogo = "\(data["home_team_logo"].stringValue)"

        // Setup visiting team name to include the team city and name
        self.visitTeamName = "\(data["visit_team_city"].stringValue) \(data["visit_team_name"])"
        // Setup member variable to hold the string name used for displaying the team logo
        self.visitTeamLogo = "\(data["visit_team_logo"].stringValue)"
        
        // Setup the game status for the game (i.e. Final or Pregame)
        self.gameStatus = data["game_state"].stringValue
        
        // Setup scores only if game is final, otherwise, setup the game schedule
        if self.gameStatus == "Final" {
            // Game status is final, setup scores
            homeTeamScore = data["home_team_score"].intValue
            visitTeamScore = data["visit_team_score"].intValue
        }
        else {
            // Game has not commenced, setup game schedule
            let date = Date(timeIntervalSince1970: data["game_time"].doubleValue)
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE, MMM dd\nh:mm a"
            self.gameSked = formatter.string(from: date)
        }

    }
}
