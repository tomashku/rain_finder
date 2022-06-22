//
//  CoreDataViewModel.swift
//  rain_finder
//
//  Created by Tomasz Zuczek on 22/06/2022.
//

import CoreData

class CoreDataViewModel: ObservableObject{
    
    let container: NSPersistentContainer
    @Published var savedEntities: [AirportEntity] = []
    var csvModel: [String] = []
    
    init(){
        container = NSPersistentContainer(name: "Airports")
        container.loadPersistentStores{ (description, error) in
            if error != nil{
                print("error loading core data")
            }else{
                print("core data loaded successfully")
            }
            fetchAirport()
            readCsv(urlString: "https://davidmegginson.github.io/ourairports-data/airports.csv")
            populateDataBase(csvModel: self.csvModel)
        }
        func fetchAirport(){
            let request = NSFetchRequest<AirportEntity>(entityName: "AirportEntity")
            do{
                savedEntities = try container.viewContext.fetch(request)
            }catch let error{
                print("error fetching \(error)")
            }
        }
        
        func addAirport(ident: String, type: String, name: String, latitude_deg: String, longitude_deg: String){
            let newAirport = AirportEntity(context: container.viewContext)
            newAirport.ident = ident
            newAirport.type = type
            newAirport.name = name
            newAirport.latitude_deg = latitude_deg
            newAirport.longitude_deg = longitude_deg
            saveData()
        }
        
        func readCsv(urlString: String) {
            
            let url = URL(string: urlString)
            let task = URLSession.shared.downloadTask(with: url!) { (localURL, urlResponse, error) in
                if let localURL = localURL {
                    if let urlContents = try? String(contentsOf: localURL)  {
                        self.csvModel = urlContents.components(separatedBy: "\n").dropFirst().dropLast()
                    }
                }
            }
            task.resume()
            
        }
        
        func populateDataBase(csvModel: [String]){
            for column in csvModel{
                let data = column.components(separatedBy: ",")
                addAirport(ident: data[1], type: data[2], name: data[3], latitude_deg: data[4], longitude_deg: data[5])
            }
        }
        
        func saveData(){
            do {
                try container.viewContext.save()
                fetchAirport()
            } catch let error{
                print("error saving \(error)")
            }
            
        }
    }
}

