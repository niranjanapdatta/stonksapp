from datetime import date, datetime as dt


class TradingDate():


    """
        Generates estimated six month, one year, three year and five year ago dates
        using the current date(today's date)
    """
    @staticmethod
    def get_estimated_dates(end_date):
        # 6 months ago of every month
        six_months_prev_year = {1:7, 2:8, 3:9, 4:10, 5:11, 6:12}
        six_months = {7:1, 8:2, 9:3, 10:4, 11:5, 12:6}

        """
            exclude 1 and 7 because 6 months ago of 1 is 7 and 7 is 1 (i.e no change required for day)
            exclude 8 because 6 months ago of 8 is 2(February), requires different calculation
        """
        thirty_one_day_months = [3, 5, 10, 12]
        temp_end_day = end_date.day

        # Estimating nearest dates for 6 months, 1 year, 3 years and 5 years ago from today's date(end_date)
        if end_date.month == 8 and end_date.day > 28: # Ignoring calculation for leap years and considering last day of February as 28th
            temp_end_day = 28
        elif end_date.day == 31 and end_date.month in thirty_one_day_months:
            temp_end_day = 30

        if end_date.month in six_months_prev_year.keys():
            six_months_start_date = date((end_date.year - 1), six_months_prev_year.get(end_date.month), temp_end_day)
        else:
            six_months_start_date = date(end_date.year, six_months.get(end_date.month), temp_end_day)

        if end_date.month == 2 and end_date.day == 29: # Round down day to 28 for February
            temp_end_day = 28
        else:
            temp_end_day = end_date.day

        if end_date.month == 2 and end_date.day == 29:
            temp_end_day = 28 # Ensuring that leap year day is reduced to 28 since 1, 3, 5 year ago from end_day might not be leap year

        one_year_start_date = date((end_date.year - 1), end_date.month, temp_end_day)

        three_year_start_date = date((end_date.year - 3), end_date.month, temp_end_day)

        five_year_start_date = date((end_date.year - 5), end_date.month, temp_end_day)

        return six_months_start_date, one_year_start_date, three_year_start_date, five_year_start_date


    """
        Generates accurate trading date using the provided trading dates list and a start_date
        Method to find the nearest trading date to a given date
        Given date is incremented until it's equal to a trading date
        Parameters:
            dates => List of datetime.date containing all the trading dates in a particular period, here the last element of dates is considered as current date
            start_date => Estimated start date for n days/ months/ years ago from current date
    """
    @staticmethod
    def get_nearest_trading_date(dates, start_date):
        while start_date not in dates:
            if start_date > dates[(len(dates) - 1)]: # If date is the last available trading date in dates
                print("Error: Nearest trading date does not exist for the specified 'start_date'")
                return None
            try:
                start_date = date(start_date.year, start_date.month, (start_date.day + 1)) # Increment day by 1
            except ValueError: # If day > last day of month
                try:
                    start_date = date(start_date.year, (start_date.month + 1), 1) # Increment Month by 1 and set day to 1
                except ValueError: # If month > 12
                    start_date = date((start_date.year + 1), 1, 1) # Increment Year by 1 and set month, day to 1
        return start_date