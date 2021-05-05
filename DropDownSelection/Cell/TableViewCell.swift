//
//  TableViewCell.swift
//  DropDownSelection
//
//  Created by Brite Solutions on 3/23/21.
//  Copyright © 2021 SHUBHAM AGARWAL. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    
    let dataSource = ["12345", "67890", "098765", "43210"]
    var buttonScroll: UIButton!
    let transparentView = UIView()
    var view: UIView!
    let tableView = UITableView()
    var selectedButton = UIButton()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CellClass.self, forCellReuseIdentifier: "Cell")
    }
    
    @IBAction func tapButton(_ sender: UIButton) {
        selectedButton = sender
        addTransparentView(button: sender)
    }
    
    func addTransparentView(button: UIButton) {
        let window = UIApplication.shared.keyWindow
        self.transparentView.frame = window?.frame ?? self.view.frame
        self.view.addSubview(self.transparentView)
        let pointXY: CGPoint = (button.superview?.convert(button.frame.origin, to: self.view))!
        self.tableView.frame = CGRect(x: pointXY.x, y: pointXY.y + button.frame.height, width: button.frame.width, height: 0)
        self.view.addSubview(self.tableView)
        self.tableView.layer.cornerRadius = 5
        self.transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        tableView.reloadData()
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(self.removeTransparentView))
        self.transparentView.addGestureRecognizer(tapgesture)
        self.transparentView.alpha = 0
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0.5
            var height = CGFloat(self.selectedButton.frame.height) * 5
            height = self.dataSource.count < 5 ? (button.frame.height * CGFloat(self.dataSource.count)) : height
            var yTb = pointXY.y + button.frame.height + 5
            if pointXY.y + height + button.frame.height + 5 > self.view.bounds.height {
                yTb = pointXY.y - 5 - height
            }
            self.tableView.frame = CGRect(x: pointXY.x, y: yTb, width: button.frame.width, height: height)
        }, completion: nil)
    }
    
    @objc func removeTransparentView(isClick: Bool = false) {
        let frames = selectedButton.frame
        let pointXY: CGPoint = (selectedButton.superview?.convert(selectedButton.frame.origin, to: self.view))!
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0
            
            self.tableView.frame = CGRect(x: pointXY.x, y: pointXY.y + frames.height, width: frames.width, height: 0)
            
        }, completion: nil)
    }
}

extension TableViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row]
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.textLabel?.textColor = UIColor.black
        cell.backgroundColor = .clear
        cell.textLabel?.textAlignment = .center
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return selectedButton.frame.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.label.text = dataSource[indexPath.row]
        removeTransparentView(isClick: true)
    }
}
