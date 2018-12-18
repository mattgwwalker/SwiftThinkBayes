//
//  odds.swift
//  SwiftThinkBayes
//
//  Created by Matthew Walker on 18/12/18.
//  Copyright © 2018 Matthew Walker. All rights reserved.
//

import Foundation

/**
 Computes odds for a given probability.

 Example: p=0.75 means 75 for and 25 against, or 3:1 odds in favor.

 Note: when p=1, the formula for odds divides by zero, which is
 normally undefined.  But I think it is reasonable to define Odds(1)
 to be infinity, so that's what this function does.

 - Parameters:
    - p: probability between 0 and 1, inclusive

 - Returns: odds
*/
func odds(_ p: Double) -> Double {
    if p == 1 {
        return Double.infinity
    }
    return p / (1 - p)
}


/**
 Computes the probability corresponding to given odds.

 Example: o=2 means 2:1 odds in favor, or 2/3 probability

 - Parameters:
    - o: Odds, strictly positive

 - Returns: probability
*/
func probability(_ o: Double) -> Double {
    return o / (o + 1)
}


/**
 Computes the probability corresponding to given odds.

 Example: yes=2, no=1 means 2:1 odds in favor, or 2/3 probability.

 - Parameters:
    - yes: odds in favour
    - no: odds against
*/
func probability2(yes: Double, no: Double) -> Double {
    return yes / (yes + no)
}
