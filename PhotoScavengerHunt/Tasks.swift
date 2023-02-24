//
//  Tasks.swift
//  PhotoScavengerHunt
//
//  Created by Ujjwal Adhikari on 2/15/23.
//

import CoreLocation
import UIKit

class Tasks{
    var title: String
    var description: String
    var image: UIImage?
    var imageLocation: CLLocation?
    var isComplete: Bool {
        image != nil
    }
    init(title: String, description: String) {
        self.title = title
        self.description = description
    }
    
    func set(_ image: UIImage, with location: CLLocation) {
        self.image = image
        self.imageLocation = location
    }
}

extension Tasks {
    static var tasks: [Tasks] {
        return [
            Tasks(title: "Click the photo of your tv",
                 description: "Try to get full screen TV.")
        ]
    }
}
