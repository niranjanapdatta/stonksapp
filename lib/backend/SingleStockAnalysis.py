import pymongo
import sys
from stonkspy.StockAnalysis import StockAnalysis


symbol = sys.argv[1]
market_standard = sys.argv[2]
print(symbol)
obj = StockAnalysis()
status = "STATUS: FAILED"
try:
    res = obj.get_analysis([symbol], market_standard)
    database_path = pymongo.MongoClient("mongodb://localhost:27017/")
    db = database_path["stonks"]
    collection = db[market_standard]
    collection.update_one({"_id": res[1]["_id"]}, {"$set": res[1]}, upsert = True )
    status = "STATUS: SUCCESS"
except IndexError:
    status = "STATUS: FAILED"
print(status)