import Cocoa
import SwiftThinkBayes

// From Chapter 3 of Think Bayes
// *****************************

// Suppose I have a box of dice that contains a 4-sided die, a 6-sided die,
// an 8-sided die, a 12-sided die, and a 20-sided die ... Suppose I select
// a die from the box at random, roll it, and get a 6.  What is the
// probability that I rolled each die?

class Dice : Suite<Int, Int> {
    override func likelihood(data: Int, hypo: Int) throws -> Double {
        if hypo < data {
            return 0
        } else {
            return 1.0 / Double(hypo)
        }
    }
}

let suite = Dice(hypos: [4, 6, 8, 12, 20])

try suite.update(data: 6)
print("After rolling once:")
suite.print()

// What if we roll a few more times and get 6, 8, 7, 7, 5, and 4?

for roll in [6, 8, 7, 7, 5, 4] {
    try suite.update(data: roll)
}
print("\nAfter rolling six more times:")
suite.print()




// Incomplete example
// ******************

// Given a sample of values, what would be appropriate parameters for
// a Normal distribution that might generate those values?

let data = [3.89, 2.50, 3.78, 4.37, 3.15, 3.66, 3.89, 3.14, 3.05, 4.21,
            3.65, 3.09, 2.88, 3.80, 3.47, 3.19, 3.93, 4.02, 3.79, 3.81,
            4.24, 3.67, 3.68, 2.99, 3.09, 3.92, 3.73, 4.15, 4.67, 3.79]

// The above values were created by R from a distribution with mean of 3.5
// and a standard deviation of 0.5.  They were rounded to two decimal
// places.

// Traditionally, you would find the mean and standard deviation of the
// sample:
/* R code
 > mean(x)
 [1] 3.64
 > sd(x)
 [1] 0.4939356
 */

// Using a Bayesian approach, you might try the following:

