//
//  GameTableViewCell.swift
//  Sports Table View App
//
//  Created by Louise Chan on 2019-06-29.
//  Copyright © 2019 Louise Chan. All rights reserved.
//

import UIKit

class GameTableViewCell: UITableViewCell {

    // Variables for the labels and image objects that were added for this custom cell
    @IBOutlet weak var team1Image: UIImageView!
    @IBOutlet weak var team2Image: UIImageView!
    @IBOutlet weak var team1Name: UILabel!
    @IBOutlet weak var team2Name: UILabel!
    @IBOutlet weak var team1Score: UILabel!
    @IBOutlet weak var team2Score: UILabel!
    @IBOutlet weak var gameSkedLabel: UILabel!
    
    // Displays game information for a specific league game.
    func setGameInfo(gameData: GameInfo) {
        // Display team 1 (ie. home team) logo, city and name
        self.team1Image.image = UIImage(named: gameData.homeTeamLogo)
        self.team1Name.text = gameData.homeTeamName

        // Display team 2 (ie. away team) logo, city and name
        self.team2Image.image = UIImage(named: gameData.visitTeamLogo)
        self.team2Name.text = gameData.visitTeamName
        
        // Checks if score or game schedule will be displayed depending on game status.
        if gameData.gameStatus == "Final" {
            // Game status is Final, display scores and hide game schedule label.
            self.gameSkedLabel.isHidden = true
            self.team1Score.text = "\(gameData.homeTeamScore!)"
            self.team2Score.text = "\(gameData.visitTeamScore!)"

            // Unhide labels for game scores
            self.team1Score.isHidden = false
            self.team2Score.isHidden = false
        }
        else {
            // Game status is Pregame
            // Hide labels for game scores
            self.team1Score.isHidden = true
            self.team2Score.isHidden = true

            // Show the game schedule
            self.gameSkedLabel.text = gameData.gameSked
            self.gameSkedLabel.isHidden = false
        }
    }

}
