//
//  FamilyViewController.swift
//  DoodleCoreData
//
//  Created by Atul on 23/12/18.
//  Copyright © 2018 Atul. All rights reserved.
//

import UIKit
import CoreData

class FamilyViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var familyNames: [Families] = []
    let cellReuseIdentifier = "FamilyCell"
    var user: Users!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        for name in user.family! {
            let a = name as! Families
            familyNames.append(a)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Custom Method
}

// MARK: - UITableViewDataSource

extension FamilyViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return familyNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
        
        let family = familyNames[indexPath.row]

        if let familyName = family.name {
            cell.textLabel?.text = familyName
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension FamilyViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let family = familyNames[indexPath.row]
            do {
                context.delete(family)
                try context.save()
            } catch {
                print("Failed Deleting")
            }
            familyNames.remove(at: indexPath.row)
            
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
}
