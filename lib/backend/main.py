from datetime import datetime
import timeit
from stonkspy.DatabaseHelper import DatabaseHelper as dbh



def main():
    start = timeit.default_timer()
    print()
    now = datetime.now()
    formatted_now = now.strftime("%d/%m/%Y %H:%M:%S")
    print("Starting process(Start date and time: " + formatted_now + ") .....")
    _path = "mongodb://localhost:27017/"
    _database_name = "stonks"
    dbh_obj = dbh(_path, _database_name)
    dbh_obj.store_data()
    stop = timeit.default_timer()
    time_taken = str(round((stop - start),2)) + "s)"
    print("Process finished (Time taken:", time_taken)
    print()



if __name__ == "__main__":
    main()
