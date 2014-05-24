#!/usr/bin/env python
"""
Chi-square test for independence between multiple histograms.
(c) Jack Peterson (jack@tinybike.net), 5/19/2014
"""
import os
from scipy.stats import chi2_contingency

class IndependenceTest(object):

    def __init__(self, datafiles, path='', significance_level=0.05):
        self.categories = ('persons', 'locations', 'orgs')
        self.path = path
        self.datafiles = datafiles
        self.significance_level = significance_level
        self.uni_x = {}
        self.uni_y = {}
        self.con_table = []

    def histograms(self):
        """Load data from files and calculate histograms"""
        for category in self.categories:
            hist = {}
            filepath = os.path.join(path, self.datafiles[category])
            with open(filepath) as datafile:
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
        X.extend(self.uni_x['persons'])
        X.extend(self.uni_x['locations'])
        X.extend(self.uni_x['orgs'])
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
        self.chi2, self.pval, self.dof, self.ex = chi2_contingency(self.con_table)
        self.result = 'independent' if self.pval < self.significance_level \
            else 'not independent'


def main():
    parameters = {
        'datafiles': {
            'persons': "freq_persons.txt",
            'locations': "freq_places.txt",
            'orgs': "freq_orgs.txt",
        },
        'path': '',
        'significance_level': 0.05,
    }
    IT = IndependenceTest(**parameters)
    IT.histograms()
    IT.contingency_table()
    IT.chisquare_independence_test()
    print "P =", IT.pval, "(" + IT.result + ")"

if __name__ == '__main__':
    main()
