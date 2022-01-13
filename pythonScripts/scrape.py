import requests
from bs4 import BeautifulSoup
import pandas as pd
import time
 
 # https://dalilaldwaa.com/

df = pd.DataFrame(columns=['name' , "price" , "pic" , "details"])

errorList = []
for i in range(1,2271) :
    try :
        url = 'https://dalilaldwaa.com/medicine-list?page={}'.format(i)
        r = requests.get(url)
        html_doc = r.text
        soup = BeautifulSoup(html_doc , features="html.parser")
        all_items = soup.find_all("div", {"class": "row cm-item"})
        print(i)
    except :
        print("error in {}".format(i))
        errorList.append(i)
        time.sleep(2)
        df.to_csv("data.csv", encoding='utf-8' ,index=False)
        continue 

    for item in all_items : 
        try : 
            main = item.find("img")
            name = main["alt"]
            img = main["src"]
            price = item.find("p", {"class": "color-gray"}).text.strip()
            details = item.find("a", {"class": "cm-details"})['href'].strip()
            df2 = {'name': name , 'price': price, 'pic': img , "details" : details}
            df = df.append(df2, ignore_index = True)
        except :
            print("err")
            df.to_csv("data.csv", encoding='utf-8' ,index=False)

df.to_csv("data.csv", encoding='utf-8' ,index=False)
print(errorList)       
