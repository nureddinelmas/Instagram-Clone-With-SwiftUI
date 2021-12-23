//
//  Items.swift
//  Instagram-Clone
//
//  Created by Nureddin Elmas on 2021-12-23.
//

import Foundation
import FirebaseFirestoreSwift

struct Items : Codable, Identifiable {
    @DocumentID var id : String?
    var userName : String
    var imageUrl : String
    var comment : String
}
