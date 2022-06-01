//
//  SearchViewController.swift
//  Life-FormSearch
//
//  Created by Rogasiu on 16/05/2022.
//

import UIKit
import SafariServices

class SearchViewController: UIViewController {
    
    let lifeForm: SearchItem
    
    @IBOutlet var stackView: UIStackView!
    var details: ItemDetails? = nil
    var taxonConcepts: ScientificClassification? = nil
    var name = ""
    var taxons = [Taxon]()
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var urlLicenseButton: UIButton!
    @IBOutlet var taxonomySourceLabel: UILabel!
    @IBOutlet var scientificNameLabel: UILabel!
    @IBOutlet var kingdomLabel: UILabel!
    @IBOutlet var phylumLabel: UILabel!
    @IBOutlet var classLabel: UILabel!
    @IBOutlet var orderLabel: UILabel!
    @IBOutlet var familyLabel: UILabel!
    @IBOutlet var genusLabel: UILabel!
    
    let myActivityIndicator = UIActivityIndicatorView(style: .medium)
    
    
    init?(coder: NSCoder, lifeForm: SearchItem) {
        self.lifeForm = lifeForm
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = lifeForm.commonName
        stackView.isHidden = true
        
        // Position Activity Indicator in the center of the main view
        myActivityIndicator.center = view.center
        myActivityIndicator.transform = CGAffineTransform(scaleX: 3, y: 3)
        
        // If needed, you can prevent Acivity Indicator from hiding when stopAnimating() is called
        //myActivityIndicator.hidesWhenStopped = false
        
        // Start Activity Indicator
        myActivityIndicator.startAnimating()
        
        // Call stopAnimating() when need to stop activity indicator
        //myActivityIndicator.stopAnimating()
        
        
        view.addSubview(myActivityIndicator)
        
        // Do any additional setup after loading the view.
        fetchMainInfo()
    }
    
    func fetchMainInfo(){
    
        let id = String(lifeForm.id)
        let licenseRequest = LicenseAPIRequest(identifier: id)
        Task{
            do{
                let searchItem = try await SendAPIRequest.sendRequest(licenseRequest)
                self.name = searchItem.scientificName
                if let detailsIt = searchItem.details {
                    self.details = detailsIt.first
                    updateUI()
                }
                if let taxonConceptsIt = searchItem.taxonConcepts {
                    self.taxonConcepts = taxonConceptsIt.first
                    fetchDetailInfo(id: taxonConcepts!.identifier)
                }
            } catch {
                print(error)
            }
        }
    }
    
    func fetchDetailInfo(id: Int) {
        let identifier = String(id)
        let detailsRequest = DetailsAPIRequest(identifier: identifier)
        Task {
            do {
                let detailsItem = try await SendAPIRequest.sendRequest(detailsRequest)
                self.taxons = detailsItem
                updateUI()
            }
        }
    }
    
    func updateUI() {

        scientificNameLabel.text = name
        updateDetailUI()
        updateTaxonUI()
        myActivityIndicator.stopAnimating()
        stackView.isHidden = false
    }
    
    func updateDetailUI() {
        guard let details = details else{
            urlLicenseButton.isHidden = true
            authorLabel.isEnabled = false
            return
        }
        if let rightsHolder = details.rightsHolder {
            authorLabel.text = rightsHolder
        }else {
            authorLabel.text = details.agents.first!.fullName + " ," + details.agents.first!.role
        }
        urlLicenseButton.setTitle(details.license, for: .normal)
        
        guard let url = details.imageUrl else {
            return
        }
        let photoRequest = ImageAPIRequest(url: url)
        Task {
            do {
                let image = try await SendAPIRequest.sendRequest(photoRequest)
                imageView.image = image
            } catch {
                print(error)
            }
        }
    }
    
    func updateTaxonUI() {
        guard let taxonConcepts = taxonConcepts else {
            return
        }
        taxonomySourceLabel.text = taxonConcepts.nameAccordingTo
        
        for taxon in taxons {
            guard let taxonName = taxon.taxonRank else {
                return
            }
            switch taxonName{
            case "kingdom":
                kingdomLabel.text = taxon.scientificName
                break
            case "phylum":
                phylumLabel.text = taxon.scientificName
                break
            case "class":
                classLabel.text = taxon.scientificName
                break
            case "order":
                orderLabel.text = taxon.scientificName
                break
            case "family":
                familyLabel.text = taxon.scientificName
                break
            case "genus":
                genusLabel.text = taxon.scientificName
                break
            default:
                break
            }
        }
    }
    @IBAction func licenseButtonTapped(_ sender: UIButton) {
        guard let details = details else {
            return
        }
        if let url = URL(string: details.license) {
            let safariViewController = SFSafariViewController(url: url)
            present(safariViewController, animated: true, completion: nil)
        }
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
