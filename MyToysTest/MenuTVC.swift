//
//  MenuTVC.swift
//  MyToysTest
//
//  Created by LiLietz on 09.06.17.
//  Copyright © 2017 LiLietz. All rights reserved.
//

import UIKit

class MenuTVC: UITableViewController {
    
    var objects: [Model]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self == self.navigationController?.viewControllers[0] {
            self.loadData()
            self.navigationItem.title = "Main Menu"
        } else {
            if let label = objects?[0].label {
                self.navigationItem.title = label
            }
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(tappedCloseButton))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tappedCloseButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - Table view data source
extension MenuTVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if let objects = self.objects {
            return objects.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let objects = self.objects {
            if let children = objects[section].children {
                return children.count
            }
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if let objects = self.objects {
            if objects.count == 1 {
                if objects[0].type != .section {
                    return 0
                }
            }
        }
        return CGFloat(Constants.defaultTableCellHeight)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if let objects = self.objects {
            if objects.count == 1 {
                if objects[0].type != .section {
                    return UIView()
                }
            }
        }
        
        let header = Bundle.main.loadNibNamed("HeaderCell", owner: self, options: nil)?.first as! HeaderCell
        
        if let objects = self.objects {
            header.titleLabel.text = objects[section].label
        }
        
        return header
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let children = objects?[indexPath.section].children{
            
            let type: ModelType = children[indexPath.row].type
            
            let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "nodeLinkCell")
            
            switch type {
            case .node:
                cell.textLabel?.text = children[indexPath.row].label
                cell.detailTextLabel?.text = ">"
                return cell
            case .link:
                cell.textLabel?.text = children[indexPath.row].label
                cell.detailTextLabel?.isHidden = true
                return cell
            default:
                break
            }
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let children = objects?[indexPath.section].children {
            
            let type: ModelType = children[indexPath.row].type
            
            switch type {
            case .node:
        
                let vc = MenuTVC()
                vc.objects = [children[indexPath.row]]
                vc.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(tappedCloseButton))
                
                self.navigationController?.pushViewController(vc, animated: true)
                
            case .link:
                
                let vc = self.presentingViewController as! HomePageVC
                
                if let url = children[indexPath.row].url {
                    vc.currentUrl = url
                }
                
                self.dismiss(animated: true, completion: nil)
                
            default:
                break
            }
        }
    }
    
}


// MARK: API Request and parsing JSON
extension MenuTVC {
    func loadData() {
        
        // Session Configuration
        let config = URLSessionConfiguration.default
        
        config.httpAdditionalHeaders = [
            "x-api-key": Constants.apiKey
        ]
        
        // Load configuration into Session
        let session = URLSession(configuration: config)
        
        if let url = URL(string: Constants.apiUrl) {
            
            let task = session.dataTask(with: url, completionHandler: {
                (data, response, error) in
                
                if error != nil {
                    
                    print(error!.localizedDescription)
                    
                } else {
                    
                    do {
                        
                        if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]
                        {
                            self.objects = self.parseJson(json: json)
                        }
                        
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                        
                    } catch {
                        
                        print("error in JSONSerialization")
                        
                    }
                    
                }
                
            })
            task.resume()
        }
    }
    
    func parseJson(json: [String: Any]) -> [Model] {
        var array: [Model] = []
        if let sections = json["navigationEntries"] as? [[String:Any]] {
            for section in sections {
                array.append(Model(json: section))
            }
        }
        return array
    }
}
