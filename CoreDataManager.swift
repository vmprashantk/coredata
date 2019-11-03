
//

import UIKit
import CoreData

class CoreDataManager: NSObject {

    
   
    
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    class func shared()->CoreDataManager{
        
        struct Static{
            
            static let manager = CoreDataManager()
        }
        return Static.manager
    }
    
    
    
    func getCategory()->[BankerModel]{
        
        
        var bankerArray = [BankerModel]()
        
        let fetchRequest:NSFetchRequest<Category> = Category.fetchRequest()
        
        let sortDescriptior = NSSortDescriptor(key: "id", ascending: false)
        
        fetchRequest.sortDescriptors = [sortDescriptior]
        
        do{
            if let data = try context.fetch(fetchRequest) as? [Category]{
                
                
                for obj in data{
                    
                    if(obj.id != nil){
                    let objBanker = BankerModel()
                    objBanker.id = obj.id  ?? ""
                    objBanker.bankerImg = obj.imageUrl ?? ""
                    objBanker.bankerTitle = obj.title ?? ""
                    objBanker.playStoreIssueId = obj.playStoreIssueId ?? ""
                    objBanker.isDownload = obj.isDownload
                    objBanker.imgData = obj.imgData ?? nil
                 
                    bankerArray.append(objBanker)
                  
                    }
                }
                
            }
            else{
                
                
            }
            
        }
        catch{
            
            
        }
        
        return bankerArray
    }
    
    
    
    func updateCategory(id:String,data:Data){
        
        if let obj = getSelectedCategory(id: id){
            
            obj.imgData = data
            saveCotext()
            
        }
    }
    
    
    func saveCategory(obj:BankerModel){
        
        if  let category = NSEntityDescription.insertNewObject(forEntityName: "Category", into: context) as? Category{
        
            if(checkForDuplicate(type: "Category", id: obj.id)){
        category.id = obj.id
        category.imageUrl  = obj.bankerImg
        category.title = obj.bankerTitle
        category.playStoreIssueId = obj.playStoreIssueId
        saveCotext()
            }
            
        }
        
    }
    
    
    
    func saveCotext(){
        
        do{
          
            try context.save()
            
        }
        catch{
            
            
        }
    }
    
    
    
    func checkForDuplicate(type:String, id:String)->Bool{
        
      
        
        if(type == "Category"){
            
            let fetchRequest:NSFetchRequest<Category> = Category.fetchRequest()
            
            let predicate = NSPredicate(format: "id=%@",id)
            
            fetchRequest.predicate = predicate
            
            if let obj = try? context.fetch(fetchRequest) as? [Category]{
                
                if(obj?.count == 0){
                    
                    return true
                }
                else{
                    
                    return false
                }
            }
            else{
                
                return false
            }
            
        }
        else{
            
            let fetchRequest:NSFetchRequest<Detail> = Detail.fetchRequest()
            
            let predicate = NSPredicate(format: "id=%@",id)
            
            fetchRequest.predicate = predicate
            
            if let obj = try? context.fetch(fetchRequest) as? [Detail]{
                
                if(obj?.count == 0){
                    
                    return true
                }
                else{
                    
                    return false
                }
            }
            else{
                
                return false
            }
            
        }
        
        
        return false
        
    }
    
    
    func getSelectedCategory(id:String)->Category?{
        
        let fetchRequest:NSFetchRequest<Category> = Category.fetchRequest()
        
        let predicate = NSPredicate(format: "id=%@",id)
        
        fetchRequest.predicate = predicate
        
        if let obj = try? context.fetch(fetchRequest) as? [Category]{
            
            if(obj?.count == 0){
                
                return nil
            }
            else{
                
                return obj?.first
            }
        }
        else{
            
            return nil
        }
        
     
    }
    
    func getSelectedDetal(id:String)->Detail?{
        
        let fetchRequest:NSFetchRequest<Detail> = Detail.fetchRequest()
        
        let predicate = NSPredicate(format: "id=%@",id)
        
        fetchRequest.predicate = predicate
        
        if let obj = try? context.fetch(fetchRequest) as? [Detail]{
            
            if(obj?.count == 0){
                
                return nil
            }
            else{
                
                return obj?.first
            }
        }
        else{
            
            return nil
        }
        
        
    }
    
    
    func updateDownloadCategoryStatus(category:Category){
        
        category.isDownload = true
        saveCotext()
    }
    
    func updateDetail(data:Data?,id:String){
        
        if let htmlData = data{
        if let obj = getSelectedDetal(id: id){
            
            obj.htmlFile = htmlData
            obj.isDownload = true
            saveCotext()
            
        }
        }
        
    }
    
    
    func saveDetail(obj:DetailModel,category:Category){
        
        if  let detail = NSEntityDescription.insertNewObject(forEntityName: "Detail", into: context) as? Detail{
            
            if(checkForDuplicate(type: "Detail", id: obj.id)){
               
                detail.authorName = obj.authorName
                detail.itemCategory = obj.category
                detail.fullArticleURL = obj.fullArticaleUrl
                detail.id = obj.id
                detail.issueId = obj.issueId
                detail.imageBase64 = obj.imgUrl
                detail.shortDesciption = obj.subDescription
                detail.category = category
                detail.title = obj.title
                
                saveCotext()
            }
            
        }
        
    }
    
    
}
