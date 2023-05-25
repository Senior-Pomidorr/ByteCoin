//
//  ViewController.swift
//  byteCoin
//
//  Created by Daniil Kulikovskiy on 24.05.2023.
//

import UIKit

class MainViewController: UIViewController, CoinManagerDelegate {

    var coinManager = CoinManager()
    
    private lazy var byteCoin: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "ByteCoin"
        label.textAlignment = .center
        label.textColor = UIColor(named: "textColor")
        label.font = .systemFont(ofSize: 50, weight: .thin)
        return label
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.backgroundColor = .tertiaryLabel
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.layer.cornerRadius = 16
        stack.spacing = 10
        stack.distribution = .fill
        stack.contentMode = .scaleToFill
        return stack
    }()
    
    private let bitcoinImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "bitcoinsign.circle.fill")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.tintColor = .white
        return image
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .red
        label.text = "..."
        label.font = .systemFont(ofSize: 25)
        label.textColor = .white
        label.textAlignment = .right
        return label
    }()
    
    private let coinlabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "USD"
        label.font = .systemFont(ofSize: 25)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let pickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "BackgroundColor")
        pickerView.dataSource = self
        pickerView.delegate = self
        coinManager.delegate = self
        layout()
    }

    func didUpdatePrice(price: String, currency: String) {
        
        DispatchQueue.main.async {
            self.label.text = price
            self.coinlabel.text = currency
        }
    }
    
    func didError(error: Error) {
        print(error)
    }

}

extension MainViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        coinManager.currencyArray.count
    }
    
    func layout() {
        view.addSubview(byteCoin)
        view.addSubview(stackView)
        stackView.addArrangedSubview(bitcoinImage)
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(coinlabel)
        view.addSubview(pickerView)
        
        NSLayoutConstraint.activate([
            
            byteCoin.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            byteCoin.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            byteCoin.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            byteCoin.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            byteCoin.heightAnchor.constraint(equalToConstant: 70),
            
            stackView.topAnchor.constraint(equalTo: byteCoin.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackView.heightAnchor.constraint(equalToConstant: 80),
            
            pickerView.heightAnchor.constraint(equalToConstant: 216),
            pickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pickerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            
        ])
        
        NSLayoutConstraint.activate([
            bitcoinImage.heightAnchor.constraint(equalToConstant: 80),
            bitcoinImage.widthAnchor.constraint(equalToConstant: 80),
            
            label.heightAnchor.constraint(equalToConstant: 80),
            
            coinlabel.heightAnchor.constraint(equalToConstant: 80),
            coinlabel.widthAnchor.constraint(equalToConstant: 80),
            
            ])
    }
}

extension MainViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
}
