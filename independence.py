#!/usr/bin/env python
"""
Chi-square test for independence for three (big) histograms.
(c) Jack Peterson (jack@tinybike.net), 5/19/2014
"""
from __future__ import division
from scipy.stats import chi2_contingency
from bunch import Bunch

class IndependenceTest(object):

    def __init__(self, datafiles):
        self.categories = ('persons', 'locations', 'orgs')
        self.datafiles = datafiles
        self.uni_x = Bunch()
        self.uni_y = Bunch()
        self.con_table = []

    def histograms(self):
        """Load data from files and calculate histograms"""
        for category in self.categories:
            hist = {}
            with open(self.datafiles[category]) as datafile:
                for line in datafile:
                    try:
                        data = int(line.strip())
                    except:
                        pass
                    hist[data] = hist[data] + 1 if data in hist else 1
            self.uni_x[category] = hist.keys()
            self.uni_y[category] = hist.values()

    def contingency_table(self):
        """Contingency table: persons | locations | organizations"""
        X = []
        X.extend(self.uni_x.persons)
        X.extend(self.uni_x.locations)
        X.extend(self.uni_x.orgs)
        X = sorted(list(set(X)))
        for x in X:
            row = [0, 0, 0]
            for i, category in enumerate(self.categories):
                if x in self.uni_x[category]:
                    idx = self.uni_x[category].index(x)
                    row[i] = self.uni_y[category][idx]
            if sum(row):
                self.con_table.append(row)

    def chisquare_independence_test(self):
        """Chi-squared test: if P < 0.05, then data sets are independent"""
        chi2, self.pval, dof, ex = chi2_contingency(self.con_table)
        self.result = 'independent' if self.pval < 0.05 else 'not independent'


def main():
    datafiles = Bunch({
        'persons': "freq_persons.txt",
        'locations': "freq_places.txt",
        'orgs': "freq_orgs.txt",
    })
    IT = IndependenceTest(datafiles)
    IT.histograms()
    IT.contingency_table()
    IT.chisquare_independence_test()
    print "P =", IT.pval, "(" + IT.result + ")"

if __name__ == '__main__':
    main()
