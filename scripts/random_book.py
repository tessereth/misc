# To run:
# pip install virtualenv
# virtualenv venv
# . venv/bin/activate # linux
# venv\Scripts\activate # windows
# pip install -r requirements.txt
# python random_book.py -s [subdomain]
# deactivate

import os
import random
import requests
import time
import webbrowser
from bs4 import BeautifulSoup
import argparse
import urllib
import json

def categories():
    return {
        'romance': { 'category': 'fgm' },
        'fantasy': { 'category': 'fgk' }
    }

def parse_args():
    parser = argparse.ArgumentParser()
    group = parser.add_mutually_exclusive_group()
    group.add_argument('-r', '--romance', action='store_const', const='romance', dest='category')
    group.add_argument('-f', '--fantasy', action='store_const', const='fantasy', dest='category')
    parser.add_argument('-s', '--subdomain', default=os.getenv('SUBDOMAIN'))
    parser.set_defaults(category='romance')
    return parser.parse_args()

class BookRandomizer(object):
    def __init__(self):
        self.args = parse_args()
        self.__num_pages = None
        self.cache_file = '.num_pages'
        self.load_cache()
        
    def load_cache(self):
        if os.path.exists(self.cache_file):
            with open(self.cache_file) as f:
                self.num_pages_cache = json.load(f)
        else:
            self.num_pages_cache = {}
            
    def save_cache(self):
        with open(self.cache_file, 'w') as f:
            json.dump(self.num_pages_cache, f)
    
    def search_page_url(self, page=1):
        params = { 'scope': 'available', 'sort': 'added', 'page': page }
        params.update(categories()[self.args.category])
        return 'https://%s.wheelers.co/browse?%s' % (self.args.subdomain, urllib.parse.urlencode(params))

    def get_list_html(self, page=1):
        return BeautifulSoup(requests.get(self.search_page_url(page)).text, 'lxml')
        
    def get_book_list(self, page=1):
        soup = self.get_list_html(page)
        return list(map(lambda x: x.h3.a.get('href'),
            soup.find_all('div', class_='gallery-desc')))

    def num_pages(self):
        if self.args.category in self.num_pages_cache:
            if time.time() - self.num_pages_cache[self.args.category]['updated_at'] < 3600:
                return self.num_pages_cache[self.args.category]['num_pages']
        total = self.get_list_html().find('div', class_='summary-total').span.b.get_text().replace(',', '')
        # integer division, rounded up
        pages = (int(total) + 29) // 30
        self.num_pages_cache[self.args.category] = {'num_pages': pages, 'updated_at': time.time()}
        self.save_cache()
        return pages
        
    def open_random_page(self):
        print('finding a random list of %s books...' % self.args.category)
        page = random.randint(1, self.num_pages())
        print('opening page %i' % page)
        webbrowser.open(self.search_page_url(page))
        
def main():
    BookRandomizer().open_random_page()

if __name__=='__main__':
    main()