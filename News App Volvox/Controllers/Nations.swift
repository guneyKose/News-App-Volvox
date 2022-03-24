//
//  Countries.swift
//  News App Volvox
//
//  Created by Güney Köse on 21.03.2022.
//

import UIKit

class Countries: UIViewController {
    
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var textField: UITextField!
    
    weak var delegate: ChangeCountry?
    weak var subjectDelegate: ChangeSubject?
    
    var news: NewsData?
    let region = (Locale.current.regionCode)?.lowercased()
    
    struct Nations {
        let country: String
        let code: String
    }
    
    var country = "tr"
    var codeIndex = 0
    
    var countries = [
        Nations(country: "United States of America", code: "us"),
        Nations(country: "Turkey", code: "tr"),
        Nations(country: "Germany", code: "de"),
        Nations(country: "Ukraine", code: "ua"),
        Nations(country: "United Kingdom", code: "gb"),
        Nations(country: "France", code: "fr"),
        Nations(country: "Italy", code: "it"),
        Nations(country: "Sweden", code: "se")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.dataSource = self
        picker.delegate = self
        textField.delegate = self
        
//        for (index, element) in countries.enumerated() {
//            if element.code == region {
//                codeIndex = index
//            }
//        }
//
//        for i in 0..<countries.count {
//            if countries[i].code == region {
//                picker.selectRow(i, inComponent: 0, animated: true)
//                break
//            }
//            print(i)
//        }
        
        if let currentIndex = countries.firstIndex(where: { $0.code == region }) {
            picker.selectRow(currentIndex, inComponent: 0, animated: true)
            print(currentIndex)
        }
    
//        let regionEsitOlanlar = countries.filter({ $0.code == region})
//
//        print(regionEsitOlanlar)
    }

    @IBAction func doneTapped(_ sender: UIButton) {
        
        self.delegate?.changeCountry(location: country)
        
        self.navigationController?.popViewController(animated: true)

    }
}

//MARK: - Picker View

extension Countries: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        countries.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        countries[row].country
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        country = countries[row].code
    }
    

}

//MARK: - Text Field

extension Countries: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.clearsOnBeginEditing = true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        self.subjectDelegate?.changeSubject(topic: textField.text ?? "")
        self.navigationController?.popViewController(animated: true)
    }
}


