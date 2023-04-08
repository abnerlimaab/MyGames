//
//  ViewController+CoreData.swift
//  MyGames
//
//  Created by Abner Lima on 08/04/23.
//

import UIKit
import CoreData
import Foundation

extension UIViewController {
    var context: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        return appDelegate.persistentContainer.viewContext
    }
              
}
