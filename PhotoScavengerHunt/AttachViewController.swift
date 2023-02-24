//
//  AttachViewController.swift
//  PhotoScavengerHunt
//
//  Created by Ujjwal Adhikari on 2/18/23.
//

import UIKit
import PhotosUI
import MapKit
import MobileCoreServices

class AttachViewController: UIViewController, MKMapViewDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    
    @IBOutlet weak var attachTitle: UILabel!
    
    @IBOutlet weak var attachdescription: UILabel!
    
    @IBOutlet weak var completedView: UIImageView!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var attachPhotoButton: UIButton!
    
    var tasks: Tasks!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attachTitle.text = tasks.title
        attachdescription.text = tasks.description
        // Do any additional setup after loading the view.
        updateMapView()
        updateUI()
        // Register custom annotation view
        mapView.register(TaskAnnotationView.self, forAnnotationViewWithReuseIdentifier: TaskAnnotationView.identifier)
        mapView.delegate = self
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        guard let image = info[.originalImage] as? UIImage else {
            print("No image found")
            return
        }
        print("image found")

        let fetchOptions = PHFetchOptions()
        fetchOptions.fetchLimit = 0
        let result = PHAsset.fetchAssets(with: .image, options: fetchOptions)

        guard let asset = result.firstObject else {
            return
        }
        
        if let location = asset.location {
            // Use the location
            DispatchQueue.main.async { [weak self] in
                
                // Set the picked image and location on the task
                self?.tasks.set(image, with: location)
                
                // Update the UI since we've updated the task
                self?.updateUI()
                
                // Update the map view since we now have an image an location
                self?.updateMapView()
            }
        } else {
            print("Location not available for this photo.")
        }
    }
    
    @IBAction func attachPhoto(_ sender: Any) {
        let picker = UIImagePickerController()
        // Present the picker.
        picker.sourceType = .camera
        picker.delegate = self
        present(picker, animated: true)
    }
    
    
    func updateMapView() {
        guard let imageLocation = tasks.imageLocation else { return }

        // Get the coordinate from the image location. This is the latitude / longitude of the location.
        // https://developer.apple.com/documentation/mapkit/mkmapview
        let coordinate = imageLocation.coordinate

        // Set the map view's region based on the coordinate of the image.
        // The span represents the maps's "zoom level". A smaller value yields a more "zoomed in" map area, while a larger value is more "zoomed out".
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)
        
        // Add an annotation to the map view based on image location.
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        // Dequeue the annotation view for the specified reuse identifier and annotation.
        // Cast the dequeued annotation view to your specific custom annotation view class, `TaskAnnotationView`
        // 💡 This is very similar to how we get and prepare cells for use in table views.
        guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: TaskAnnotationView.identifier, for: annotation) as? TaskAnnotationView else {
            fatalError("Unable to dequeue TaskAnnotationView")
        }

        // Configure the annotation view, passing in the task's image.
        annotationView.configure(with: tasks.image)
        return annotationView
    }
    
    private func updateUI() {
        attachTitle.text = tasks.title
        attachdescription.text = tasks.description

        let completedImage = UIImage(systemName: tasks.isComplete ? "circle.inset.filled" : "circle")

        // calling `withRenderingMode(.alwaysTemplate)` on an image allows for coloring the image via it's `tintColor` property.
        completedView.image = completedImage?.withRenderingMode(.alwaysTemplate)
        
        let color: UIColor = tasks.isComplete ? .systemBlue : .tertiaryLabel
        completedView.tintColor = color

//        mapView.isHidden = !tasks.isComplete
        attachPhotoButton.isHidden = tasks.isComplete
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
