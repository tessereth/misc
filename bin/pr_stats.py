#!/usr/bin/env python3

# Retrieve github pull requests statistics for a repo
#
# (c) 2016 Teresa Bradbury

import requests
import json
import argparse
import datetime
import csv
import os
import collections

def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument('-r', '--repo', help='github repository', default='ausdto/gov-au-beta')
    parser.add_argument('-o', '--outfile', help='file to put csv data', default='pr_stats.csv')
    parser.add_argument('-t', '--token', help='github access token', default=os.environ.get('GITHUB_TOKEN').strip())
    return parser.parse_args()
    
class PullRequest(object):
    
    timef = "%Y-%m-%dT%H:%M:%SZ"
    
    def __init__(self, json):
        self.json = json
        self.number = json['number']
        self.state = json['state']
        self.title = json['title']
        # some terminals do not like some unicode characters
        self.printable_title = self.title.encode('ascii', 'backslashreplace').decode()
        self.user = json['user']['login']
        self.created_at_s = json['created_at']
        self.created_at = datetime.datetime.strptime(self.created_at_s, self.timef)
        self.merged = json['merged']
        if self.merged:
            self.closed_at_s = json['closed_at']
            self.closed_at = datetime.datetime.strptime(self.closed_at_s, self.timef)
            self.merged_by = json['merged_by']['login']
            self.open_for = self.closed_at - self.created_at
        else:
            self.closed_at_s = None
            self.closed_at = None
            self.merged_by = None
            self.open_for = None
        # comments are for the general PR while review comments are for a particular line
        self.comments = json['comments'] + json['review_comments']
        self.additions = json['additions']
        self.deletions = json['deletions']
        self.changed_files = json['changed_files']
        
    @staticmethod
    def csv_header():
        return ['number', 'state', 'title', 'user', 'created_at', 'merged', 'closed_at', 
        'merged_by', 'comments', 'additions', 'deletions', 'changed_files', 'open_for']
        
    def to_csv(self):
        return map(str, 
            [self.number, self.state, self.title, self.user, 
            self.created_at_s, self.merged, self.closed_at_s, self.merged_by, self.comments,
            self.additions, self.deletions, self.changed_files, 
            self.open_for.total_seconds() if self.open_for is not None else None])
            
PullRequestTuple = collections.namedtuple('CachedPullRequest', PullRequest.csv_header())
class CachedPullRequest(PullRequestTuple):
    def to_csv(self):
        return map(str, 
            [self.number, self.state, self.title, self.user, 
            self.created_at, self.merged, self.closed_at, self.merged_by, self.comments,
            self.additions, self.deletions, self.changed_files, self.open_for])
            
    @property
    def printable_title(self):
        return self.title.encode('ascii', 'backslashreplace').decode()
        
def get_json(url, **kwargs):
    r = requests.get(url, **kwargs)
    r.raise_for_status()
    return r, r.json()
    
def get_pulls(args):
    req, data = get_json('https://api.github.com/repos/%s/pulls' % args.repo, 
    params={'access_token': args.token, 'state': 'all', 'sort': 'created', 'direction': 'asc'})
    page = 1
    print('Page %d: %d pull requests' % (page, len(data)))
    prs = {}
    # read current PRs from the file and assume closed PRs haven't changed
    try:
        with open(args.outfile, 'r', newline='') as f:
            old = csv.reader(f)
            old.__next__() # ignore header
            for row in old:
                pr = CachedPullRequest._make(row)
                if pr.state == 'closed':
                    prs[int(pr.number)] = pr
    except FileNotFoundError:
        pass
    with open(args.outfile, 'w', newline='') as f:
        out = csv.writer(f)
        out.writerow(PullRequest.csv_header())
        while True:
            for datum in data:
                if datum['number'] in prs:
                    print('Using cached version of #%d: %s' % (datum['number'], prs[datum['number']].printable_title))
                else:
                    pr = PullRequest(get_json(datum['url'], params={'access_token': args.token})[1])
                    print('#%d: %s' % (pr.number, pr.printable_title))
                    prs[pr.number] = pr
                out.writerow(prs[datum['number']].to_csv())
            try:
                next_url = req.links['next']['url']
            except KeyError:
                # no more pages
                break
            else:
                req, data = get_json(next_url)
                page += 1
                print('Page %d: %d pull requests' % (page, len(data)))
    print('all pull request data successfully written to %s' % args.outfile)
    
def main():
    get_pulls(parse_args())
    
if __name__=='__main__':
    main()

