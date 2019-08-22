//
//  TheaterTableViewController.swift
//  Movie Finder
//
//  Created by Louise Chan on 2019-07-31.
//  Copyright © 2019 Louise Chan. All rights reserved.
//

import UIKit

class TheaterTableViewController: UITableViewController {
    var theaterLinks: Array<TheaterLink>!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func setTheaters(theaters: Array<Theater>) {
        theaterLinks = Array<TheaterLink>()
        for theater in theaters {
            theaterLinks.append(TheaterLink(name: theater.marker.title!, address: theater.marker.subtitle!, url: theater.url))
        }
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return theaterLinks?.count ?? 0
    }

    // Load logo, name and address of each theater in the table view cell..
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "thcell") as! TheaterTableViewCell
        let theater = theaterLinks[indexPath.row]
        cell.textLabel?.text = theater.name
        
        let image = UIImage(named: "Cineplex_Logo")
        cell.imageView?.image = image
        
        cell.detailTextLabel?.text = theater.address
        //cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        return cell
    }
    
    
    // MARK: - Navigation
    // Transition to web page view.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? WebViewController, let theaterCell = sender as? UITableViewCell{
            if let indexPath = tableView.indexPath(for: theaterCell){
                vc.setTheaterUrl(url: theaterLinks[indexPath.row])
            }
        }
    }

}
