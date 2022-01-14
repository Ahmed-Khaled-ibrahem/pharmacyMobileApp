import requests
from bs4 import BeautifulSoup
import pandas as pd
import sqlite3
import time

df = pd.DataFrame(columns=['name' , "price" , "pic" , "details" , "marketName" , "scientificName" ])

startTime=time.time()

url = 'https://dalilaldwaa.com/medicine-list?'
r = requests.get(url)
html_doc = r.text
soup = BeautifulSoup(html_doc , features="html.parser")
all_items = soup.find_all("a", {"class": "page-link"})
pagesNum = int(all_items[-2].text) +1
print("number of pages in the site {}".format(pagesNum-1))

for i in range(1,pagesNum) :
    while True :
        try :
            url = 'https://dalilaldwaa.com/medicine-list?page={}'.format(i)
            r = requests.get(url)
            html_doc = r.text
            soup = BeautifulSoup(html_doc , features="html.parser")
            all_items = soup.find_all("div", {"class": "row cm-item"})
            print(i)
            break
        except :
            print("error in {}".format(i))
            time.sleep(2)
            df.to_csv("data.csv", encoding='utf-8' ,index=False)
            continue 

    for item in all_items : 
        while True :
            try : 
                main = item.find("img")
                name = main["alt"]
                img = main["src"]
                price = item.find("p", {"class": "color-gray"}).text.strip()
                details = item.find("a", {"class": "cm-details"})['href'].strip()
                
                detailsLink = "https://dalilaldwaa.com/" + str(details)
                r = requests.get(detailsLink)
                html_doc = r.text
                soup = BeautifulSoup(html_doc , features="html.parser")
                marketName = (soup.find("div" , {"class" : "even"}).text).replace("الإسم التجاري" , "").strip()
                scieceName = (soup.find_all("div" , {"class" : "odd"})[1].text).replace("الإسم العلمي" , "").strip()

                des = (soup.find("div" , {"class" : "tab-pane fade show active"}).text)
                df2 = {'name': name , 'price': price, 'pic': img , "details" : des , "marketName":marketName , "scientificName":scieceName }

                df = df.append(df2, ignore_index = True)
                break
            except :
                print("err")
                df.to_csv("data.csv", encoding='utf-8' ,index=False)
                time.sleep(2)

endTime=time.time()
print("Taked time {}".format(endTime-startTime))

print('the data has {} drug'.format(df.shape[0]))
print("data has {} duplicate drug".format(df.duplicated().sum()))
print(df.info())

conn = sqlite3.connect('data.db')
df.to_sql('data', conn, if_exists='replace', index=False)

df.to_csv("data.csv", encoding='utf-8' ,index=False)
