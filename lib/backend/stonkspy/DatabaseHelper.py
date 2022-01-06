import timeit
import pymongo
from stonkspy.StockAnalysis import StockAnalysis as sa


class DatabaseHelper():


    def __init__(self, path, database_name):
        try:
            self.database_path = pymongo.MongoClient(path)
            self.db = self.database_path[database_name]
            print("Connection to MongoDB database - stonks has been established")
        except:
            print("Error: Could not connect to the database")

    def get_stock_symbols(self):
        print("Fetching list of symbols from SYMBOLS collection.....")
        start = timeit.default_timer()
        symbols_collection = self.db["SYMBOLS"]
        indices = symbols_collection.find({"is_index": True})
        _symbols = {}
        for index in indices:
            _symbols.update({index["_id"]: [index["_id"]]}) # Ensuring that the market standard is always the first in the symbols list
        symbols = symbols_collection.find({"is_index": False})
        for symbol in symbols:
            curr_symbols_list = _symbols.get(symbol["market_standard"])
            curr_symbols_list.append(symbol["_id"])
            _symbols.update({symbol["market_standard"]: curr_symbols_list})
        stop = timeit.default_timer()
        time_taken = str(round((stop - start),2)) + "s)"
        print("All symbols have been fetched successfully (Time taken:", time_taken)
        return _symbols


    def store_data(self):

        all_symbols = self.get_stock_symbols()
        market_standards_collection = self.db["MARKETSTANDARDS"]
        analysis_obj = sa()
        for symbol in all_symbols.keys():
            market_standards_collection.update({"_id": symbol}, {"$set": {"_id": symbol}}, upsert = True )
            print("Symbol", symbol, "has been updated to MARKETSTANDARDS collection")
            print("Starting analysis for symbols which have", symbol, "as their market standard.....")
            start = timeit.default_timer()
            symbols_list = all_symbols.get(symbol)
            all_stocks_collection = self.db[symbol]
            all_stocks_data = analysis_obj.get_analysis(symbols_list, symbol)
            stop = timeit.default_timer()
            time_taken = str(round((stop - start),2)) + "s)"
            print("Analysis for symbols which have", symbol, "as their market standard has been completed (Time taken:", time_taken)
            print("Storing the analysis data in database .....")
            start = timeit.default_timer()
            for stock_data in all_stocks_data:
                all_stocks_collection.update_one({"_id": stock_data["_id"]}, {"$set": stock_data}, upsert = True )
            stop = timeit.default_timer()
            time_taken = str(round((stop - start),2)) + "s)"
            print("Data has been successfully stored in", symbol, "collection (Time taken:", time_taken)
        self.database_path.close()
        print("Connection to MongoDB database - stonks has been closed")
