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
    
    var game: Game!
    lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.backgroundColor = .white
        
        return pickerView
    }()
    var consolesManager = ConsolesManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if game != nil {
            title = "Editar jogo"
            btAddEdit.setTitle("Alterar", for: .normal)
            tfTitle.text = game.title
            if let console = game.console, let index = consolesManager.consoles.firstIndex(of: console) {
                tfConsole.text = console.name
                pickerView.selectRow(index, inComponent: 0, animated: false)
            }
            ivCover.image = game.cover as? UIImage
            if let releaseDate = game.releaseDate {
                dpReleaseDate.date = releaseDate
            }
            if game.cover != nil {
                btCover.setTitle(nil, for: .normal)
            }
        }
        
        prepareConsoleTextField()

        // Do any additional setup after loading the view.
    }
    
    func prepareConsoleTextField() {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
        toolBar.tintColor = UIColor(named: "main")
        let btCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        let btDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        let btFlexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolBar.items = [btCancel, btFlexibleSpace, btDone]
        
        tfConsole.inputView = pickerView
        tfConsole.inputAccessoryView = toolBar
    }
    
    @objc func cancel() {
        tfConsole.resignFirstResponder()
    }
    
    @objc func done() {
        let index = pickerView.selectedRow(inComponent: 0)
        tfConsole.text = consolesManager.consoles[index].name
        
        cancel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        consolesManager.loadConsoles(with: context)
    }
    
    
    @IBAction func addEditCover(_ sender: UIButton) {
        let alert = UIAlertController(title: "Selecionar poster", message: "De onde você quer escolher o poster", preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Câmera", style: .default) { action in
                self.selectPicture(sourceType: .camera)
            }
            alert.addAction(cameraAction)
        }
        
        let libraryAction = UIAlertAction(title: "Biblioteca de fotos", style: .default) { action in
            self.selectPicture(sourceType: .photoLibrary)
        }
        alert.addAction(libraryAction)
        
        let photosAction = UIAlertAction(title: "Álbum de fotos", style: .default) { action in
            self.selectPicture(sourceType: .savedPhotosAlbum)
        }
        alert.addAction(photosAction)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    func selectPicture(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        imagePicker.navigationBar.tintColor = UIColor(named: "main")
        
        present(imagePicker, animated: true)
    }
    
    @IBAction func addEditGame(_ sender: UIButton) {
        if game == nil {
            game = Game(context: context)
        }
        game.title = tfTitle.text
        game.releaseDate = dpReleaseDate.date
        
        if !tfConsole.text!.isEmpty {
            let index = pickerView.selectedRow(inComponent: 0)
            game.console = consolesManager.consoles[index]
        }
        
        game.cover = ivCover.image
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
        
        navigationController?.popViewController(animated: true)
    }
}

extension AddEditViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return consolesManager.consoles.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let console = consolesManager.consoles[row]
        
        return console.name
    }
}

extension AddEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        ivCover.image = image
        btCover.setTitle(nil, for: .normal)
        dismiss(animated: true)
    }
}
