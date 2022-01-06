import timeit
from datetime import date, datetime as dt
from nsepy import get_history
from stonkspy.TradingDate import TradingDate as td
from statistics import stdev
from math import sqrt
from numpy import var as numpy_variance

class StockAnalysis():


    def get_market_standard_variance(self, market_standard_volatility_list, count):
        average_volatility_market_standard = sum(market_standard_volatility_list) / count
        summation_xi_average = sum([pow((i - average_volatility_market_standard), 2) for i in market_standard_volatility_list])
        return summation_xi_average / (count - 1)

    def get_analysis(self, symbols, market_standard = "NIFTY"):
        all_stocks_data = []
        date_today = dt.now()
        end_date = date(date_today.year, date_today.month, date_today.day) # end_date => today's date
        market_standard_variance_dict = {}

        six_months_start_date, one_year_start_date, three_year_start_date, five_year_start_date = td.get_estimated_dates(end_date)
        if market_standard not in symbols:
            symbols.insert(0, market_standard)

        for symbol in symbols:
            success = False
            if symbol == market_standard:
                is_index = True
            else:
                is_index = False
            print("Fetching data for", symbol, "using nsepy ...")
            start = timeit.default_timer()
            nsepy_data = get_history(symbol = symbol,
                        start = five_year_start_date,
                        end = end_date,
                        index = is_index)
            stop = timeit.default_timer()
            time_taken = str(round((stop - start),2)) + "s)"
            if len(nsepy_data.index) == 0:
                print("Failed to fetch data for", symbol, "! Analysis cannot be performed. Time taken:", time_taken)
            else:
                print("Successfully fetched data for", symbol, "(Time taken:", time_taken)
                print("Performing analysis for", symbol,"...")
                success = True
                start = timeit.default_timer()
            prices = []
            dates = []
            curr_index = 0
            nsepy_data_len = len(nsepy_data) - 1
            for index, row in nsepy_data.iterrows():
                prices.append(row['Close'])
                dates.append(index)
                if curr_index == nsepy_data_len:
                    is_bullish = 0 # 0 => Bearish, 2 => No Change, and 1 => Bullish
                    if row['Close'] > last_close_price:
                        is_bullish = 1
                    elif row['Close'] == last_close_price:
                        is_bullish = 2
                    data = {"_id": symbol, "date": str(index), "close": row['Close'], "is_bullish": is_bullish}
                elif curr_index == (nsepy_data_len - 1):
                    last_close_price = row['Close'] 
                curr_index += 1

            six_months_start_date = td.get_nearest_trading_date(dates, six_months_start_date)

            one_year_start_date = td.get_nearest_trading_date(dates, one_year_start_date)

            three_year_start_date = td.get_nearest_trading_date(dates, three_year_start_date)

            """
                Consider the 2nd earliest trading date for trading date five years ago
                since we do not calculate volatality for the earliest trading date
            """
            temp_five_year_start_date = dates[1] 

            start_dates = {six_months_start_date: "sm", one_year_start_date: "oy", three_year_start_date: "ty", temp_five_year_start_date: "fy"}

            """
                volatility cannot be calculated for the earliest date since the close price of it's 
                previous trading date is not available in the prices list
                volatility => percent change in price from day[i - 1] to day[i]
            """
            volatility = [ round((((prices[index] - prices[index - 1]) / prices[index - 1]) * 100), 4) for index in range(len(prices)) if index != 0 ]
            if symbol == market_standard:
                volatility_market_standard = volatility
                temp_market_standard_volatility_list = []

            count = 0 # number of dates covered
            # temp_sum = 0 # sum of volatality upto dates[i + 1]
            temp_sum_covariance = 0 # sum of covariance(stock[i], market_standard50) upto dates[i + 1]
            up = 0 # current close > previous close
            prices_up = []
            down = 0 # current close < previous close
            prices_down = []
            no_change = 0 # current close = previous close

            for i in range((len(volatility) - 1), -1, -1):
                if prices[i + 1] > prices[i]:
                    prices_up.append(prices[i + 1] - prices[i])
                    up += 1
                elif prices[i + 1] < prices[i]:
                    down += 1
                    prices_down.append(prices[i] - prices[i + 1])
                else:
                    no_change += 1


                if symbol == market_standard:
                    temp_market_standard_volatility_list.append(volatility[i])

                # temp_sum += volatility[i]
                temp_sum_covariance += (volatility[i] * volatility_market_standard[i])
                count += 1

                if dates[i + 1] in start_dates.keys():
                    if symbol == market_standard:
                        variance_market_standard = self.get_market_standard_variance(temp_market_standard_volatility_list, count)
                        market_standard_variance_dict.update({dates[i + 1]: variance_market_standard})
                    average_price_for_time_period = sum(prices[i + 1:]) / len(prices[i + 1:])
                    variance_for_time_period = sqrt(numpy_variance(prices[i + 1:]))
                    deviation_for_time_period = sqrt(len(prices[i + 1:])) * sqrt(variance_for_time_period)
                    standard_deviation_for_time_period = (deviation_for_time_period * 100) / average_price_for_time_period # Volatility for the time period
                    covariance = temp_sum_covariance / (count - 1)
                    try:
                        beta = round(covariance / market_standard_variance_dict.get(dates[i + 1]), 2)
                    except TypeError:
                        beta = -100
                    _date = start_dates.get(dates[i + 1]) + "_date"
                    _close = start_dates.get(dates[i + 1]) + "_close"
                    _volatility = start_dates.get(dates[i + 1]) + "_volatility"
                    _beta = start_dates.get(dates[i + 1]) + "_beta"
                    _price_up = start_dates.get(dates[i + 1]) + "_price_up"
                    _avg_prices_up = start_dates.get(dates[i + 1]) + "_avg_price_up"
                    _price_down = start_dates.get(dates[i + 1]) + "_price_down"
                    _avg_prices_down = start_dates.get(dates[i + 1]) + "_avg_price_down"
                    # round((temp_sum / count), 4) => old volatility calculation formula
                    data.update({_date: str(dates[i + 1]), _close: prices[i + 1], _volatility: round(standard_deviation_for_time_period, 4), \
                    _beta: beta, _price_up: up, _avg_prices_up: (round((sum(prices_up)/ len(prices_up)), 2)), _price_down: down, 
                    _avg_prices_down: (round((sum(prices_down)/ len(prices_down)), 2))})
                    del start_dates[dates[i + 1]]
            all_stocks_data.append(data)
            if success is True:
                stop = timeit.default_timer()
                time_taken = str(round((stop - start),2)) + "s)"
                print("Analysis for", symbol, "has been successfully completed (Time taken:", time_taken)
        return all_stocks_data
