//
//  GCDBlackBox.swift
//  Brews
//
//  Created by Michael Doroff on 6/16/17.
//  Copyright © 2017 Michael Doroff. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
