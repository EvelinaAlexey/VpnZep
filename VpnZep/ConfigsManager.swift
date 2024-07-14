//
//  Configs.swift
//  VpnZep
//
//  Created by Developer on 03.07.2024.
//

import Firebase
import FirebaseFirestoreSwift
import SwiftUI

//class ConfigsManager: ObservableObject {
//    let db = Firestore.firestore().collection("configs")
////    var id: String?
//    @AppStorage("selectedDocumentID") var selectedDocumentID: String = ""
//
//    func fetchRandomConfAndSetUsingToTrue(completion: @escaping (Result<Configs, Error>) -> Void) {
//        db.whereField("using", isEqualTo: false)
//            .getDocuments { [weak self] (querySnapshot, error) in
//                guard let self = self else { return }
//
//                if let error = error {
//                    completion(.failure(error))
//                    return
//                }
//
//                guard let documents = querySnapshot?.documents else {
//                    completion(.failure(NSError(domain: "AppErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Документы не найдены"])))
//                    return
//                }
//
//                if let randomDocument = documents.randomElement(),
//                   let documentID = randomDocument.documentID as String? {
//                    if let conf = randomDocument.data()["conf"] as? String {
////                        self.id = documentID
//                        let docRef = self.db.document(documentID)
//                        docRef.updateData(["using": true]) { error in
//                            if let error = error {
//                                completion(.failure(error))
//                            } else {
//                                let config = Configs(id: documentID, conf: conf, using: true)
//                                UserDefaults.standard.set(documentID, forKey: "selectedDocumentID")
//                                print(self.selectedDocumentID)
//                                completion(.success(config))
//                            }
//                        }
//                    } else {
//                        completion(.failure(NSError(domain: "AppErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Не удалось получить строку conf"])))
//                    }
//                } else {
//                    completion(.failure(NSError(domain: "AppErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Документ с using=false не найден"])))
//                }
//            }
//    }
//
//    func setUsingToFalse(completion: @escaping (Result<Void, Error>) -> Void) {
//        let id: String? = self.selectedDocumentID
////        print(self.id)
//
//        guard let documentID = id, !documentID.isEmpty else {
//            completion(.failure(NSError(domain: "AppErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Не выбран документ для обновления"])))
//            return
//        }
//        
//        let docRef1 = db.document(documentID)
//        docRef1.getDocument { (document, error) in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//        }
//
//        let docRef = self.db.document(documentID)
//        docRef.updateData(["using": false]) { error in
//            if let error = error {
//                completion(.failure(error))
//            } else {
//                completion(.success(()))
//            }
//        }
//    }
//    
//    func prin() {
//        print(self.selectedDocumentID)
//    }
//}

class ConfigsManager: ObservableObject {
    let db = Firestore.firestore().collection("configs")

    func fetchConfForCurrentUser(completion: @escaping (Result<String, Error>) -> Void) {
        guard let uid = FirebaseManager.shareds.auth.currentUser?.uid else {
            completion(.failure(NSError(domain: "AppErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Нет UID текущего пользователя"])))
            return
        }

        db.getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let documents = querySnapshot?.documents else {
                completion(.failure(NSError(domain: "AppErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Документы не найдены"])))
                return
            }

            var matchedConfig: Configs?
            var firstUnassignedConfig: Configs?
            let dispatchGroup = DispatchGroup()

            for document in documents {
                dispatchGroup.enter()

                do {
                    var config = try document.data(as: Configs.self)

                    if config.uid == uid {
                        matchedConfig = config
                        dispatchGroup.leave()
                        break
                    } else if config.uid == nil && firstUnassignedConfig == nil {
                        firstUnassignedConfig = config
                        firstUnassignedConfig?.uid = uid
                        document.reference.updateData(["uid": uid]) { error in
                            if let error = error {
                                completion(.failure(error))
                            } else {
                                dispatchGroup.leave()
                            }
                        }
                    } else {
                        dispatchGroup.leave()
                    }
                } catch {
                    dispatchGroup.leave()
                    completion(.failure(error))
                }
            }

            dispatchGroup.notify(queue: .main) {
                if let matchedConfig = matchedConfig {
                    completion(.success(matchedConfig.conf))
                } else if let firstUnassignedConfig = firstUnassignedConfig {
                    completion(.success(firstUnassignedConfig.conf))
                } else {
                    completion(.failure(NSError(domain: "AppErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Подходящая конфигурация не найдена"])))
                }
            }
        }
    }
}
