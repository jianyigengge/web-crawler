# -*- coding: utf-8 -*-
#!/usr/bin/env python
# encoding=utf-8
import pandas as pd
import requests
from bs4 import BeautifulSoup
import re


url = 'https://book.douban.com/top250'

headers = {'User-Agent': 'Mozilla/5.0 (Windows; U; Windows NT 5.1; zh-CN; rv:1.9.1.6)'}
html = requests.get(url,headers=headers).content

douban_book=[] 
soup = BeautifulSoup(html.decode('utf-8'),features="html.parser")
book_list_soup = soup.find('div',attrs={'class': 'indent'})

for book_table in book_list_soup.find_all('table'):
    detail = book_table.find('div',attrs={'class': 'pl2'})
    book={}
    book['book_name'] = detail.find('a').getText()
    book['book_name'] = re.sub("\n","",str(book['book_name']))
    book['book_name'] = re.sub("","",str(book['book_name']))
    book['book_info'] = book_table.find('p',attrs={'class':'pl'}).getText()
    douban_book.append(book)

df=pd.DataFrame(douban_book)    
df.to_csv('douban_book.csv',index=False)



