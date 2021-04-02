//
//  NowPlayingTableViewCell.swift
//  TMDB-sample-app
//
//  Created by Amol Dumrewal on 02/04/21.
//

import Foundation
import SwiftUI

class NowPlayingTableViewCell: UITableViewCell {
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configure(with movieModel: MovieInfoModel) {
        backgroundColor = .clear
        textLabel?.text = movieModel.title
        textLabel?.textColor = .white
    }
}
