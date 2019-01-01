//
//  EditTimesVC.swift
//  Easters 2019
//
//  Created by Viran Weerasekera on 31/12/18.
//  Copyright © 2018 Viran Weerasekera. All rights reserved.
//

import UIKit

class EditTimesVC: UITableViewController {
    
    var index:Int!
    var round:String!
    var currentStart:Date!
    var newStart:Date!
    var diff : TimeInterval = 0
    
    @IBOutlet weak var sched: UILabel!
    @IBOutlet weak var offsetcheckin: UISwitch!
    @IBOutlet weak var dp: UIDatePicker!
    @IBOutlet weak var current: UILabel!
    @IBOutlet weak var new: UILabel!
    @IBOutlet weak var delay: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        current.text = DateFormatter.localizedString(from: currentStart!, dateStyle: .none, timeStyle: .short)
        new.text = DateFormatter.localizedString(from: currentStart!, dateStyle: .none, timeStyle: .short)
        
        dp.date = currentStart!
        
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Edit \(round!)"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveNewTime))
        
        
        
        //diff = allRounds[index].estDelay
        delay.text = "\(String(Int(diff/60))) minutes"
        sched.text = DateFormatter.localizedString(from: allRounds[index].schedStart, dateStyle: .none, timeStyle: .short)
        
        if diff == 0 {
            delay.textColor = UIColor.blue
        } else if diff < 0 {
            delay.textColor = UIColor.green
        } else if diff < 901 {
            delay.textColor = UIColor.orange
        } else {
            delay.textColor = UIColor.red
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func dpShowDateAction(_ sender: Any) {
        new.text = DateFormatter.localizedString(from: dp.date, dateStyle: .none, timeStyle: .short)
        print(dp.date)
        
        diff = dp.date.timeIntervalSince(allRounds[index].schedStart)
        
        delay.text = "\(String(Int(diff/60))) minutes"
        
        if diff == 0 {
            delay.textColor = UIColor.blue
        } else if diff < 0 {
            delay.textColor = UIColor.green
        } else if diff < 901 {
            delay.textColor = UIColor.orange
        } else {
            delay.textColor = UIColor.red
        }
    }
    
    
    //Rewrite
    @objc func saveNewTime() {
        
        // Update the round variable estStart
        allRounds[index].estStart = dp.date
        
        //Update unique delay
        allRounds[index].uniqueDelay = calculateUniqueDelay(forRoundIndex: index)
        
        
        // Offset check-in if required
        if offsetcheckin.isOn {
            allRounds[index].checkincloses = allRounds[index].estStart.addingTimeInterval(checkinLead)
        }
        
        // Calculate new estimated start times for rounds that have not started yet
        estimateFutureStartsAfterEdit(forRoundIndex: index)
        
        // Save array
        writeRounds()
        
        // Load up the navController
        navigationController?.popToRootViewController(animated: true)
        
    }
    @IBAction func syncCheckIn(_ sender: Any) {
        // Reset check-in to normal first, then re-add the total delay on
        allRounds[index].checkincloses = allRounds[index].schedStart.addingTimeInterval(checkinLead)
        
        allRounds[index].checkincloses = calculateDelayWithKnockOn(forRoundIndex: index).addingTimeInterval(checkinLead)
        
        writeRounds()
        
        navigationController?.popToRootViewController(animated: true)
    }
}
