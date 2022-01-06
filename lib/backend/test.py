# from datetime import date
# from math import sqrt
# import numpy as np
# import statistics
# import pandas as pd
# from datetime import datetime as dt
# from nsepy import get_history
import pymongo
from stonkspy.StockAnalysis import StockAnalysis

symbols = ["HDFCLIFE"]
obj = StockAnalysis()
res = None
try:
    res = obj.get_analysis(symbols)
    print(res)
    # database_path = pymongo.MongoClient("mongodb://localhost:27017/")
    # db = database_path["stonks"]
    # collection = db["NIFTY"]
    # collection.update_one({"_id": res[1]["_id"]}, {"$set": res[1]}, upsert = True )
except IndexError:
    res = "No such symbol"
# def stockdate(year,month,day):
#     stock = get_history(symbol = "NIFTY",
#         start = date(year,month,day),
#         end = date(2021,5,5),
#         index = True)
#     l=[]
#     for index, row in stock.iterrows():
#         print(index, row['Close']) # Date and close price for that day
#         l.append(row['Close'])
#     return l
# #stvar=stock.var()
# #stockname=input("Enter stockname")
# #st = stock.pct_change().apply(lambda x: np.log(1+x))
# #st.head()
# #meanstock=st.sum()/st.count()
# #print(meanstock)
# #sqd= stock.apply(lambda x: (x-meanstock)**2)
# #sqd.head()
# #ssqd = sqd.sum()
# #var_stock=ssqd/(stock.count()-1)
# #print(stock.var())
# #print(np.sqrt(var_stock))
# #print(stname)
# #print(meanstock)
# ch=int(input("1. semi annually volatility, 2. annually,  3. 3 years volatility, 4. 5 year volatility "))
# l1=[]
# if ch==1:
#     l1=stockdate(2020,11,5)
#     avg=sum(l1)/len(l1)
#     variance = sqrt(np.var(l1))
#     annual = sqrt(126) * sqrt(variance)
#     print("the amount of deviation for current given time period is",annual)
#     a=(annual*100)/avg
#     print("The standard deviation in % is :",a)

# elif ch==2:
#     l1=stockdate(2020,5,5)
#     avg = sum(l1) / len(l1)
#     variance = sqrt(np.var(l1))
#     annual = sqrt(252) * sqrt(variance)
#     print("the amount of deviation for current given time period is",annual)
#     a = (annual * 100)/avg
#     print("The standard deviation in % is :", a)

# elif ch==3:
#     l1=stockdate(2018,5,7)
#     avg = sum(l1) / len(l1)
#     variance = sqrt(np.var(l1))
#     annual = sqrt(756) * sqrt(variance)
#     print("the amount of deviation for current given time period is",annual)
#     a = (annual * 100) / avg
#     print("The standard deviation in % is :", a)

# elif ch==4:
#     l1=stockdate(2016,5,6)
#     avg = sum(l1) / len(l1)
#     variance = sqrt(np.var(l1))
#     annual = sqrt(1260) * sqrt(variance)
#     print("the amount of deviation for current given time period is",annual)
#     a = (annual * 100) / avg
#     print("The standard deviation in % is :", a)

# else:
#     print("Invalid input")

# #yyy= sqrt(756)*variance
# #print("the 3 years volatility is ",yyy)
# #yyyyy= sqrt(1260)*variance
# #print("the volatilty for 5 years is",yyyyy)




# """
#         TODO Analysis for 6m, 1y, 3y and 5y
#         6m date: 2020-11-5
#         1y date: 2020-5-5
#         3y date: 2018-5-7
#         5y date: 2016-5-6
#     """