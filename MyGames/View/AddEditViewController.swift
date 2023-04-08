//
//  AddEditViewController.swift
//  MyGames
//
//  Created by Abner Lima on 08/04/23.
//

import UIKit

class AddEditViewController: UIViewController {
    
    @IBOutlet weak var tfTitle: UITextField!
    @IBOutlet weak var tfConsole: UITextField!
    @IBOutlet weak var dpReleaseDate: UIDatePicker!
    @IBOutlet weak var btAddEdit: UIButton!
    @IBOutlet weak var btCover: UIButton!
    @IBOutlet weak var ivCover: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func addEditCover(_ sender: UIButton) {
    }
    
}
