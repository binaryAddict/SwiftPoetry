//
//  PoetryStubs.swift
//  SwiftPoetry
//
//  Created by Dominic Campbell on 23/10/2024.
//

import Foundation

enum PoetryStubs {
    static let authorJonathanSwift = "Jonathan Swift"
    
    static let authors = [String].readTestJSONFile("Authors")
    static let jonathanSwiftPoems = [Poem].readTestJSONFile("Poems/Jonathan Swift")
    static let johnMcCraePoems = [Poem].readTestJSONFile("Poems/John McCrae")
    static let williamShakespearePoems = [Poem].readTestJSONFile("Poems/William Shakespeare")
    
    static let shortListOfPoems = johnMcCraePoems
    static let longListOfPoems = williamShakespearePoems
    static let listOfPoemsWithLongPoem = jonathanSwiftPoems
    
    static let longPoem = listOfPoemsWithLongPoem[1]
    static let shortPoem = shortListOfPoems[0]
}
