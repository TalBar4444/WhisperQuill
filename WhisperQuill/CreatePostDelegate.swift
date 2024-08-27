//
//  CreatePostDelegate.swift
//  WhisperQuill
//
//  Created by Tal Bar on 27/08/2024.
//

import Foundation

protocol CreatePostDelegate: AnyObject {
    func didCreatePost(_ post: Post)
}
