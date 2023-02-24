//
//  CustomTableViewCell.swift
//  PhotoScavengerHunt
//
//  Created by Ujjwal Adhikari on 2/15/23.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var completedView: UIImageView!
    
    func configure(with task:Tasks){
        title.text = task.title
        completedView.image = UIImage(systemName: task.isComplete ? "circle.inset.filled":"circle")?.withRenderingMode(.alwaysTemplate)
        completedView.tintColor = task.isComplete ? .blue : .red
    }
}
