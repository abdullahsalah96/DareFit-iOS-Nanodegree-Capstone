import Foundation
import Firebase

class Challenges{
    private static let db = Firestore.firestore() //firestore database
    
    class func subscribeToChallenge(firstName:String, lastName:String, long:Double, lat:Double, uid:String, challenge:String, completion: @escaping (String?)->Void){
        //check if user already subscribed
        db.collection(challenge).whereField("uid", isEqualTo: CurrentUser.currentUser.uid).getDocuments { (querySnapshot, error) in
            //check if there's error connecting to server
            guard error == nil else{
                DispatchQueue.main.async {
                    completion(error?.localizedDescription)
                }
                return
            }
            guard querySnapshot!.count == 0 else{
                //user already exists
                DispatchQueue.main.async {
                    completion("Already Subscribed")
                }
                return
            }
            //subscribe user
            db.collection(challenge).document(CurrentUser.currentUser.uid).setData([
                "firstName":firstName,
                "lastName":lastName,
                "longitude":long,
                "latitude":lat,
                "uid": uid
            ]) { (error) in
                guard error==nil else{
                    //error subscribing to challenge
                    DispatchQueue.main.async {
                        completion(error!.localizedDescription)
                    }
                    return
                }
                //subscribed successfully
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
    
    class func unsubscribeFromChallenge(uid:String, challenge:String, completion: @escaping (String?)->Void){
        //check if user is subscribed
        print(CurrentUser.currentUser.uid)
        db.collection(challenge).whereField("uid", isEqualTo: CurrentUser.currentUser.uid).getDocuments { (querySnapshot, error) in
            //check if there's error connecting to server
            guard error == nil else{
                DispatchQueue.main.async {
                    completion(error?.localizedDescription)
                }
                return
            }
            print(querySnapshot!.documents.count)
            guard querySnapshot!.documents.count > 0 else{
                //user not subscribed
                print("user not subscribed")
                DispatchQueue.main.async {
                    completion("Not Subscribed")
                }
                return
            }
            //delete user
            db.collection(challenge).document(CurrentUser.currentUser.uid).delete { (error) in
                guard error == nil else{
                    //error deleting user
                    DispatchQueue.main.async {
                        completion(error?.localizedDescription)
                    }
                    return
                }
                DispatchQueue.main.async {
                    //deleted successfuly
                    print("Deleted")
                    completion(nil)
                }
            }
        }
    }
    
    class func getChallengeUsers(challenge: String, completion: @escaping ([User]?, String?)->Void){
        var users:[User]? = []
        db.collection(challenge).getDocuments { (querySnapshot, error) in
            guard error == nil else{
                //error getting users data
                DispatchQueue.main.async {
                    completion(nil, error?.localizedDescription)
                }
                return
            }
            guard querySnapshot != nil else{
                //no users subscribed
                DispatchQueue.main.async {
                    completion(users, nil)
                }
                return
            }
            //get subscribed users in background
            let q = DispatchQueue.global()
            q.async {
                for doc in querySnapshot!.documents{
                    //append user to users list
                    let uid = doc.data()["uid"] as! String
                    let firstName = doc.data()["firstName"] as! String
                    let lastName = doc.data()["lastName"] as! String
                    let longitude = doc.data()["longitude"] as! Double
                    let latitude = doc.data()["latitude"] as! Double
                    let user = User(firstName: firstName, lastName: lastName, uid: uid, longitude: longitude, latitude: latitude)
                    users!.append(user)
                }
                //done appending users
                DispatchQueue.main.async {
                    completion(users, nil)
                }
            }
        }
    }
}