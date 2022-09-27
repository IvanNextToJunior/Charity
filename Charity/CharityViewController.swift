//
//  ViewController.swift
//  Charity
//
//  Created by Galina on 15.09.2022.
//

import UIKit
import WebKit

class CharityViewController: UIViewController {

    @IBOutlet weak private var webView: WKWebView!
    
    @IBOutlet weak private var charitySelectionTextField: UITextField!
   
    @IBOutlet weak private var fundSelectionButton: UIButton!
    @IBOutlet weak private var tableView: UITableView!
    
    @IBAction private func selectCharityTouchUpInside(_ sender: UIButton) {
        if sender.isSelected {
            tableView.isHidden = true
        }
        else {
            tableView.isHidden = false
        }
        sender.isSelected.toggle()
    }
  
    private let model = CharityModel()
    private let identifier = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fundSelectionButton.setTitle("⌄", for: .normal)
       tableView.isHidden = true
        setupModel()
        setup()
       
      
  
    }
    
   private func setupModel() {
       guard let path = Bundle.main.path(forResource: "Funds", ofType: ".plist"),
            let plistDictionary = NSDictionary(contentsOfFile: path),
       let array = plistDictionary.object(forKey: "Fund Name") as? [String],
             let dict = plistDictionary.object(forKey: "Funds") as? [String: String]
       else {
           return
       }
       model.fundNames = array
       model.fundDict = dict
    }
   
    private func setup() {
       
        let nib = UINib(nibName: "FundTableViewCell", bundle: nil)
      
        tableView.register(nib, forCellReuseIdentifier: identifier)
        tableView.dataSource = self
        tableView.delegate = self
    }

}

extension CharityViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        tableView.deselectRow(at: indexPath, animated: false)
        
        let dict = model.fundDict
       
        guard let cell = tableView.cellForRow(at: indexPath) as? FundTableViewCell else {return}
        
        for (key, value) in dict {
            
            if key == cell.fundLabel.text && cell.isSelected {
               
                charitySelectionTextField.text = key
                charitySelectionTextField.resignFirstResponder()
        
                
                guard let url = URL(string: value) else {return}
                let request = URLRequest(url: url)
                webView.load(request)
            }
            
        }
        tableView.isHidden = true
  
    }
}
extension CharityViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.fundNames.count
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
  
       let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! FundTableViewCell
       
        cell.fundLabel.text = model.fundNames[indexPath.row]
       
       return cell
    }
    
}
