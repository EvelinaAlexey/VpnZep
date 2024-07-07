//
//  Configs.swift
//  VpnZep
//
//  Created by Developer on 03.07.2024.
//

import Firebase
import FirebaseFirestoreSwift

class ConfigsManager: ObservableObject {
    let db = Firestore.firestore().collection("configs")
    var selectedDocumentID: String?

    func fetchRandomConfAndSetUsingToTrue(completion: @escaping (Result<Configs, Error>) -> Void) {
        db.whereField("using", isEqualTo: false)
            .getDocuments { [weak self] (querySnapshot, error) in
                guard let self = self else { return }

                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let documents = querySnapshot?.documents else {
                    completion(.failure(NSError(domain: "AppErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Документы не найдены"])))
                    return
                }

                if let randomDocument = documents.randomElement(),
                   let documentID: String? = randomDocument.documentID {
                    if let conf = randomDocument.data()["conf"] as? String {
                        self.selectedDocumentID = documentID
                        let docRef = self.db.document(documentID!)
                        docRef.updateData(["using": true]) { error in
                            if let error = error {
                                completion(.failure(error))
                            } else {
                                let config = Configs(id: documentID, conf: conf, using: true)
//                                print(config)
                                
                                completion(.success(config))
                            }
                        }
                    } else {
                        completion(.failure(NSError(domain: "AppErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Не удалось получить строку conf"])))
                    }
                } else {
                    completion(.failure(NSError(domain: "AppErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Документ с using=false не найден"])))
                }

            }
    }

    func setUsingToFalse(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let documentID = self.selectedDocumentID else {
            completion(.failure(NSError(domain: "AppErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Не выбран документ для обновления"])))
            return
        }

        let docRef = self.db.document(documentID)
        docRef.updateData(["using": false]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}

